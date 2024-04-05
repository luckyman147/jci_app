import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions.dart';
import 'package:mime/mime.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Teams/data/models/TaskModel.dart';
import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';
import 'package:jci_app/features/Teams/domain/entities/Task.dart';
import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';

import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../domain/entities/Team.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../bloc/GetTeam/get_teams_bloc.dart';
import '../bloc/TaskIsVisible/task_visible_bloc.dart';

bool doesObjectExistInList(List<Member> list, Member targetObject) {
  return list.any((element) => element.id == targetObject.id)||list.contains(targetObject);
}
List<String> getIds(List<Member> objects) {
  if (objects.isEmpty || objects == null  ) {
    return [];
  }
  return objects.map((obj) => obj.id ).toList();
}
void changeInitTeams(BuildContext context,Privacy privacy,bool isPrivate) {
  log(isPrivate.toString()  );
  context.read<TaskVisibleBloc>().add(changePrivacyEvent(privacy));

  // Dispatch event to initialize GetTeamsBloc and fetch teams with updated privacy
  context.read<GetTeamsBloc>().add(initStatus());
  context.read<GetTeamsBloc>().add(GetTeams(isPrivate: isPrivate));
}
void searchFunction(String value, BuildContext context,bool isPrivate) {
  if (value.isEmpty){
    context.read<GetTeamsBloc>().add(GetTeams(isPrivate: isPrivate));
  }

  else{
    context.read<GetTeamsBloc>().add(GetTeamByName(
        {"name": value}));}
}
List<int> generateNumbers(int num) {
  return List.generate(num, (index) => num - index + 1).reversed.toList();
}
List<Map<String, dynamic>> mapObjects(List<Tasks> objects) {
  return objects.map((object) => {'id': object.id, 'isCompleted': object.isCompleted}).toList();
}
List<Map<String, dynamic>> mapChecklist(List<CheckList> objects) {
  return objects.map((object) => {'id': object.id, 'isCompleted': object.isCompleted,"name":object.name,"IsUpdated":false}).toList();
}Map<String, dynamic> mapTeam(Team objects) {
  return {'id': objects.id, 'name': objects.name,
    "CoverImage":objects.CoverImage,
    "TeamLeader":objects.TeamLeader,

    'description': objects.description, 'status': objects.status, 'Members': objects.Members,};
}
List<Map<String, dynamic>> filterCompletedTasks(List<Map<String, dynamic>> tasks) {
  return tasks.where((task) => task['isCompleted']).toList();
}List<Map<String, dynamic>> filterPendingTasks(List<Map<String, dynamic>> tasks) {
  return tasks.where((task) => !task['isCompleted']).toList();
}
int getIndexById(String id, List<Map<String, dynamic>> list) {
  for (int i = 0; i < list.length; i++) {
    if (list[i]['id'] == id) {
      return i;
    }
  }
  // If the id is not found in any map, return -1
  return -1;
}

Map<String, dynamic> toMap(Tasks object) {
  return {'id': object.id, 'isCompleted': object.isCompleted, 'name': object.name,"willDeleted":false, "WillUpdated":false,
    'description': object.description, 'StartDate': object.StartDate, 'Deadline': object.Deadline, 'AssignTo': object.AssignTo,
    'attachedFile': object.attachedFile.map((e) => toMapFile(e)).toList(), 'CheckLists': object.CheckLists.map((e) => toMapChecklist(e)),};
}
List<String> getidsObTask(List<Tasks> objects) {
  if (objects.isEmpty || objects == null  ) {
    return [];
  }
  return objects.map((obj) => obj.id ).toList();
}
Map<String, dynamic> toMapFile(TaskFile object) {
  return {'id': object.id, 'path': object.path, 'url': object.url, 'extension':object.extension};
}
Map<String, dynamic> toMapChecklist(CheckList object) {
  return {'id': object.id, 'isCompleted': object.isCompleted, 'name': object.name,};
}
Map<String, dynamic> toMapMember(Member object) {
  return {'id': object.id, 'firstName': object.firstName, 'Images': object.Images,};
}
List<Map<String, dynamic>> convertIdKey(List<dynamic> inputList) {
  List<Map<String, dynamic>> resultList = [];

  for (var item in inputList) {
    if (item is Map<String, dynamic>) {
      if (item.containsKey('_id')) {
        var idValue = item['_id'];
        item.remove('_id');
        item['id'] = idValue;
      }
      resultList.add(item);
    } else {
      // Handle if item is not a Map<String, dynamic>
      // You may choose to skip, log, or handle these cases differently
      // For this example, we skip them
      continue;
    }
  }

  return resultList;
}

Map<String, dynamic> findTaskById(List<Map<String, dynamic>> tasks, String id) {
  final task = tasks.firstWhere((task) => task['id'] == id, orElse: () => throw Exception('Task with id $id not found'));
  return task;
}
bool allCompleted(List<Map<String, dynamic>> maps) {
  return maps.every((map) => map['isCompleted'] ?? false);
}
bool noneCompleted(List<Map<String, dynamic>> maps) {
  return !maps.any((map) => map['isCompleted'] ?? false);
}

List<Map<String, dynamic>> deleteChecklist(List<Map<String, dynamic>> tasks, int taskId, int checklistId) {
  final updatedTasks = [...tasks.map((task) {
    if (task['id'] == taskId) {
      // Remove the checklist with the matching ID
      task['CheckLists'] = UnmodifiableListView(task['CheckLists'].where((checklist) => checklist['id'] != checklistId).toList());
    }
    return task;
  })];

  return updatedTasks;
}
List<Map<String, dynamic>> updateTask(List<Map<String, dynamic>> tasks, Map<String, dynamic> updatedTask) {
  int index = tasks.indexWhere((task) => task['id'] == updatedTask['id']);

  if (index == -1) {
    throw Exception('Task not found');
  }

  tasks[index] = updatedTask;

  return tasks;
}
String daysBetween(DateTime date1, DateTime date2) {

    final difference = date1.difference(date2).abs();
    return '${difference.inDays} days';

}
Future<void> DatePickerFun(BuildContext context,DateTime time,Function(DateTime) OnsubmitDate) async {
  final temp = await showDatePicker(
    context: context,

    firstDate: DateTime(DateTime.now().year, DateTime.now().month,),
    currentDate: time,
    lastDate: DateTime.now().add(Duration(days: 365)),

  );

  if (temp != null) {
    OnsubmitDate(temp);

  }
}
void SearchAction(BuildContext context, String value, FormzState state) {
  context.read<FormzBloc>().add(MembernameChanged( name: value));
  if (state.memberName.value.length > 1){
    context.read<MembersBloc>().add(GetMemberByNameEvent( name: state.memberName.value));}
  else if (state.memberName.value.isEmpty|| state.memberName.displayError!= null ){
    context.read<MembersBloc>().add(GetAllMembersEvent());
  }
}
Future<File> saveBase64AsFile(String base64String, String fileName) async {
  // Decode the base64 string
  List<int> bytes = base64.decode(base64String);

  // Get the temporary directory on the device
  Directory tempDir = await getTemporaryDirectory();

  // Create a new file in the temporary directory
  File tempFile = File('${tempDir.path}/$fileName');

  // Write the decoded bytes to the file
  await tempFile.writeAsBytes(bytes);

  // Return the created file
  return tempFile;
}

XFile? convert64ToXFile(String decodedString) {
  List<int> decodedBytes = base64Decode(decodedString);
  Uint8List data = Uint8List.fromList(decodedBytes);
  String? mimeType = lookupMimeType('temp.jpg', headerBytes: decodedBytes.take(256).toList());
  XFile xfile = XFile.fromData(data, mimeType: mimeType);
  log(xfile.path.toString());
  return xfile;
}
void saveFile(String decodedString, String filed) async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String filePath = documentsDirectory.path + '/'+filed;
  File file = File(filePath);

  file.writeAsString(decodedString);
}
Future<void> openFile(Map<String, dynamic> fileData, String fileName) async {
  try {
    // Save the base64 string as a file
    File tempFile = await saveBase64AsFile(fileData['url'], fileName);

    await OpenFile.open(tempFile.path);
    // Open file
  } catch (e) {
    log(e.toString());
  }
}
class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<bool> writeCounter(String base64,String name) async {
    try {
      final path = await _localPath;
      // Create a file for the path of
      // device and file name with extension
      final result= await convertBase64ToXFile(base64);
      File file= File('$path/$name');




      // Write the data in the file you have created
       file.writeAsString(base64Encode(await result!.readAsBytes()));
       log( file.toString());
      return true;
    } on Exception catch (e) {
      throw Exception('Failed to write file: $e');

      //
    }


  }
static pickFile(mounted,BuildContext context,String id)async{
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null) {
    // Get the file
    PlatformFile file = result.files.first;

    final taskFile=TaskFile(url: "url", id: "", path: file.path!, extension: file.extension!, );
    if (!mounted) return;
    context.read<GetTaskBloc>().add(UpdateFile(
        {"taskid":id, "file": taskFile}));
    log(result.toString());
    // Use the file as needed
  }

}

}