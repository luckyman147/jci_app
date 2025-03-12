import 'dart:developer';

import 'package:jci_app/features/Home/domain/entities/ParticipantDetailsParam.dart';
import 'package:jci_app/features/Home/domain/entities/Activity.dart';
import 'package:jci_app/features/Home/domain/enums/Privacy.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/category/category_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../Activity_Global.dart';
import '../../../data/model/events/EventModel.dart';
import '../../../data/model/meetingModel/MeetingModel.dart';
import '../../../domain/Dtos/ActivityParam.dart';
import '../../../domain/entities/Event.dart';
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

    return  Meeting(
        name: namecontroller.text,
        description: descriptionController.text,
        ActivityBeginDate: ste.beginTimeInput
            .value ??
            DateTime.now(),
        ActivityEndDate: ste.endTimeInput.value ??
            dur,
        ActivityAdress: LocationController.text,
        ActivityPoints: int.parse(Points.text),
        categorieId: context.read<CategoryBloc>().state.SelectedCategories.map((e) => e.CategoryName).toList(),
        IsPaid: false,
        price: 0,
        Participants:         ste.PrivateParticipants.map((e) => e.id??'').toList(),

        CoverImages: const [],
        id: id,
        Director: ste.memberFormz.value!,
        agenda:ActivityAction. combineTextFields(
            statef.textFieldControllers),
        IsPart: false, isOnline: vis.IsOnline, googleMeetLink: '', IsPublic: !vis.isPrivate);

  }

  static Activity TrainingAction(GlobalKey<FormState> formKey, FormzState ste, String id, TextEditingController ProfesseurName, TextEditingController namecontroller, TextEditingController descriptionController, DateTime dur, TextEditingController LocationController, TextEditingController Points, VisibleState vis, TextEditingController Price,
      List<String> part, String action, BuildContext context,TaskVisibleState taskS) {

    return Training(id: id,
        ProfesseurName: ProfesseurName.text,
        Duration: 0,
        name: namecontroller.text,
        description: descriptionController.text,
        ActivityBeginDate: ste.beginTimeInput
            .value ?? DateTime.now(),
        ActivityEndDate: ste.endTimeInput.value ??
            dur,
        ActivityAdress: LocationController.text,
        ActivityPoints: int.parse(Points.text),
        categorieId: context.read<CategoryBloc>().state.SelectedCategories.map((e) => e.CategoryName).toList(),

        IsPaid: vis.isPaid,
        price: int.parse(Price.text),
        Participants:         ste.PrivateParticipants.map((e) => e.id??'').toList(),

        CoverImages:
          taskS.images
        ,
        IsPart: false, IsPublic: !vis.isPrivate, isOnline: vis.IsOnline, googleMeetLink: "");


  }

  static Activity EventAction(TextEditingController Price, FormzState ste, DateTime dur, TextEditingController namecontroller, TextEditingController descriptionController, TextEditingController LocationController, TextEditingController Points, VisibleState vis, List<String> part, String action, String id,
      BuildContext context,TaskVisibleState taskS) {

    return Event(
        registrationDeadline: ste
            .registrationTimeInput
            .value ?? dur,
        LeaderName: ste.memberFormz.value!,
        name: namecontroller.text,
        description: descriptionController.text,
        ActivityBeginDate: ste.beginTimeInput
            .value ??
            DateTime.now(),
        ActivityEndDate: ste.endTimeInput.value ??
            dur,
        ActivityAdress: !vis.IsOnline?LocationController.text:"",
        ActivityPoints: int.parse(Points.text),
        categorieId: context.read<CategoryBloc>().state.SelectedCategories.map((e) => e.CategoryName).toList(),

        IsPaid: vis.isPaid,
        price: int.parse(Price.text),
        Participants:

        ste.PrivateParticipants.map((e) => e.id??'').toList(),
        CoverImages:
          taskS.images
        ,
        id: id,
        IsPart: false, IsPublic:! vis.isPrivate, isOnline: vis.IsOnline, googleMeetLink: vis.IsOnline?LocationController.text:"");

  }
  static void DeleteAction(BuildContext context, Activity activitys,ActivityState state) {
    final result=activityParams(type: state.selectedActivity, act: activitys,Eventid: activitys.id, name: '');

    context.read<AddDeleteUpdateBloc>().add(DeleteActivityEvent(params: result
    ));
  }

  static void UpdateAction(BuildContext context, Activity activitys) {


    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return  CreateUpdateActivityPage(id: activitys.id, activity: activitys.runtimeType == EventModel ?
          activity.Events.name :
          activitys.runtimeType == MeetingModel ?
          activity.Meetings.name :
          activity.Trainings.name, work: actionType.edit.name, particpants:activitys.Participants,);
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