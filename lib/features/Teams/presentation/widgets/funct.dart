import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/features/Home/presentation/widgets/Functions.dart';
import 'package:jci_app/features/Teams/presentation/bloc/members/members_cubit.dart';
import 'package:mime/mime.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jci_app/features/Teams/domain/entities/Checklist.dart';
import 'package:jci_app/features/Teams/domain/entities/Task.dart';
import 'package:jci_app/features/Teams/domain/entities/TaskFile.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../core/config/services/TeamStore.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';

import '../../../MemberSection/domain/usecases/MemberUseCases.dart';
import '../../../MemberSection/presentation/bloc/Members/members_bloc.dart';
import '../../../MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import '../../../MemberSection/presentation/pages/memberProfilPage.dart';
import '../../../MemberSection/presentation/widgets/functionMember.dart';
import '../../domain/entities/Team.dart';
import '../../domain/usecases/TaskUseCase.dart';
import '../../domain/usecases/TeamUseCases.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../bloc/GetTeam/get_teams_bloc.dart';
import '../bloc/TaskFilter/taskfilter_bloc.dart';
import '../bloc/TaskIsVisible/task_visible_bloc.dart';
class TeamFunction{




  static bool IsPublic (Team team ){
    log(team.status.toString());
    return team.status;
  }

  static void NavigateTOMemberSection(BuildContext context, Member member) {
    context.read<MembersBloc>().add(
        GetMemberByIdEvent(
            MemberInfoParams(id: member.id, status: true)));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemberSectionPage(id: member.id,),
      ),
    );
  }
  static void InviteKickMember(bool isAssign, Team team, Member member, BuildContext context) {
    if (!isAssign) {
      final teamfi = TeamInput(
          team.id,
          member.id,
          null,
          TeamFunction.toMapMember(member)

      );
      context.read<GetTeamsBloc>().add(InviteMembers(teamfi: teamfi));
      Navigator.pop(context);
    }
    else{
      final teamfi = TeamInput(
          team.id,
          member.id,
          "kick",
          TeamFunction.toMapMember(member)

      );
      context.read<GetTeamsBloc>().add(UpdateTeamMember(fields: teamfi));
      Navigator.pop(context);
    }
  }
  static void ChangeMemerFunction(bool isExisted, BuildContext context, Member item,Function(Member) onRemoveTap, Function(Member  ) onAddTap) {
    if (isExisted) {
      context.read<MembersTeamCubit>().RemoveMember( item);

      onRemoveTap(item);
    }
    else {
      context.read<MembersTeamCubit>().AddMember(item);
      onAddTap(item);
    }
  }


  static bool doesObjectExistInList(List<Member> list, Member targetObject) {
    return list.any((element) => element.id == targetObject.id)||list.contains(targetObject);
  }
  static List<String> getIds(List<Member> objects) {
    if (objects.isEmpty || objects == null  ) {
      return [];
    }
    return objects.map((obj) => obj.id ).toList();
  }
  static  void changeInitTeams(BuildContext context,Privacy privacy,bool isPrivate) {

    context.read<TaskVisibleBloc>().add(changePrivacyEvent(privacy));

    // Dispatch event to initialize GetTeamsBloc and fetch teams with updated privacy
    context.read<GetTeamsBloc>().add(initStatus());
    context.read<GetTeamsBloc>().add(GetTeams(isPrivate: isPrivate));
  }
  static  void searchFunction(String value, BuildContext context,bool isPrivate) {
    if (value.isEmpty){
      context.read<GetTeamsBloc>().add(GetTeams(isPrivate: isPrivate));
    }

    else{
      context.read<GetTeamsBloc>().add(GetTeamByName(
          {"name": value}));}
  }
  static  List<int> generateNumbers(int num) {
    return List.generate(num, (index) => num - index + 1).reversed.toList();
  }
  static List<Map<String, dynamic>> mapObjects(List<Tasks> objects) {
    return objects.map((object) => {'id': object.id, 'isCompleted': object.isCompleted}).toList();
  }
  static List<Map<String, dynamic>> mapChecklist(List<CheckList> objects) {
    return objects.map((object) => {'id': object.id, 'isCompleted': object.isCompleted,"name":object.name,"IsUpdated":false}).toList();
  }

  static Map<String, dynamic> mapTeam(Team objects) {
    return {'id': objects.id, 'name': objects.name,
      "CoverImage":objects.CoverImage,
      "TeamLeader":objects.TeamLeader,
      'event':objects.event,

      'description': objects.description, 'status': objects.status, 'Members': objects.Members,};
  }
  static List<Map<String, dynamic>> filterCompletedTasks(List<Map<String, dynamic>> tasks) {
    List<Map<String, dynamic>> completedTasks = [];

    for (var task in tasks) {
      if (task['isCompleted'] == true) {
        completedTasks.add(task);
      }
    }

    return completedTasks;
  }

  static  List<Map<String, dynamic>> filterPendingTasks(List<Map<String, dynamic>> tasks) {
    return tasks.where((task) => task['isCompleted']==false).toList();
  }
  static int getIndexById(String id, List<Map<String, dynamic>> list) {
    for (int i = 0; i < list.length; i++) {
      if (list[i]['id'] == id) {
        return i;
      }
    }
    // If the id is not found in any map, return -1
    return -1;
  }

  static  Map<String, dynamic> toMap(Tasks object) {
    return {'id': object.id, 'isCompleted': object.isCompleted, 'name': object.name,"willDeleted":false, "WillUpdated":false,
      'description': object.description, 'StartDate': object.StartDate, 'Deadline': object.Deadline, 'AssignTo': object.AssignTo,
      'attachedFile': object.attachedFile.map((e) => toMapFile(e)).toList(), 'CheckLists': object.CheckLists.map((e) => toMapChecklist(e)),};
  }
  static List<String> getidsObTask(List<Tasks> objects) {
    if (objects.isEmpty || objects == null  ) {
      return [];
    }
    return objects.map((obj) => obj.id ).toList();
  }
  static Map<String, dynamic> toMapFile(TaskFile object) {
    return {'id': object.id, 'path': object.path, 'url': object.url, 'extension':object.extension};
  }
  static  Map<String, dynamic> toMapChecklist(CheckList object) {
    return {'id': object.id, 'isCompleted': object.isCompleted, 'name': object.name,};
  }
  static Map<String, dynamic> toMapMember(Member object) {
    return {'id': object.id, 'firstName': object.firstName, 'Images': object.Images,};
  }
  static List<Map<String, dynamic>> convertIdKey(List<dynamic> inputList) {
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

  static Map<String, dynamic> findTaskById(List<Map<String, dynamic>> tasks, String id) {
    final task = tasks.firstWhere((task) => task['id'] == id, orElse: () => throw Exception('Task with id $id not found'));
    return task;
  }
  static bool allCompleted(List<Map<String, dynamic>> maps) {
    return maps.every((map) => map['isCompleted'] ?? false);
  }
  static bool noneCompleted(List<Map<String, dynamic>> maps) {
    return !maps.any((map) => map['isCompleted'] ?? false);
  }

  static  List<Map<String, dynamic>> deleteChecklist(List<Map<String, dynamic>> tasks, int taskId, int checklistId) {
    final updatedTasks = [...tasks.map((task) {
      if (task['id'] == taskId) {
        // Remove the checklist with the matching ID
        task['CheckLists'] = UnmodifiableListView(task['CheckLists'].where((checklist) => checklist['id'] != checklistId).toList());
      }
      return task;
    })];

    return updatedTasks;
  }
  static List<Map<String, dynamic>> updateTask(List<Map<String, dynamic>> tasks, Map<String, dynamic> updatedTask) {
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
  static Future<void> DatePickerFun(BuildContext context,DateTime time,Function(DateTime) OnsubmitDate) async {
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
  static void ReturnFunbction(BuildContext context, TaskVisibleState ste) {
    GoRouter.of(context).go('/home');
    context.read<GetTaskBloc>().add(resetevent());

    context.read<TaskVisibleBloc>().add(changePrivacyEvent(Privacy.Primary));
    context.read<GetTeamsBloc>().add(GetTeams(isPrivate: false,isUpdated: ste.isUpdated));
    context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(ste.isUpdated));

    context.read<TaskfilterBloc>().add(filterTask([]));
  }


  static  void SearchAction(BuildContext context, String value, MembersTeamState state) {
    context.read<MembersTeamCubit>().nameChanged(value);
    if (state.name.length > 1){
      context.read<MembersBloc>().add(GetMemberByNameEvent( name: state.name));}
    else if (state.name.isEmpty ){
      context.read<MembersBloc>().add(const GetAllMembersEvent(false));
    }
  }
  static Future<void> ToMembersSection(Team team, BuildContext context, Member member, ChangeSboolsState state,bool mounted) async {

    if (await FunctionMember.isChefAndSuperAdmin(team) && !await FunctionMember.isOwner(member.id)) {
      if (!mounted) return;
      context.read<MembersBloc>().add(
          GetMemberByIdEvent(MemberInfoParams(id: member.id,
              status: true)));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return MemberSectionPage(id: member.id);
          },
        ),
      );
    }
  }








  static  void init(String id,BuildContext context)async{
    final store=await TeamStore.getUpdated();
    context.read<GetTaskBloc>().add(GetTasks(id: id, filter: TaskFilter.All));
    context.read<TaskVisibleBloc>().add(ToggleTaskVisible(true));
    context.read<GetTeamsBloc>().add(GetTeamById({"id": id,"isUpdated": store}));

  }
  static void ListenerDelete(GetTeamsState state, BuildContext context,String id) {
    if (state.status == TeamStatus.Deleted) {
      SnackBarMessage.showSuccessSnackBar(
          message: "Deleted Succefully", context: context);
      GoRouter.of(context).go('/home');
      context.read<GetTaskBloc>().add(resetevent());

    }
    else if (state.status == TeamStatus.DeletedError) {
      SnackBarMessage.showErrorSnackBar(
          message: "Error Deleting", context: context);
      context.read<GetTeamsBloc>().add(GetTeamById({"id":id,"isUpdated": false}));

    }
  }
  static Future<File> saveBase64AsFile(String base64String, String fileName) async {
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
  static  Future<void> openFile(Map<String, dynamic> fileData, String fileName) async {
    try {
      // Save the base64 string as a file
      File tempFile = await saveBase64AsFile(fileData['url'], fileName);

      await OpenFile.open(tempFile.path);
      // Open file
    } catch (e) {
      log(e.toString());
    }
  }}
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
      final result= await ActivityAction.convertBase64ToXFile(base64);
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
      final inputFields input=inputFields(taskid: id, teamid:"", file: taskFile, memberid: null, status: null, Deadline: null, StartDate: null, name: null, task: null, isCompleted: null, member: null, fileid: null, );
      context.read<GetTaskBloc>().add(UpdateFile(input));

    }

  }

}