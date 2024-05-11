

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';
import 'package:jci_app/features/Home/domain/entities/ActivityGuest.dart';
import 'package:jci_app/features/Home/domain/entities/ActivityParticpants.dart';

import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:ui' as ui;
import 'dart:typed_data';

import '../../../../core/config/services/TeamStore.dart';

import '../../../Teams/domain/entities/Team.dart';
import '../../../Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import '../../../auth/domain/entities/Member.dart';

import '../../domain/entities/Activity.dart';
import '../../domain/entities/Guest.dart';
import '../../domain/usercases/ActivityUseCases.dart';
import '../bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';

import '../bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../bloc/Activity/activity_cubit.dart';
import '../bloc/IsVisible/bloc/visible_bloc.dart';
import '../bloc/textfield/textfield_bloc.dart';


class ActivityAction {
 static void ConfirmPreence(Guest guest, BuildContext context, String activityId,String status) {
final guestA=ActivityGuest(guest: guest, status: status);
      final param=guestParams(guest: guestA, guestId: guest.id, status:status, activityid: activityId);
      context.read<ParticpantsBloc>().add(ConfirmGuestEvent(params: param));

  }

 static void DeleteGestFunction(BuildContext context, Guest guest,String activityId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Delete Guest",
            style: PoppinsRegular(19, textColorBlack),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 20.0), // Adjust vertical padding
          content: SizedBox(
            height: 100, // Set the desired height
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensure the column takes minimum space
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Are you sure you want to delete ${guest.name}",
                    style: PoppinsRegular(17, textColorBlack),
                  ),
                ),
                if (guest.id.isEmpty)
                  Text(
                    "This guest has not been saved to the database",
                    style: PoppinsSemiBold(
                      17,
                      Colors.red,
                      TextDecoration.underline,
                    ),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("No", style: PoppinsRegular(15, textColor)),
            ),
            TextButton(
              onPressed: () {
                if (guest.id.isNotEmpty) {
                  final guestofActivity = ActivityGuest(
                    guest: guest,
                    status: "pending",
                  );
                  final param = guestParams(
                    guest: guestofActivity,
                    guestId: guest.id,
                    status: guestofActivity.status,
                    activityid: activityId,
                  );
                  context.read<ParticpantsBloc>().add(DeleteGuestEvent(
                    params: param,
                  ));
                  Navigator.pop(context);
                }
              },
              child: Text("Yes", style: PoppinsRegular(15, PrimaryColor)),
            )
          ],
        );
      },
    );
  }

  static void showGuestDetails(BuildContext context, Guest guest) {
    showDialog(

      context: context,
      builder: (context) {
        return AlertDialog(

          title: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email:',style: PoppinsLight(15, textColor),),
                Text(' ${guest.email}',style: PoppinsLight(17, textColorBlack),),
                Text('Phone Number: ',style: PoppinsLight(15, textColor),),
                Text('${guest.phone}',style: PoppinsLight(17, textColorBlack),),

              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.start,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close',style: PoppinsRegular(15, PrimaryColor),),
            ),
          ],
        );
      },
    );
  }
 static void AddGuest(GlobalKey<FormState> formKey, TextEditingController controller, TextEditingController controller2, TextEditingController controller3, BuildContext context,String activityId) {
    if (formKey.currentState!.validate()) {
      final guest=Guest(name: controller.text, email: controller2.text, phone: controller3.text,isConfirmed: true, id: '');
      final guestOfActivity=ActivityGuest(guest: guest, status: "pending");
      final guestP=guestParams(guest: guestOfActivity, guestId: guest.id, status: guestOfActivity.status, activityid: activityId);
      context.read<ParticpantsBloc>().add(AddGuestEvent(params: guestP));
      controller.clear();
      controller2.clear();
      controller3.clear();
      context.read<ActivityCubit>().selectIndex(0);

    }
  }
static   Future<void> DatePicker(BuildContext context, DateTime time,
      bool mounted) async {
    final temp = await showDatePicker(
      context: context,

      firstDate: DateTime.now(),
      currentDate: time,
      lastDate: DateTime.now().add(Duration(days: 365)),
      onDatePickerModeChange: (mode) {

      },
    );

    if (temp != null) {
      if (!mounted) return;

      context.read<FormzBloc>().add(jokerChanged(joke: temp));
    }
  }



static   List<String> combineTextFields(List<TextEditingController> controllers) {
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
static Future<void> launchURL(BuildContext context, String url) async {
  // Show an AlertDialog to confirm before launching the URL
  bool confirm = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Confirmation',style:PoppinsSemiBold(18, textColorBlack, TextDecoration.none)),
      content: Text('You are about to open a link in your browser. Do you want to continue?',style:PoppinsRegular(14, textColorBlack, )),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // Return false if canceled
          },
          child: Text('Cancel',style: PoppinsRegular(16, textColorBlack),),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // Return true if confirmed
          },
          child: Text('Open',style: PoppinsRegular(16, PrimaryColor),),
        ),
      ],
    ),
  );

  // If user confirms, launch the URL
  if (confirm == true) {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), webViewConfiguration: WebViewConfiguration());
    } else {
      throw 'Could not launch $url';
    }
  }
}
 static  Category getCategoryFromString(String categoryString) {
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
        return Category.Other;
    }
  }

 static  List<TextEditingController> createControllers(
      List<String> combinedControllers) {
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
      String duration = result[1]
          .split('min )')
          .first;
      log(text);
      TextEditingController textController = TextEditingController(text: text);
      TextEditingController durationController = TextEditingController(
          text: duration);

      controllers.add(textController);
      controllers.add(durationController);
    }

    return controllers; // Return the populated list outside the loop
  }



 static  Future<XFile?> convertBase64ToXFile(String base64String) async {
    if (base64String.isEmpty) {
      return null;
    }


    try {
      // Decode base64 string to bytes
      Uint8List bytes = base64.decode(base64String
          .split(' ')
          .last);

      // Create a MemoryImage from bytes
      MemoryImage memoryImage = MemoryImage(Uint8List.fromList(bytes));

      // Create an ImageStreamCompleter from MemoryImage
      ImageStream stream = memoryImage.resolve(ImageConfiguration.empty);
      Completer<ImageInfo> completer = Completer<ImageInfo>();

      // Listen for the first frame from the ImageStream
      stream.addListener(
          ImageStreamListener((ImageInfo image, bool synchronousCall) {
            completer.complete(image);
          }));

      // Wait for the first frame
      final ImageInfo imageInfo = await completer.future;

      // Convert the image to byte data
      final ByteData? byteData = await imageInfo.image.toByteData(
          format: ui.ImageByteFormat.png);

      // Check if byte data is not null
      if (byteData == null) {
        return null;
      }

      // Create a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = await File('${tempDir.path}/converted_image.png')
          .create();

      // Save byte data to file
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());

      // Return XFile with the file path
      return XFile(tempFile.path);
    } catch (e) {
      print('Error converting base64 to XFile: $e');
      return null;
    }
  }

 static  DateTime combineTimeAndDate(TimeOfDay time, DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  static List<Map<String, dynamic>> mapObjects(List<Activity> objects) {
    return objects.map((object) => {'id': object.id, 'participants': object.Participants})
        .toList();
  }

 static  List<Activity> filterObjectsForCurrentWeekend(List<Activity> inputList) {
    DateTime now = DateTime.now();
    DateTime startOfWeekend = DateTime(now.year, now.month, now.day, 0, 0, 0);
    DateTime endOfWeekend = startOfWeekend.add(
        Duration(days: DateTime.sunday - now.weekday + 1));

    return inputList.where((obj) =>
    obj.ActivityBeginDate.isAfter(startOfWeekend) &&
        obj.ActivityBeginDate.isBefore(endOfWeekend))
        .toList();
  }

static   String calculateDurationhour(DateTime beginDateTime, DateTime endDateTime) {
    final duration = endDateTime.difference(beginDateTime);
    final dateFormat = DateFormat('EEE HH:mm ');
    final timeFormat = DateFormat('HH:mm');
    if (duration.inDays > 0) {
      return ' ${dateFormat.format(beginDateTime)} - ${dateFormat.format(
          endDateTime)}';
    } else {
      return '${timeFormat.format(beginDateTime)} - ${timeFormat.format(
          endDateTime)}';
    }
  }

 static  String calculateDurationDays(DateTime beginDateTime, DateTime endDateTime) {
    final duration = endDateTime.difference(beginDateTime);

    if (duration.inDays > 0) {
      final dateFormat = DateFormat('EEEE');


      return '${dateFormat.format(beginDateTime)} - ${dateFormat.format(
          endDateTime)}';
    } else {
      return ' ${DateFormat('EEEE').format(beginDateTime)} ';
    }
  }


static   String DisplayDuration(DateTime beginDateTime, DateTime endDateTime,
      BuildContext context) {
    final duration = endDateTime.difference(beginDateTime);

    if (duration.inDays > 0) {
      return '${duration.inDays} ${"days".tr(context)}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} ${"hours".tr(context)}';
    } else {
      return '${duration.inMinutes} ${"minutes".tr(context)}';
    }
  }

 static  List<Activity> filterActivityByCurrentMonth(List<Activity> objects) {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month,now.day,);

   return objects.where((activity) => activity.ActivityBeginDate.isAfter(now) || activity.ActivityBeginDate.isAtSameMomentAs(now)).toList();
  }

 static  Future<List<Team>> fetchData(BuildContext context) async {
    final teams = await TeamStore.getCachedTeams(CacheStatus.Private);
    if (teams.isEmpty) {
      context.read<GetTeamsBloc>().add(GetTeams(isPrivate: true));
    }

    return teams;
  }

 static  Future<void> refreshFun(BuildContext context, ActivityState state) {
    context.read<AcivityFBloc>().add(
        GetActivitiesOfMonthEvent(act: state.selectedActivity));
    // context.read<ActivityOfweekBloc>().add(GetOfWeekActivitiesEvent(act: state.selectedActivity));

    return Future.value(true);
  }

  static Future<bool> checkifMemberExist(List<Map<String,dynamic>> all)async{
  final member=await MemberStore.getModel();
  return all.any((element) => element['memberid']==member!.id);
  }
 static List<ActivityGuest> searchGuestsByName(List<ActivityGuest> objects, String? name) {
   if (name == null || name.isEmpty) {
     return objects;
   } else {
     return objects.where((obj) => obj.guest.name.toLowerCase().contains(name.toLowerCase())
         || obj.guest.phone.toLowerCase().contains(name.toLowerCase()) ||
         obj.guest.email.toLowerCase().contains(name.toLowerCase())  ).toList();
   }
 } static List<Guest> searchAllGuestsByName(List<Guest> objects, String? name) {
   if (name == null || name.isEmpty) {
     return objects;
   } else {
     return objects.where((obj) => obj.name.toLowerCase().contains(name.toLowerCase())
         || obj.phone.toLowerCase().contains(name.toLowerCase()) ||
         obj.email.toLowerCase().contains(name.toLowerCase())  ).toList();
   }
 }
 static List<ActivityParticipants> searchMembersByName(List<ActivityParticipants> objects, String? name) {
   if (name == null || name.isEmpty) {
     return objects;
   } else {
     return objects.where((obj) => Member.toMember(obj.member[0].cast<String,dynamic>()).firstName.toLowerCase().contains(name.toLowerCase())
      ).toList();
   }
 }
 static String? CheckIfGuestExist(List<ActivityGuest> objects, Guest guest) {
    final guestExist = objects.indexWhere((obj) => obj.guest.id == guest.id);
    if (guestExist != -1) {
      return objects[guestExist].status;
    } else {
      return null;
    }
  }
}

