
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jci_app/features/Home/domain/Dtos/ActivityParam.dart';

import 'package:jci_app/features/Home/presentation/bloc/category/category_bloc.dart';


import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../../core/config/services/EventStore.dart';
import '../../../../../core/config/services/MeetingStore.dart';
import '../../../../../core/config/services/MemberStore.dart';
import '../../../../../core/config/services/TrainingStore.dart';
import '../../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';

import '../../../domain/entities/Activity.dart';
import '../../../domain/entities/Event.dart';
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
class AddUpdateFunctions{
  static   void PopFunctions(String work, BuildContext context,String id ) {
    if (work == "edit") {
      activityParams params = activityParams(
          type: context.read<ActivityCubit>().state.selectedActivity, act: null, Eventid: id, name: '');
      context.read<AcivityFBloc>().add(GetActivitiesByid(params:params));
      Navigator.of(context).pop();
    } else {
      context.read<ActivityCubit>().selectActivity(activity.Events);
      context.read<AddDeleteUpdateBloc>().add(const CheckPermissions(act: activity.Events));
      context.read<AcivityFBloc>().add(const GetAllActivitiesEvent(act: activity.Events));

      Navigator.of(context).pop(); }
  }





  static void reset(BuildContext context, TextEditingController price,List<String> participantsDetails){
    price.text="0";
    context.read<FormzBloc>().add(BeginTimeChanged(date: DateTime.now()));
    context.read<CategoryBloc>().add(InitCategoryEvent());
    context.read<TaskVisibleBloc>().add(const ChangeImageEvent("",ActionImage.PREVIOUS));

    context.read<FormzBloc>().add(RegistraTimeChanged(date: DateTime.now().add(const Duration(days: 1))));
    context.read<FormzBloc>().add(EndTimeChanged(date: DateTime.now().add(const Duration(days: 1))));
    context.read<FormzBloc>().add(MemberFormzChanged( memberFormz: User.UserTest()));
    context.read<FormzBloc>().add(const InitParticipants( members: []));

    context.read<TextFieldBloc>().add(ChangeTextFieldEvent([TextEditingController(),TextEditingController()]));
    context.read<FormzBloc>().add(ImageInputChanged(  imageInput: XFile("")));
    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent( false));
  }
  static bool validateTime(DateTime beginTime, DateTime endTime) {
    return beginTime.isBefore(endTime);
  }
  static void check(String work,String act, BuildContext context, String id, TextEditingController price,List< String> part,
      TextEditingController LocationController, TextEditingController Points, TextEditingController namecontroller, TextEditingController descriptionController, TextEditingController Professeur
      ,

      bool mounted){
    if (work=="edit"){


      switch (act) {
        case "Events":
          CheckFunctionPerAct(id, context,activity.Events, (id) {
            _loadEventModel(id,
                price,

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
      AddUpdateFunctions.reset(context,price,part);


    }
  }

  static void CheckFunctionPerAct(String id, BuildContext context,activity act,Function(String ) fun) {
       final result = activityParams(type:act, act: null, Eventid: id, name: '');
    context.read<AcivityFBloc>().add(GetActivitiesByid(params: result));
    fun(id);

  }
  static void EventUpdateInfo(Event event,
      TextEditingController price, BuildContext context,TextEditingController namecontroller,
      TextEditingController descriptionController,TextEditingController LocationController,TextEditingController Points,bool mounted
      )async{
    List<User> members=await MemberStore.getCachedMembers();
    ActivityBasics(event,context,LocationController,Points,namecontroller,descriptionController);
    price.text=event.price.toString();
    User? member=members.firstWhere((element) => element.id==event.LeaderName.id);
    if (!mounted) return ;
    context.read<FormzBloc>().add(MemberFormzChanged( memberFormz: member));
    context.read<FormzBloc>().add(EndTimeChanged(date: event.ActivityEndDate));
    context.read<FormzBloc>().add(RegistraTimeChanged(date: event.registrationDeadline));
    for (String image in event.CoverImages) {
      context.read<TaskVisibleBloc>().add(ChangeImageEvent(image ,ActionImage.ADD));
    }

    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(event.IsPaid));
  }
  static void TrainingUpdateInfo(Training train,
      TextEditingController price, TextEditingController ProfesseurName, BuildContext context,TextEditingController namecontroller,TextEditingController descriptionController,TextEditingController LocationController,TextEditingController Points,

      )async{
    ActivityBasics(train,context,LocationController,Points,namecontroller,descriptionController);
    price.text=train.price.toString();

    ProfesseurName.text=train.ProfesseurName;
    context.read<FormzBloc>().add(EndTimeChanged(date: train.ActivityEndDate));
    context.read<TaskVisibleBloc>().add(InitImagesEvent(  train.CoverImages));

    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(train.IsPaid));
  }
  static void MeetingUpdateInfo(Meeting meeting,BuildContext context,bool mounted,
      TextEditingController LocationController, TextEditingController Points, TextEditingController namecontroller, TextEditingController descriptionController,
      )async{

    ActivityBasics(meeting,context,LocationController,Points,namecontroller,descriptionController);
    List<User> members=await MemberStore.getCachedMembers();


    if (!mounted) return ;
    context.read<TextFieldBloc>().add(ChangeTextFieldEvent(ActivityAction.createControllers(meeting.agenda)));

    User? member=members.firstWhere((element) => element.id==meeting.Director.id);
    if (!mounted) return ;
    context.read<FormzBloc>().add(MemberFormzChanged( memberFormz: member));




  }
  static void  _loadEventModel(String id,
      TextEditingController price,BuildContext context,TextEditingController namecontroller,TextEditingController descriptionController,TextEditingController LocationController,
      TextEditingController Points, List<String> part
      ,bool mounted

      ) async {
    // Assuming your list of events is stored in a variable called 'eventsList'
    List<Event> eventsList = await EventStore.getCachedEvents();

    // Find the event with the matching id
    Event? event = eventsList.firstWhere(
          (event) => event.id == id,

    );


    if (!mounted) return ;
    EventUpdateInfo(event,price,context, namecontroller, descriptionController, LocationController, Points,mounted);



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

if (!mounted) return ;
    TrainingUpdateInfo(train, price,ProfesseurController, context, namecontroller, descriptionController, LocationController, Points);
  

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
    context.read<CategoryBloc>().add(FetchCategoriesById(  categories:act.categorieId));

  }

  static  List<String >ToIds(List<dynamic> part)=>
      part.map((e) => e['_id'] as String).toList();
}