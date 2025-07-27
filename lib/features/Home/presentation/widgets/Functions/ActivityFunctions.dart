import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/ActivityBasics.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/ActivitySettings.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/OnlineSettings.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/ParicipationStatus.dart';
import 'package:jci_app/features/Home/domain/entities/ParticipantDetailsParam.dart';
import 'package:jci_app/features/Home/domain/entities/Activitys/Activity.dart';
import 'package:jci_app/features/Home/domain/enums/Privacy.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/category/category_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Activity_Global.dart';
import '../../../data/model/events/EventModel.dart';
import '../../../data/model/meetingModel/MeetingModel.dart';
import '../../../domain/Dtos/ActivityParam.dart';
import '../../../domain/entities/Activity/event/Event.dart';
import '../../../domain/entities/Meeting.dart';
import '../../../domain/entities/training.dart';
import '../../pages/CreateUpdateActivityPage.dart';
import '../Activity/ActivityDetailsComponents.dart';

class ActivityFunctions{

  /// This function is used to save the activity
  /// It takes the following parameters
  /// [acti] : The activity state
  /// [formKey] : The form key
  /// [state] : The task visible state
  /// [Price] : The price controller
  /// [ste] : The formz state
  /// [LeaderController] : The leader controller
  /// [namecontroller] : The name controller
  /// [descriptionController] : The description controller
  /// [LocationController] : The location controller
  /// [Points] : The points controller
  /// [vis] : The visible state
  /// [part] : The list of participants
  /// [action] : The action to be performed
  /// [id] : The id of the activity
  static void SaveActivityFunction(ActivityState acti,
      GlobalKey<FormState> formKey, TaskVisibleState state,
      TextEditingController Price, FormzState ste,
     TextEditingController namecontroller,
      TextEditingController descriptionController, TextEditingController LocationController,
      TextEditingController Points, VisibleState vis, List<String> part,
      String action, String Activityid, BuildContext context,
      TextEditingController ProfesseurName, TextFieldState statef,CategoryState cat) {
    final dur = DateTime.now().add(
        const Duration(hours: 2));

    Activity? act;
    switch (acti.selectedActivity) {
      case activity.Events:
        if (IsValidated(formKey, state,cat,context,acti.selectedActivity)) {
          act = EventAction(
            Price,
            ste,
            dur,

            namecontroller,
            descriptionController,
            LocationController,
            Points,
            vis,
            part,
            action,
            Activityid,
            context,
            state,
          );
        }
        break;
      case activity.Trainings:
        if (IsValidated(formKey, state,cat,context,acti.selectedActivity)) {
          act = TrainingAction(
            formKey,
            ste,
            Activityid,
            ProfesseurName,
            namecontroller,
            descriptionController,
            dur,
            LocationController,
            Points,
            vis,
            Price,
            part,
            action,
            context,
            state,
          );
        }
        break;
      default:
        if (formKey.currentState!.validate()) {
          act = MeetingAction(
            formKey,
            namecontroller,
            descriptionController,
            ste,
            dur,
            LocationController,
            Points,
            part,
            Activityid,
            statef,
            action,
            context,
            vis
          );
        }
    }

    if(act!=null){
      ContextActionaAddOrEdit(acti, act, Activityid, action, context);

    }
  }
  /// This function is used to add or edit the activity
  /// It takes the following parameters
  /// [acti] : The activity state
  /// [act] : The activity
  /// [id] : The id of the activity
  /// [action] : The action to be performed
  /// [context] : The build context
  /// It returns void
  /// It is called in the [SaveActivityFunction] function
  /// It is called in the [DeleteAction] function
  ///

  static void ContextActionaAddOrEdit(ActivityState acti, Activity act, String id, String action, BuildContext context) {
    final param =activityParams(type: acti.selectedActivity, act: act,Eventid: id, name: '');
    if (action == "edit") {
      context.read<AddDeleteUpdateBloc>().add(
          UpdateActivityEvent(
              params: param));
    }
    else {
      context.read<AddDeleteUpdateBloc>().add(
          AddACtivityEvent(
              params: param));
    }
  }
  /// to valide the current state of the form
  static bool IsValidated(
      GlobalKey<FormState> formKey,
      TaskVisibleState state,
      CategoryState cat,
      BuildContext context,
      activity act) {

    bool isValid = true; // Initialize a validity flag

    // Check if selected categories are empty
    if (cat.SelectedCategories.isEmpty) {
      context.read<CategoryBloc>().add(throwError(message: "Required"));
      isValid = false; // Set validity to false
    }

    // Check if email is empty based on activity type
    if (act != activity.Trainings && context.read<FormzBloc>().state.memberFormz.value!.email.isEmpty) {
      context.read<FormzBloc>().add(const ThrowError(error: "Required"));
      isValid = false; // Set validity to false
    }

    // Check if images are empty based on activity type
    if (act != activity.Meetings && state.images.isEmpty) {
      context.read<TaskVisibleBloc>().add(const ChangeStatusEvent(Status.Empty));
      isValid = false; // Set validity to false
    }

    // Validate the form and combine with other conditions
    if ( formKey.currentState!.validate()) {
      // Return true if all conditions are valid
    return isValid || state.images.isNotEmpty || cat.SelectedCategories.isNotEmpty;
    }
    return false; // Return false if any condition is invalid

  }


  static Activity MeetingAction(GlobalKey<FormState> formKey, TextEditingController namecontroller, TextEditingController descriptionController, FormzState ste, DateTime dur, TextEditingController LocationController, TextEditingController Points, List<String> part, String id, TextFieldState statef, String action, BuildContext context,
      VisibleState vis
      ) {

    return

      Meeting(
          director: ste.memberFormz.value!,
          agenda: ActivityAction. combineTextFields(
              statef.textFieldControllers),

          activityBasics:fillActivityBasics(id, namecontroller, descriptionController, ste, dur, LocationController),
          settings: fillActivitySettings(Points, context, vis)  ,
          online: fillOnlineSettings(vis),
          participation: fillpartipationsSettings(ste));







  }

  static ParticipationStatus fillpartipationsSettings(FormzState ste) {
    return ParticipationStatus(
            participants:   ste.PrivateParticipants.map((e) => e.id??'').toList(), isPart: false);
  }

  static OnlineSettings fillOnlineSettings(VisibleState vis) => OnlineSettings(isOnline:  vis.IsOnline, googleMeetLink: '');

  static ActivitySettings fillActivitySettings(TextEditingController Points, BuildContext context, VisibleState vis) {
    return ActivitySettings(activityPoints:
        int.parse(Points.text),
            categoryIds:  context.read<CategoryBloc>().state.SelectedCategories.map((e) => e.CategoryName).toList(),
            isPaid: false,
            price:  0, isPublic: !vis.isPrivate);
  }

  static ActivityBasics fillActivityBasics(String id, TextEditingController namecontroller, TextEditingController descriptionController, FormzState ste, DateTime dur, TextEditingController LocationController) {
    return ActivityBasics(id: id,
            name: namecontroller.text,
            description: descriptionController.text,
            activityBeginDate:  ste.beginTimeInput
                .value ??
                DateTime.now(),
            activityEndDate: ste.endTimeInput.value ??
                dur,
            activityAdress: LocationController.text,
            coverImages: const []);
  }

  static Activity TrainingAction(GlobalKey<FormState> formKey, FormzState ste, String id, TextEditingController ProfesseurName, TextEditingController namecontroller, TextEditingController descriptionController, DateTime dur, TextEditingController LocationController, TextEditingController Points, VisibleState vis, TextEditingController Price,
      List<String> part, String action, BuildContext context,TaskVisibleState taskS) {

    return
      Training(
          professeurName: ProfesseurName.text,
          duration: 0,
          activityBasics:fillActivityBasics(id, namecontroller, descriptionController, ste, dur, LocationController) ,
          settings: fillActivitySettings(Points, context, vis),
          online: fillOnlineSettings(vis), participation: fillpartipationsSettings(ste));




  }

  static Activity EventAction(TextEditingController Price, FormzState ste, DateTime dur, TextEditingController namecontroller, TextEditingController descriptionController, TextEditingController LocationController, TextEditingController Points, VisibleState vis, List<String> part, String action, String id,
      BuildContext context,TaskVisibleState taskS) {

    return
      Event(
          leaderName:  ste.memberFormz.value!,
          registrationDeadline: ste
              .registrationTimeInput
              .value ?? dur,
          activityBasics: fillActivityBasics(id, namecontroller, descriptionController, ste, dur, LocationController),
          settings: fillActivitySettings(Points, context, vis),
          online: fillOnlineSettings(vis),
          participation: fillpartipationsSettings(ste));


  }
  static void DeleteAction(BuildContext context, Activity activitys,ActivityState state) {
    final result=activityParams(type: state.selectedActivity, act: activitys,Eventid: activitys.activityBasics.id, name: '');

    context.read<AddDeleteUpdateBloc>().add(DeleteActivityEvent(params: result
    ));
  }

  static void UpdateAction(BuildContext context, Activity activitys) {


    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return  CreateUpdateActivityPage(id: activitys.activityBasics.id, activity: activitys.runtimeType == EventModel ?
          activity.Events.name :
          activitys.runtimeType == MeetingModel ?
          activity.Meetings.name :
          activity.Trainings.name, work: actionType.edit.name, particpants:activitys.participation.participants,);
        },
      ),
    );



  }

  static void launchURL(String googleMeetLink)async {
    if (await canLaunchUrl(Uri(
    scheme: 'https',
    host: googleMeetLink,

    ))) {
    await launchUrl(
      Uri(
        scheme: 'https',
        host: googleMeetLink,
      )
    );
    } else {
    throw 'Could not launch $googleMeetLink';
    }
  }


}