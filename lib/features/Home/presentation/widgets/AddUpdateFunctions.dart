import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';


import '../../../../core/config/services/EventStore.dart';
import '../../../../core/config/services/MeetingStore.dart';
import '../../../../core/config/services/MemberStore.dart';
import '../../../../core/config/services/TrainingStore.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../auth/domain/entities/Member.dart';
import '../../data/model/events/EventModel.dart';
import '../../data/model/meetingModel/MeetingModel.dart';
import '../../domain/entities/Activity.dart';
import '../../domain/entities/Event.dart';
import '../../domain/entities/Meeting.dart';
import '../../domain/entities/training.dart';
import '../../domain/usercases/ActivityUseCases.dart';
import '../bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../bloc/Activity/activity_cubit.dart';
import '../bloc/IsVisible/bloc/visible_bloc.dart';
import '../bloc/textfield/textfield_bloc.dart';
import '../pages/CreateUpdateActivityPage.dart';
import 'Functions.dart';
import 'ActivityDetailsComponents.dart';
class AddUpdateFunctions{
  static   void PopFunctions(String work, BuildContext context,String id ) {
    if (work == "edit") {
      activityParams params = activityParams(
          type: context.read<ActivityCubit>().state.selectedActivity, act: null, id: id, name: '');
      context.read<AcivityFBloc>().add(GetActivitiesByid(params:params));
      Navigator.of(context).pop();
    } else {
      context.read<ActivityCubit>().selectActivity(activity.Events);
      context.read<AddDeleteUpdateBloc>().add(const CheckPermissions(act: activity.Events));
      context.read<AcivityFBloc>().add(const GetAllActivitiesEvent(act: activity.Events));

      Navigator.of(context).pop(); }
  }
  static void SaveActionFunction(ActivityState acti, GlobalKey<FormState> formKey, TaskVisibleState state, TextEditingController Price, FormzState ste, TextEditingController LeaderController, TextEditingController namecontroller, TextEditingController descriptionController, TextEditingController LocationController, TextEditingController Points, VisibleState vis, List<String> part, String action, String id, BuildContext context, TextEditingController ProfesseurName, TextFieldState statef) {
     final dur = DateTime.now().add(
        const Duration(hours: 2));

    Activity? act;
    switch (acti.selectedActivity) {
      case activity.Events:
        if (IsValidated(formKey, state)) {
          act = EventAction(
            Price,
            ste,
            dur,
            LeaderController,
            namecontroller,
            descriptionController,
            LocationController,
            Points,
            vis,
            part,
            action,
            id,
            context,
            state,
          );
        }
        break;
      case activity.Trainings:
        if (IsValidated(formKey, state)) {
          act = TrainingAction(
            formKey,
            ste,
            id,
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
            id,
            statef,
            action,
            context,
          );
        }
    }

    if(act!=null){
      ContextActionaAddOrEdit(acti, act, id, action, context);

    }
  }

  static void ContextActionaAddOrEdit(ActivityState acti, Activity act, String id, String action, BuildContext context) {
     final param =activityParams(type: acti.selectedActivity, act: act,id: id, name: '');
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

  static bool IsValidated(GlobalKey<FormState> formKey, TaskVisibleState state) {
    return formKey.currentState!.validate() &&
                                      state.image.isNotEmpty;
  }

  static Activity MeetingAction(GlobalKey<FormState> formKey, TextEditingController namecontroller, TextEditingController descriptionController, FormzState ste, DateTime dur, TextEditingController LocationController, TextEditingController Points, List<String> part, String id, TextFieldState statef, String action, BuildContext context) {

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
        categorie: ste.category.name,
        IsPaid: false,
        price: 0,
        Participants: part,
        CoverImages: const [],
        id: id,
        Director: [ste.memberFormz.value!.id],
        agenda:ActivityAction. combineTextFields(
            statef.textFieldControllers),
        IsPart: false);

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
        categorie: ste.category.name,
        IsPaid: vis.isPaid,
        price: int.parse(Price.text),
        Participants: part,
        CoverImages: [
          taskS.image
        ],
        IsPart: false);


  }

  static Activity EventAction(TextEditingController Price, FormzState ste, DateTime dur, TextEditingController LeaderController, TextEditingController namecontroller, TextEditingController descriptionController, TextEditingController LocationController, TextEditingController Points, VisibleState vis, List<String> part, String action, String id,
      BuildContext context,TaskVisibleState taskS) {
    log("sss${Price.text}");
    return Event(
        registrationDeadline: ste
            .registrationTimeInput
            .value ?? dur,
        LeaderName: LeaderController.text,
        name: namecontroller.text,
        description: descriptionController.text,
        ActivityBeginDate: ste.beginTimeInput
            .value ??
            DateTime.now(),
        ActivityEndDate: ste.endTimeInput.value ??
            dur,
        ActivityAdress: LocationController.text,
        ActivityPoints: int.parse(Points.text),
        categorie: ste.category.name,
        IsPaid: vis.isPaid,
        price: int.parse(Price.text),
        Participants: part,
        CoverImages: [
          taskS.image
        ],
        id: action == "edit" ? id : "",
        IsPart: false);

  }

  static void Listener(AddDeleteUpdateState ste, BuildContext context) {
    if (ste is ErrorAddDeleteUpdateState) {
      SnackBarMessage.showErrorSnackBar(
          message: ste.message, context: context);
    }
    if (ste is MessageAddDeleteUpdateState) {
      SnackBarMessage.showSuccessSnackBar(
          message: ste.message, context: context);
      Navigator.of(context).pop();
    }
    if (ste is ActivityUpdatedState) {
      SnackBarMessage.showSuccessSnackBar(
          message: ste.message, context: context);
      context.pop();
    }
    if (ste is DeletedActivityMessage) {
      SnackBarMessage.showSuccessSnackBar(
          message: ste.message, context: context);
      context.pop();
    }
    if (ste is LoadingAddDeleteUpdateState) {
      const LoadingWidget();
    }
  }
  static void DeleteAction(BuildContext context, Activity activitys,ActivityState state) {
    final result=activityParams(type: state.selectedActivity, act: activitys,id: activitys.id, name: '');

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
          activity.Trainings.name, work: actionD.edit.name, part:ToIds(activitys.Participants),);
        },
      ),
    );



  }



  static void reset(BuildContext context, TextEditingController price){
    price.text="0";
    context.read<FormzBloc>().add(BeginTimeChanged(date: DateTime.now()));
    context.read<FormzBloc>().add(const CategoryChanged(  category:Category.Comity));
    context.read<FormzBloc>().add(RegistraTimeChanged(date: DateTime.now().add(const Duration(days: 1))));
    context.read<FormzBloc>().add(EndTimeChanged(date: DateTime.now().add(const Duration(days: 1))));
    context.read<FormzBloc>().add(MemberFormzChanged( memberFormz: Member.memberTest));
    context.read<TextFieldBloc>().add(ChangeTextFieldEvent([TextEditingController(),TextEditingController()]));
    context.read<FormzBloc>().add(ImageInputChanged(  imageInput: XFile("")));
    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent( false));
  }
  static bool validateTime(DateTime beginTime, DateTime endTime) {
    return beginTime.isBefore(endTime);
  }
  static void check(String work,String act, BuildContext context, String id, TextEditingController price,List< String> part,
      TextEditingController LocationController, TextEditingController Points, TextEditingController namecontroller, TextEditingController descriptionController, TextEditingController LeaderController, TextEditingController Professeur
      ,

      bool mounted){
    if (work=="edit"){


      switch (act) {
        case "Events":
          CheckFunctionPerAct(id, context,activity.Events, (id) {
            _loadEventModel(id,
                price,
                LeaderController,
                context,
                namecontroller,
                descriptionController,
                LocationController,
                Points,

                part,

   mounted


            );
          });

        case "Meetings":
          CheckFunctionPerAct(id, context,activity.Meetings, (id) {
            _loadMeetingModel(id,context,mounted,LocationController,Points,namecontroller,descriptionController);
          });


        default:
          CheckFunctionPerAct(id, context,activity.Trainings, (id) {
            _loadTrainingModel(id,price,Professeur,context,namecontroller,descriptionController,LocationController,Points,mounted);
          });
      }
    }
    else{
      AddUpdateFunctions.reset(context,price);


    }
  }

  static void CheckFunctionPerAct(String id, BuildContext context,activity act,Function(String ) fun) {
       final result = activityParams(type:act, act: null, id: id, name: '');
    context.read<AcivityFBloc>().add(GetActivitiesByid(params: result));
    fun(id);

  }
  static void EventUpdateInfo(Event event,ha,
      TextEditingController price, TextEditingController LeaderController, BuildContext context,TextEditingController namecontroller,
      TextEditingController descriptionController,TextEditingController LocationController,TextEditingController Points, List<String> part
      )async{
    ActivityBasics(event,context,LocationController,Points,namecontroller,descriptionController);
    price.text=event.price.toString();
    LeaderController.text=event.LeaderName;
    context.read<FormzBloc>().add(EndTimeChanged(date: event.ActivityEndDate));
    context.read<FormzBloc>().add(RegistraTimeChanged(date: event.registrationDeadline));
    context.read<TaskVisibleBloc>().add(ChangeImageEvent(  ha.path??"assets/images/blankjci.jpeg"));
    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(event.IsPaid));
  }
  static void TrainingUpdateInfo(Training train,ha,
      TextEditingController price, TextEditingController ProfesseurName, BuildContext context,TextEditingController namecontroller,TextEditingController descriptionController,TextEditingController LocationController,TextEditingController Points,

      )async{
    ActivityBasics(train,context,LocationController,Points,namecontroller,descriptionController);
    price.text=train.price.toString();

    ProfesseurName.text=train.ProfesseurName;
    context.read<FormzBloc>().add(EndTimeChanged(date: train.ActivityEndDate));
    context.read<TaskVisibleBloc>().add(ChangeImageEvent(  ha.path??"assets/images/blankjci.jpeg"));

    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(train.IsPaid));
  }
  static void MeetingUpdateInfo(Meeting meeting,BuildContext context,bool mounted,
      TextEditingController LocationController, TextEditingController Points, TextEditingController namecontroller, TextEditingController descriptionController,
      )async{

    ActivityBasics(meeting,context,LocationController,Points,namecontroller,descriptionController);
    List<Member> members=await MemberStore.getCachedMembers();

    debugPrint(meeting.agenda.toString());
    debugPrint( ActivityAction.createControllers(meeting.agenda).toString());
    if (!mounted) return ;
    context.read<TextFieldBloc>().add(ChangeTextFieldEvent(ActivityAction.createControllers(meeting.agenda)));

    Member? member=members.firstWhere((element) => element.id==meeting.Director);
    if (!mounted) return ;
    context.read<FormzBloc>().add(MemberFormzChanged( memberFormz: member));




  }
  static void  _loadEventModel(String id,
      TextEditingController price, TextEditingController LeaderController, BuildContext context,TextEditingController namecontroller,TextEditingController descriptionController,TextEditingController LocationController,
      TextEditingController Points, List<String> part
      ,bool mounted

      ) async {
    // Assuming your list of events is stored in a variable called 'eventsList'
    List<Event> eventsList = await EventStore.getCachedEvents();

    // Find the event with the matching id
    Event? event = eventsList.firstWhere(
          (event) => event.id == id,

    );

    final ha=await ActivityAction.convertBase64ToXFile( event.CoverImages.isEmpty?"":event.CoverImages[0]!);
    if (!mounted) return ;
    EventUpdateInfo(event,ha, price, LeaderController, context, namecontroller, descriptionController, LocationController, Points, part);



  }
 static  void  _loadTrainingModel(String id,
     TextEditingController price, TextEditingController ProfesseurController,
     BuildContext context,TextEditingController namecontroller,
     TextEditingController descriptionController,TextEditingController LocationController,TextEditingController Points
     ,bool mounted


     ) async {
    // Assuming your list of events is stored in a variable called 'eventsList'
    List<Training> trainingList = await TrainingStore.getCachedTrainings();

    // Find the event with the matching id
    Training? train = trainingList.firstWhere(
          (event) => event.id == id,

    );
    final ha=await ActivityAction.convertBase64ToXFile( train.CoverImages.isEmpty?"":train.CoverImages[0]!);
if (!mounted) return ;
    TrainingUpdateInfo(train, ha, price,ProfesseurController, context, namecontroller, descriptionController, LocationController, Points);
  

  }
 static  void  _loadMeetingModel(String id,
     BuildContext context,bool mounted,TextEditingController LocationController, TextEditingController Points, TextEditingController namecontroller, TextEditingController descriptionController
     ,


     ) async {


    // Assuming your list of events is stored in a variable called 'eventsList'
    List<Meeting> meetingList = await MeetingStore.getCachedMeetings();

    // Find the event with the matching id
    Meeting? meeting = meetingList.firstWhere(
          (meet) => meet.id == id,

    );
    if (!mounted) return ;
    MeetingUpdateInfo(meeting,context,mounted,LocationController,Points,namecontroller,descriptionController);
  

  }
  static void ActivityBasics(Activity act , BuildContext context,

      TextEditingController LocationController, TextEditingController Points, TextEditingController namecontroller, TextEditingController descriptionController){

    LocationController.text=act.ActivityAdress;
    Points.text=act.ActivityPoints.toString();
    namecontroller.text=act.name;
    descriptionController.text=act.description; context.read<FormzBloc>().add(BeginTimeChanged(date: act.ActivityBeginDate));
    context.read<FormzBloc>().add(CategoryChanged(  category:ActivityAction.getCategoryFromString(act.categorie)));

  }

  static  List<String >ToIds(List<dynamic> part)=>
      part.map((e) => e['_id'] as String).toList();
}