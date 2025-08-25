import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jci_app/features/Home/presentation/bloc/category/category_bloc.dart';
import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../../core/config/services/EventStore.dart';
import '../../../../../core/config/services/MeetingStore.dart';
import '../../../../../core/config/services/MemberStore.dart';
import '../../../../../core/config/services/TrainingStore.dart';
import '../../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../data/model/events/EventModel.dart';
import '../../../domain/Dtos/ActivityParam.dart';
import '../../../domain/entities/Activitys/Activity.dart';
import '../../../domain/entities/Activity/event/Event.dart';
import '../../../domain/entities/Meeting.dart';
import '../../../domain/entities/training.dart';
import '../../../domain/enums/ActionImage.dart';
import '../../bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../bloc/Activity/activity_cubit.dart';
import '../../bloc/IsVisible/bloc/visible_bloc.dart';
import '../../bloc/textfield/textfield_bloc.dart';
import 'Functions.dart';
import 'package:logger/logger.dart';
class AddUpdateFunctions {
  /// Handles the pop functionality based on the work type (edit or add).
  static void popFunctions(String work, BuildContext context, String id) {
    if (work == "edit") {
      // If editing, fetch the activity by ID and pop the screen
      activityParams params = activityParams(
        type: context.read<ActivityCubit>().state.selectedActivity,
        act: null,
        Eventid: id,
        name: '',
      );

    } else {
      // If adding, reset the activity type to Events and fetch all events
      context.read<ActivityCubit>().selectActivity(activity.Events);
      context.read<AddDeleteUpdateBloc>().add(const CheckPermissions(act: activity.Events));
      context.read<AcivityFBloc>().add(const GetAllActivitiesEvent(act: activity.Events));
    }
    Navigator.of(context).pop(); // Close the screen
  }

  /// Resets all form fields and state to their initial values.
  static void resetForm(BuildContext context, TextEditingController price, List<String> participantsDetails) {
    price.text = "0"; // Reset price to default
    
    context.read<FormzBloc>().add(BeginTimeChanged(date: DateTime.now())); // Reset begin time
    context.read<CategoryBloc>().add(InitCategoryEvent()); // Reset category
    context.read<TaskVisibleBloc>().add(const ChangeImageEvent("", ActionImage.PREVIOUS)); // Reset image
    context.read<FormzBloc>().add(RegistraTimeChanged(date: DateTime.now().add(const Duration(days: 1)))); // Reset registration time
    context.read<FormzBloc>().add(EndTimeChanged(date: DateTime.now().add(const Duration(days: 1)))); // Reset end time
    context.read<FormzBloc>().add(MemberFormzChanged(memberFormz: User.UserTest())); // Reset member
    context.read<FormzBloc>().add(const InitParticipants(members: [])); // Reset participants
    context.read<TextFieldBloc>().add(ChangeTextFieldEvent([TextEditingController(), TextEditingController()])); // Reset text fields
    context.read<FormzBloc>().add(ImageInputChanged(imageInput: XFile(""))); // Reset image input
    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(false)); // Reset paid toggle
  }

  /// Validates if the begin time is before the end time.
  static bool validateTime(DateTime beginTime, DateTime endTime) {
    return beginTime.isBefore(endTime);
  }

  /// Checks the work type and loads the appropriate activity model for editing.
  static void checkActivity(String work, String act, BuildContext context, String id, TextEditingController price,
      List<String> part, TextEditingController locationController, TextEditingController points,
      TextEditingController nameController, TextEditingController descriptionController,
      TextEditingController professeur, bool mounted)async {
    if (work == "edit") {
      // If editing, load the activity model based on the type
      Logger( ).i("AddUpdateFunctions.checkActivity: Loading activity model for editing ${act}",);
      switch (act) {
        case "Trainings":
         await loadTrainingModel(id, price, professeur, context, nameController, descriptionController, locationController, points, mounted);
          break;
        case "Meetings":
          await loadMeetingModel(id, context, mounted, locationController, points, nameController, descriptionController);
          break;
        case "Events":
          await loadEventModel(id, context, price, nameController, descriptionController, locationController, points, part, mounted);
          break;
        default:
          await          loadEventModel(id, context, price, nameController, descriptionController, locationController, points, part, mounted);
      }
    } else {
      // If adding, reset the form
      resetForm(context, price, part);
    }
  }

  /// Loads and updates the form with event data.
  static Future<void> loadEventModel(String id, BuildContext context, TextEditingController price,
      TextEditingController nameController, TextEditingController descriptionController,
      TextEditingController locationController, TextEditingController points, List<String> part, bool mounted) async {
    final eventStore = await EventStore.create();
    EventModel? event = await eventStore.getEventById(id);
    if (!mounted) return;
    if (event == null) {
      // Handle the case where the event is not found
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event not found')),
      );
      return;
    }
  await  updateEventInfo(event.toEvent(), price, context, nameController, descriptionController, locationController, points, mounted);
  }

  /// Loads and updates the form with training data.
  static Future<void> loadTrainingModel(String id, TextEditingController price, TextEditingController professeurController,
      BuildContext context, TextEditingController nameController, TextEditingController descriptionController,
      TextEditingController locationController, TextEditingController points, bool mounted) async {
    List<Training> trainingList = await TrainingStore.getCachedTrainings();
    Training train = trainingList.firstWhere((train) => train.activityBasics.id == id);
    if (!mounted) return;
 await   updateTrainingInfo(train, price, professeurController, context, nameController, descriptionController, locationController, points);
  }

  /// Loads and updates the form with meeting data.
  static Future<void> loadMeetingModel(String id, BuildContext context, bool mounted, TextEditingController locationController,
      TextEditingController points, TextEditingController nameController, TextEditingController descriptionController) async {
    List<Meeting> meetingList = await MeetingStore.getCachedMeetings();
    Meeting meeting = meetingList.firstWhere((meet) => meet.activityBasics.id == id);
    if (!mounted) return;
  await  updateMeetingInfo(meeting, context, mounted, locationController, points, nameController, descriptionController);
  }

  /// Updates the form with basic activity information and waits for the CategoryBloc to complete.
  static Future<void> updateActivityBasics(Activity act, BuildContext context, TextEditingController locationController,
      TextEditingController points, TextEditingController nameController, TextEditingController descriptionController) async {
    // Update the text controllers with activity data
    locationController.text = act.activityBasics.activityAdress;
    points.text = act.settings.activityPoints.toString();
    nameController.text = act.activityBasics.name;
    descriptionController.text = act.activityBasics.description;

    // Update the begin time in the FormzBloc
    context.read<FormzBloc>().add(BeginTimeChanged(date: act.activityBasics.activityBeginDate));
    fetchAndSelectCategories(context,act.settings.categoryIds,ActionImage.ADD);
    // Get the CategoryBloc instance



  }
static  Future<void> fetchAndSelectCategories(
      BuildContext context,
      List<String> categoryIds,
      ActionImage actionType,
      ) async {
    final bloc = context.read<CategoryBloc>();

    // Trigger fetch first
    bloc.add(FetchCategoriesById(categories: categoryIds));

    // Wait for the bloc to emit CategoryLoaded
    final completer = Completer<void>();

    final sub = bloc.stream.listen((state) {
      if (state.categories.isNotEmpty && state.error.isEmpty && !state.isLoading) {
        for (final category in state.categories) {
          bloc.add(SelectCategoryEvent(actionType, category: category));
        }
        if (!completer.isCompleted) {
          completer.complete();
        }
      } else if (state.error.isNotEmpty) {
        if (!completer.isCompleted) {
          completer.completeError(Exception('Failed to load categories'));
        }
      }
    });

    // Ensure stream subscription is cancelled once done
    return completer.future.whenComplete(() => sub.cancel());
  }


  /// Updates the form with event-specific information.
  static Future<void> updateEventInfo(Event event, TextEditingController price, BuildContext context,
      TextEditingController nameController, TextEditingController descriptionController,
      TextEditingController locationController, TextEditingController points, bool mounted) async {

    price.text = event.settings.price.toString();
    if (!mounted) return;
    context.read<FormzBloc>().add(MemberFormzChanged(memberFormz: event.leaderName));
    context.read<FormzBloc>().add(EndTimeChanged(date: event.activityBasics.activityEndDate));
    context.read<FormzBloc>().add(RegistraTimeChanged(date: event.registrationDeadline));
    for (String image in event.activityBasics.coverImages) {
      context.read<TaskVisibleBloc>().add(ChangeImageEvent(image, ActionImage.ADD));
    }
    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(event.settings.isPaid));
  await  updateActivityBasics(event, context, locationController, points, nameController, descriptionController);
  }

  /// Updates the form with training-specific information.
  static Future<void> updateTrainingInfo(Training train, TextEditingController price, TextEditingController professeurController,
      BuildContext context, TextEditingController nameController, TextEditingController descriptionController,
      TextEditingController locationController, TextEditingController points)async {
    price.text = train.settings.price.toString();
    professeurController.text = train.professeurName;
    context.read<FormzBloc>().add(EndTimeChanged(date: train.activityBasics.activityEndDate));
    context.read<TaskVisibleBloc>().add(InitImagesEvent(train.activityBasics.coverImages));
    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(train.settings.isPaid));
await    updateActivityBasics(train, context, locationController, points, nameController, descriptionController);
  }

  /// Updates the form with meeting-specific information.
  static Future<void> updateMeetingInfo(Meeting meeting, BuildContext context, bool mounted,
      TextEditingController locationController, TextEditingController points,
      TextEditingController nameController, TextEditingController descriptionController) async {
    if (!mounted) return;
    context.read<TextFieldBloc>().add(ChangeTextFieldEvent(ActivityAction.createControllers(meeting.agenda)));

    context.read<FormzBloc>().add(MemberFormzChanged(memberFormz: meeting.director));
   await updateActivityBasics(meeting, context, locationController, points, nameController, descriptionController);
  }

  /// Converts a list of dynamic objects to a list of IDs.
  static List<String> toIds(List<dynamic> part) {
    return part.map((e) => e['_id'] as String).toList();
  }
}