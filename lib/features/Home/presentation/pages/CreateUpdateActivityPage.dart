

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:image_picker/image_picker.dart';


import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/services/EventStore.dart';
import 'package:jci_app/core/config/services/MeetingStore.dart';
import 'package:jci_app/core/config/services/TrainingStore.dart';


import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/textfield/textfield_bloc.dart';



import 'package:jci_app/features/Home/presentation/widgets/AddActivityWidgets.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';


import 'package:jci_app/features/auth/domain/entities/Member.dart';
import 'package:jci_app/features/auth/presentation/bloc/Members/members_bloc.dart';


import '../../../../core/config/services/MemberStore.dart';
import '../../domain/entities/Activity.dart';
import '../../domain/entities/Event.dart';

import '../../domain/entities/Formz/Image.dart';
import '../../domain/entities/Meeting.dart';
import '../../domain/entities/training.dart';
import '../bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../bloc/IsVisible/bloc/visible_bloc.dart';
import '../widgets/Formz.dart';
import '../widgets/Functions.dart';
import '../widgets/MemberSelection.dart';

Activity get ActivityTest=>Activity(name: "", id: "id", description: "description",
    ActivityBeginDate: DateTime.now(), ActivityEndDate: DateTime.now(),
    ActivityAdress: "ActivityAdress",
    ActivityPoints:2, categorie: "", IsPaid: false,
    price: 1, Participants: [], CoverImages: []);
Member get memberTest=> const Member(

    IsSelected: false, id: "id", role: "role", is_validated: false,
    cotisation:[false] , Images: [] ,firstName: "", lastName: "lastName", phone: "phone", email: "email", password: "password");

class CreateUpdateActivityPage extends StatefulWidget {
  final String id;
  final String work;
  final String activity;
  const CreateUpdateActivityPage({Key? key, required this.id, required this.activity, required this.work}) : super(key: key);

  @override
  State<CreateUpdateActivityPage> createState() =>
      _CreateUpdateActivityPageState();
}


class _CreateUpdateActivityPageState extends State<CreateUpdateActivityPage> {

  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _LeaderController = TextEditingController();
  final TextEditingController _ProfesseurName = TextEditingController();
  final TextEditingController _LocationController = TextEditingController();
  final TextEditingController _Points = TextEditingController();
  final TextEditingController _price = TextEditingController(text: "0");


@override
  void initState() {
if (widget.work=="edit"){
  debugPrint("edit");
  debugPrint("edit"+ widget.activity.split(".").last);
  if (widget.activity.split(".").last=="Events"){    _loadEventModel(widget.id);
    context.read<AcivityFBloc>().add(GetActivitiesByid(act: activity.Events, id: widget.id));
  }
  else if (widget.activity.split(".").last=="Meetings"){
_loadMeetingModel(widget.id);
    context.read<AcivityFBloc>().add(GetActivitiesByid(act: activity.Meetings, id: widget.id));

  }
  else if (widget.activity.split(".").last=="Trainings"){_loadTrainingModel(widget.id);
    context.read<AcivityFBloc>().add(GetActivitiesByid(act: activity.Trainings, id: widget.id));
  }
}
else{
  context.read<FormzBloc>().add(BeginTimeChanged(date: DateTime.now()));
  context.read<FormzBloc>().add(CategoryChanged(  category:Category.Technology));
  context.read<FormzBloc>().add(RegistraTimeChanged(date: DateTime.now().add(Duration(days: 1))));
  context.read<FormzBloc>().add(EndTimeChanged(date: DateTime.now().add(Duration(days: 1))));
  context.read<FormzBloc>().add(MemberFormzChanged( memberFormz: memberTest));
  context.read<TextFieldBloc>().add(ChangeTextFieldEvent([TextEditingController(),TextEditingController()]));
  context.read<FormzBloc>().add(ImageInputChanged(  imageInput: XFile("")));
  context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent( false));


}
  context.read<MembersBloc>().add(GetAllMembersEvent());
    // TODO: implement initState
    super.initState();
  }

  //Form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);


    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Add(formKey: _formKey, namecontroller: _namecontroller,
            descriptionController: _descriptionController, LeaderController: _LeaderController
            , ProfesseurName: _ProfesseurName, LocationController:_LocationController, Points: _Points, mediaQuery: mediaQuery, Price: _price)
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, vis) {
    return BlocBuilder<FormzBloc, FormzState>(
  builder: (context, state) {
    return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
firstLine(widget.work),
              showImagePicker(vis.selectedActivity, mediaQuery),
              TextfieldNormal(
                    "${vis.selectedActivity.name} Name", "Name of ${vis.selectedActivity.name} here", _namecontroller,

                        (value){
                      context.read<FormzBloc>().add(ActivityNameChanged(activityName: value));
                    }
                ),
               showLeader(vis.selectedActivity,mediaQuery),

                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 8),
                    child: SizedBox(
                        width: mediaQuery.size.width,
                        child: BeginTimeWidget()

                    )),
              showDetails(mediaQuery, vis.selectedActivity, state.registrationTimeInput.value??DateTime.now().add(Duration(days: 1))),
               TextfieldNormal("Points", "Points Here", _Points, (p0) => null),
               
                TextfieldDescription(
                    "Description", "Description Here", _descriptionController,

                        (value){
                      context.read<FormzBloc>().add(DescriptionChanged(description: value));
                    }
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Category",
                        style: PoppinsRegular(18, textColorBlack),
                      ),
                      SizedBox(
                          width: mediaQuery.size.width * 1.2,
                          child: MyCategoryButtons()),
                    ],
                  ),
                )
              ],
            );
  },
);
  },
),
          ),
        ),
      ),
    );
  }
Widget showLeader(activity act,mediaQuery){

    return
    act==activity.Trainings
      ?
      TextfieldNormal(
        "Professeur Name", "Professeur name here ", _ProfesseurName,
    (value){
      context.read<FormzBloc>().add(ProfesseurNameChanged(profName: value));
    }):
    act==activity.Events?
    TextfieldNormal(
        "Leader Name", "Leader name here ", _LeaderController,
    (value){
      context.read<FormzBloc>().add(LeaderNameChanged(leaderName: value));
    }):BlocBuilder<FormzBloc, FormzState>(
  builder: (context, state) {
    debugPrint("state: ${state.memberFormz.value}");
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),

          child: Text(
              "Director Name",
            style: PoppinsRegular(18, textColorBlack),
          ),
        ),
        bottomMemberSheet(context ,mediaQuery,
            state.memberFormz.value??memberTest),
      ],
    );
  },
);
        
}
Widget showRegistration(activity act,DateTime time){
    return act==activity.Events?
    Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
        child:RegistrationTime(Registration: time,)
    ):SizedBox();
}
Widget showImagePicker(activity act ,mediaQuery)=>
    act==activity.Meetings?
        SizedBox():
    Padding(

  padding: const EdgeInsets.symmetric(horizontal: 8.0),
  child: imagePicker(
  mediaQuery,
  ),
  );


  Widget showDetails(mediaQuery,activity act,DateTime time)=>
      act==activity.Meetings?
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),

            child: Text(
              "Agenda",
              style: PoppinsRegular(18, textColorBlack),
            ),
          ),
          SizedBox(child: TextFieldGenerator())]
      ) :


      Column(

    children: [
      AddEndDateButton(mediaQuery),
      const   EndDateWidget(
      ),

      showRegistration(act, time,),
      TextfieldNormal("Location", "Location Here", _LocationController,
              (value){
            context.read<FormzBloc>().add(LocationChanged(location: value));
          }
      ),
      PriceWidget(mediaQuery,_price),

    ],
  );

  void EventUpdateInfo(Event event,ha)async{
   ActivityBasics(event);

    _LeaderController.text=event.LeaderName;
    context.read<FormzBloc>().add(EndTimeChanged(date: event.ActivityEndDate));
    context.read<FormzBloc>().add(RegistraTimeChanged(date: event.registrationDeadline));
    context.read<FormzBloc>().add(ImageInputChanged(  imageInput:ha??XFile("")));
    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(event.IsPaid));
  }



  void TrainingUpdateInfo(Training train,ha)async{
   ActivityBasics(train);

    _ProfesseurName.text=train.ProfesseurName;
    context.read<FormzBloc>().add(EndTimeChanged(date: train.ActivityEndDate));

    context.read<FormzBloc>().add(ImageInputChanged(  imageInput:ha??XFile("")));
    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent(train.IsPaid));
  }
  void MeetingUpdateInfo(Meeting meeting)async{
    debugPrint(meeting.agenda.toString());
   ActivityBasics(meeting);
   List<Member> members=await MemberStore.getCachedMembers();
   Member? member=members.firstWhere((element) => element.id==meeting.Director);
   context.read<FormzBloc>().add(MemberFormzChanged( memberFormz: member));
   context.read<TextFieldBloc>().add(ChangeTextFieldEvent(createControllers(meeting.agenda)));




  }
  void  _loadEventModel(String id) async {
    // Assuming your list of events is stored in a variable called 'eventsList'
    List<Event> eventsList = await EventStore.getCachedEvents();

    // Find the event with the matching id
    Event? event = eventsList.firstWhere(
          (event) => event.id == id,

    );
    if (event != null) {
      final ha=await convertBase64ToXFile( event.CoverImages[0]!);
      EventUpdateInfo(event,ha);
    }


  } void  _loadTrainingModel(String id) async {
    // Assuming your list of events is stored in a variable called 'eventsList'
    List<Training> trainingList = await TrainingStore.getCachedTrainings();

    // Find the event with the matching id
    Training? train = trainingList.firstWhere(
          (event) => event.id == id,

    );
    if (train != null) {
      final ha=await convertBase64ToXFile( train.CoverImages[0]!);
   TrainingUpdateInfo(train, ha);
    }


  }  void  _loadMeetingModel(String id) async {


    // Assuming your list of events is stored in a variable called 'eventsList'
    List<Meeting> meetingList = await MeetingStore.getCachedMeetings();

    // Find the event with the matching id
    Meeting? meeting = meetingList.firstWhere(
          (meet) => meet.id == id,

    );
    if (meeting != null) {
MeetingUpdateInfo(meeting);
    }


  }
  void ActivityBasics(Activity act){
    _LocationController.text=act.ActivityAdress;
    _Points.text=act.ActivityPoints.toString();
    _namecontroller.text=act.name;
    _descriptionController.text=act.description; context.read<FormzBloc>().add(BeginTimeChanged(date: act.ActivityBeginDate));
    context.read<FormzBloc>().add(CategoryChanged(  category:getCategoryFromString(act.categorie)));

  }
}