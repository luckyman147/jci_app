

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:ui' as ui;
import 'dart:typed_data';
import '../../../../core/app_theme.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/Activity.dart';
import '../../domain/entities/Event.dart';
import '../../domain/entities/Meeting.dart';
import '../../domain/entities/training.dart';
import '../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../bloc/Activity/activity_cubit.dart';
import '../bloc/IsVisible/bloc/visible_bloc.dart';
import '../bloc/textfield/textfield_bloc.dart';


Future<void> DatePicker(BuildContext context ,DateTime time,bool mounted)async {

  final temp = await showDatePicker(
    context: context,

    firstDate:DateTime.now(),
    currentDate: time,
    lastDate: DateTime.now().add(Duration(days: 365)),
    onDatePickerModeChange: (mode) {
      print("mode$mode");
    },
  );

  if (temp != null) {
    if (!mounted) return;

    context.read<FormzBloc>().add(jokerChanged(joke: temp));
  }
}
Widget Add({
  required GlobalKey<FormState> formKey,
required TextEditingController namecontroller,
required TextEditingController descriptionController,
required TextEditingController LeaderController,
required TextEditingController ProfesseurName,
required TextEditingController LocationController,
required TextEditingController Points,
  required TextEditingController Price,
  required MediaQueryData mediaQuery,
  required List<String> part ,
  required String action,
  required String id,



})=>BlocBuilder<FormzBloc, FormzState>(
  builder: (context, ste) {
    return BlocBuilder<TextFieldBloc ,TextFieldState>(
      builder: (context, statef) {
        return BlocBuilder<VisibleBloc, VisibleState>(
          builder: (context, vis) {
            return BlocConsumer<AddDeleteUpdateBloc, AddDeleteUpdateState>(
              listener: (ctx,ste){
                if (ste is ErrorAddDeleteUpdateState){
                  SnackBarMessage.showErrorSnackBar(
                      message: ste.message, context: context);

                }
                if (ste is MessageAddDeleteUpdateState){
                  SnackBarMessage.showSuccessSnackBar(
                      message: ste.message, context: context); context.go('/home');
                }
                if(ste is ActivityUpdatedState){
                  SnackBarMessage.showSuccessSnackBar(
                      message: ste.message, context: context); context.go('/home');
                }
                if (ste is DeletedActivityMessage){
                  SnackBarMessage.showSuccessSnackBar(
                      message: ste.message, context: context);}
                if (ste is LoadingAddDeleteUpdateState){
                  LoadingWidget();}


              },
              builder: (context, state) {
                return BlocBuilder<ActivityCubit, ActivityState>(
                  builder: (context, acti) {

                    return GestureDetector(
                      onTap: (){
                        final dur=DateTime.now().add(Duration(hours: 2));


                        if (acti.selectedActivity==activity.Events) {
                          if (formKey.currentState!.validate()&& ste.imageInput.value!=null&&ste.imageInput.value!.path.isNotEmpty) {
log(Price.text);
                            final act = Event(
                                registrationDeadline: ste.registrationTimeInput
                                    .value ?? dur,
                                LeaderName: LeaderController.text,
                                name: namecontroller.text,
                                description: descriptionController.text,
                                ActivityBeginDate: ste.beginTimeInput.value ??
                                    DateTime.now(),
                                ActivityEndDate: ste.endTimeInput.value ?? dur,
                                ActivityAdress: LocationController.text,
                                ActivityPoints: int.parse(Points.text),
                                categorie: ste.category.name,
                                IsPaid: vis.isPaid,
                                price: int.parse(Price.text),
                                Participants: part,
                                CoverImages: [
                                  ste.imageInput.value!.path.toString()
                                ],
                                id: action=="edit"?id:"", IsPart: false);
                            debugPrint("event: $action");
                            if (action == "edit") {
                              context.read<AddDeleteUpdateBloc>().add(
                                  UpdateActivityEvent(
                                      act: activity.Events, active: act));
                            }
                            else {
                              context.read<AddDeleteUpdateBloc>().add(
                                  AddACtivityEvent(
                                      act: act, type: activity.Events));
                            }

                          }
                        }
                        else if (acti.selectedActivity==activity.Trainings){
                          if (formKey.currentState!.validate()){
                            final act =Training(id: id, ProfesseurName: ProfesseurName.text, Duration: 0,
                                name: namecontroller.text,
                                description: descriptionController.text,
                                ActivityBeginDate: ste.beginTimeInput.value??DateTime.now(),
                                ActivityEndDate: ste.endTimeInput.value??dur,
                                ActivityAdress: LocationController.text,
                                ActivityPoints: int.parse(Points.text) , categorie:ste.category.name ,
                                IsPaid: vis.isPaid,
                                price:int.parse(Price.text), Participants: part,
                                CoverImages: [ste.imageInput.value!.path. toString()], IsPart: false);
                            if (action == "edit") {
                              context.read<AddDeleteUpdateBloc>().add(
                                  UpdateActivityEvent(
                                      act: activity.Trainings, active: act));
                            }
                            else {
                              context.read<AddDeleteUpdateBloc>().add(
                                  AddACtivityEvent(
                                      act: act, type: activity.Trainings));
                            }

                          }}
                        else {
                          if (formKey.currentState!.validate()) {
                            debugPrint("agenda: ${combineTextFields(statef.textFieldControllers)}");
                            final act = Meeting(
                                name: namecontroller.text,
                                description: descriptionController.text,
                                ActivityBeginDate: ste.beginTimeInput.value ??
                                    DateTime.now(),
                                ActivityEndDate: ste.endTimeInput.value ?? dur,
                                ActivityAdress: LocationController.text,
                                ActivityPoints: int.parse(Points.text),
                                categorie: ste.category.name,
                                IsPaid: false,
                                price: 0,
                                Participants: part,
                                CoverImages: [],
                                id: id,
                                Director: [ste.memberFormz.value!.id],
                                agenda: combineTextFields(statef.textFieldControllers), IsPart: false);
                            if (action == "edit") {
                              context.read<AddDeleteUpdateBloc>().add(
                                  UpdateActivityEvent(
                                      act: activity.Meetings, active: act));
                            }
                            else {
                              context.read<AddDeleteUpdateBloc>().add(
                                  AddACtivityEvent(
                                      act: act, type: activity.Meetings));
                            }

                          }

                        }



                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                              "Save",
                              style: PoppinsSemiBold(
                                  mediaQuery.devicePixelRatio * 6, PrimaryColor,TextDecoration.none),
                            )),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  },
);List<String> combineTextFields(List<TextEditingController> controllers) {
  List<String> combinedControllers = [];

  for (int i = 0; i < controllers.length; i += 2) {
    if (i + 1 < controllers.length) {
      String combinedController =
          '${controllers[i].text} (${controllers[i + 1].text} min ) ';
      combinedControllers.add(combinedController);
    }
  }

  return combinedControllers;
}
Category getCategoryFromString(String categoryString) {
  switch (categoryString.toLowerCase()) {
    case 'technology':
      return Category.Technology;
    case 'science':
      return Category.Science;
    case 'business':
      return Category.Business;
    case 'health':
      return Category.Health;
    case 'economy':
      return Category.Economy;
    case 'entertainment':
      return Category.Entertainment;
    case 'sports':
      return Category.Sports;
    case 'food':
      return Category.Food;
    case 'fashion':
      return Category.Fashion;
    case 'education':
      return Category.Education;
    case 'arts':
      return Category.Arts;
    case 'music':
      return Category.Music;
    case 'literature':
      return Category.Literature;
    case 'gaming':
      return Category.Gaming;
    case 'automotive':
      return Category.Automotive;
    case 'fitness':
      return Category.Fitness;
    case 'parenting':
      return Category.Parenting;
    case 'pets':
      return Category.Pets;
    case 'environment':
      return Category.Environment;
    case 'fun':
      return Category.fun;
    case 'Comity':
      return Category.Comity;
      case 'Other':
      return Category.Other;
    case'Official':
      return Category.Officiel;
    default:
    // You can return a default category or throw an exception based on your use case.
      throw ArgumentError('Invalid category string: $categoryString');
  }
}
List<TextEditingController> createControllers(List<String> combinedControllers) {
  List<TextEditingController> controllers = [];

  for (int i = 0; i < combinedControllers.length; i++) {
    String combinedController = combinedControllers[i];

    List<String> parts = combinedControllers[i].split(" (");
    List<String> result = parts.map((part) => part.trim()).toList();

    if (combinedController.isEmpty) {
      // Skip empty strings in the input list
      continue;
    }
      String text = result[0];
      String duration = result[1].split('min )').first;
log(text);
      TextEditingController textController = TextEditingController(text: text);
      TextEditingController durationController = TextEditingController(text: duration);

      controllers.add(textController);
      controllers.add(durationController);

  }

  return controllers; // Return the populated list outside the loop
}




  bool validateTime(DateTime beginTime, DateTime endTime) {
  return beginTime.isBefore(endTime);
}






Future<XFile?> convertBase64ToXFile(String base64String) async {
 if (base64String.isEmpty) {
    return null;
  }


  try {
    // Decode base64 string to bytes
    Uint8List bytes = base64.decode(base64String);

    // Create a MemoryImage from bytes
    MemoryImage memoryImage = MemoryImage(Uint8List.fromList(bytes));

    // Create an ImageStreamCompleter from MemoryImage
    ImageStream stream = memoryImage.resolve(ImageConfiguration.empty);
    Completer<ImageInfo> completer = Completer<ImageInfo>();

    // Listen for the first frame from the ImageStream
    stream.addListener(ImageStreamListener((ImageInfo image, bool synchronousCall) {
      completer.complete(image);
    }));

    // Wait for the first frame
    final ImageInfo imageInfo = await completer.future;

    // Convert the image to byte data
    final ByteData? byteData = await imageInfo.image.toByteData(format: ui.ImageByteFormat.png);

    // Check if byte data is not null
    if (byteData == null) {
      return null;
    }

    // Create a temporary file
    final tempDir = await getTemporaryDirectory();
    final tempFile = await File('${tempDir.path}/converted_image.png').create();

    // Save byte data to file
    await tempFile.writeAsBytes(byteData.buffer.asUint8List());

    // Return XFile with the file path
    return XFile(tempFile.path);
  } catch (e) {
    print('Error converting base64 to XFile: $e');
    return null;
  }}
DateTime combineTimeAndDate(TimeOfDay time, DateTime date) {
  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}
List<Map<String, dynamic>> mapObjects(List<Activity> objects) {
  return objects.map((object) => {'id': object.id, 'isPart': object.IsPart}).toList();
}
List<Activity> filterObjectsForCurrentWeekend(List<Activity> inputList) {
  DateTime now = DateTime.now();
  DateTime startOfWeekend = DateTime(now.year, now.month, now.day, 0, 0, 0);
  DateTime endOfWeekend = startOfWeekend.add(Duration(days: DateTime.sunday - now.weekday + 1));

  return inputList.where((obj) => obj.ActivityBeginDate.isAfter(startOfWeekend) && obj.ActivityBeginDate.isBefore(endOfWeekend)).toList();
}


List<Activity> filterActivityByCurrentMonth(List<Activity> objects) {
  final now = DateTime.now();
  final firstDayOfMonth = DateTime(now.year, now.month, 1);
  final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

  return objects.where((object) => object.ActivityBeginDate.isAfter(firstDayOfMonth) && object.ActivityBeginDate.isBefore(lastDayOfMonth)).toList();
}