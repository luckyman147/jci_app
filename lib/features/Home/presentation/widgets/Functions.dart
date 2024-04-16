

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import 'package:path_provider/path_provider.dart';

import 'dart:ui' as ui;
import 'dart:typed_data';

import '../../../../core/config/services/TeamStore.dart';

import '../../../Teams/domain/entities/Team.dart';
import '../../../Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import '../../../auth/domain/entities/Member.dart';

import '../../domain/entities/Activity.dart';
import '../bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';

import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../bloc/Activity/activity_cubit.dart';
import '../bloc/IsVisible/bloc/visible_bloc.dart';
import '../bloc/textfield/textfield_bloc.dart';


class ActivityAction {
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
    return objects.map((object) => {'id': object.id, 'isPart': object.IsPart})
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
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    return objects.where((object) =>
    object.ActivityBeginDate.isAfter(firstDayOfMonth) &&
        object.ActivityBeginDate.isBefore(lastDayOfMonth))
        .toList();
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


}