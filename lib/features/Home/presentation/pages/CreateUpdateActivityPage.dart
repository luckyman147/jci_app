

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:image_picker/image_picker.dart';


import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/services/EventStore.dart';
import 'package:jci_app/core/config/services/MeetingStore.dart';
import 'package:jci_app/core/config/services/TrainingStore.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';


import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/textfield/textfield_bloc.dart';



import 'package:jci_app/features/Home/presentation/widgets/AddActivityWidgets.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';


import 'package:jci_app/features/auth/domain/entities/Member.dart';
import 'package:jci_app/features/auth/presentation/bloc/Members/members_bloc.dart';


import '../../../../core/config/services/MemberStore.dart';
import '../../domain/entities/Activity.dart';
import '../../domain/entities/Event.dart';


import '../../domain/entities/Meeting.dart';
import '../../domain/entities/training.dart';
import '../bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../bloc/IsVisible/bloc/visible_bloc.dart';
import '../bloc/PageIndex/page_index_bloc.dart';
import '../widgets/Formz.dart';
import '../widgets/Functions.dart';
import '../widgets/MemberSelection.dart';


Activity get ActivityTest=>Activity(name: "", id: "id", description: "description",
    ActivityBeginDate: DateTime.now(), ActivityEndDate: DateTime.now(),
    ActivityAdress: "ActivityAdress",
    ActivityPoints:2, categorie: "", IsPaid: false,
    price: 1, Participants: [], CoverImages: [], IsPart: false);


class CreateUpdateActivityPage extends StatefulWidget {
  final String id;
  final String work;
  final String activity;
  final List<String> part;
  const CreateUpdateActivityPage({Key? key, required this.id, required this.activity, required this.work, required this.part}) : super(key: key);

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
  final TextEditingController _price = TextEditingController();


@override
  void initState() {

check();
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

      body: SafeArea(
        child: BlocBuilder<AcivityFBloc, AcivityFState>(
  builder: (context, state) {
   if (State is ActivityLoadingState){
return      LoadingWidget();
   }
   else{
     return body(mediaQuery);
   }
  },
),
      ),
    );
  }

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
   debugPrint("dddddddd");
   debugPrint(meeting.agenda.toString());
   debugPrint( createControllers(meeting.agenda).toString());
   context.read<TextFieldBloc>().add(ChangeTextFieldEvent(createControllers(meeting.agenda)));

    Member? member=members.firstWhere((element) => element.id==meeting.Director);
   context.read<FormzBloc>().add(MemberFormzChanged( memberFormz: member));




  }
  void  _loadEventModel(String id) async {
    // Assuming your list of events is stored in a variable called 'eventsList'
    List<Event> eventsList = await EventStore.getCachedEvents();

    // Find the event with the matching id
    Event? event = eventsList.firstWhere(
          (event) => event.id == id,

    );

      final ha=await convertBase64ToXFile( event.CoverImages[0]!);
      EventUpdateInfo(event,ha);



  }
  void  _loadTrainingModel(String id) async {
    // Assuming your list of events is stored in a variable called 'eventsList'
    List<Training> trainingList = await TrainingStore.getCachedTrainings();

    // Find the event with the matching id
    Training? train = trainingList.firstWhere(
          (event) => event.id == id,

    );
    if (train != null) {
      final ha=await convertBase64ToXFile( train.CoverImages!.isEmpty?"":train.CoverImages[0]!);
      log(ha.toString());
   TrainingUpdateInfo(train, ha);
    }


  }
  void  _loadMeetingModel(String id) async {


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
  void reset(){
    _price.text="0";
    context.read<FormzBloc>().add(BeginTimeChanged(date: DateTime.now()));
    context.read<FormzBloc>().add(CategoryChanged(  category:Category.Comity));
    context.read<FormzBloc>().add(RegistraTimeChanged(date: DateTime.now().add(Duration(days: 1))));
    context.read<FormzBloc>().add(EndTimeChanged(date: DateTime.now().add(Duration(days: 1))));
    context.read<FormzBloc>().add(MemberFormzChanged( memberFormz: memberTest));
    context.read<TextFieldBloc>().add(ChangeTextFieldEvent([TextEditingController(),TextEditingController()]));
    context.read<FormzBloc>().add(ImageInputChanged(  imageInput: XFile("")));
    context.read<VisibleBloc>().add(VisibleIsPaidToggleEvent( false));
  }
  Widget body(mediaQuery)=>SingleChildScrollView(
    child: Form(
      key: _formKey,
      child: BlocBuilder<ActivityCubit, ActivityState>(
        builder: (context, vis) {
          return BlocBuilder<FormzBloc, FormzState>(
            builder: (context, state) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  firstLine(widget.work,mediaQuery),
                  showImagePicker(vis.selectedActivity, mediaQuery),
                  TextfieldNormal(
                      "${vis.selectedActivity.name} Name", "Name of ${vis.selectedActivity.name} here", _namecontroller,

                          (value){
                        context.read<FormzBloc>().add(ActivityNameChanged(activityName: value));
                      }
                  ),
                  showLeader(vis.selectedActivity,mediaQuery,context,_ProfesseurName,_LeaderController),

                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18.0, vertical: 8),
                      child: SizedBox(
                          width: mediaQuery.size.width,
                          child: BeginTimeWidget()

                      )),
                  AddEndDateButton(mediaQuery),
                  const   EndDateWidget(
                  ),
                  showDetails(mediaQuery, vis.selectedActivity, state.registrationTimeInput.value??DateTime.now().add(Duration(days: 1)),context,_price,_LocationController),
                  TextfieldNormal("Points", "Points Here", _Points, (p0) => null),

                  TextfieldDescription(
                      "Description", "Description Here", _descriptionController,

                          (value){
                        context.read<FormzBloc>().add(DescriptionChanged(description: value));
                      }
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Text(
                          "Category",
                          style: PoppinsRegular(18, textColorBlack),
                        ),
                      ),
                      SizedBox(
                          width: mediaQuery.size.width * 1.2,
                          child: MyCategoryButtons(act: vis.selectedActivity,)),
                    ],
                  )
                ],
              );
            },
          );
        },
      ),
    ),
  );


  Widget firstLine(String work,mediaQuery ) => BlocBuilder<PageIndexBloc, PageIndexState>(
    builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          BackButton(
          onPressed: () {
        GoRouter.of(context).go('/home');
      },
      ),
      Row(
        children: [
          work!="edit"?
          Text("Create",
          style:
          PoppinsSemiBold(21, textColorBlack, TextDecoration.none)):  Text("Edit",style:PoppinsSemiBold(21, textColorBlack, TextDecoration.none)),
          work!="edit"? Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: MyDropdownButton(),
          ):SizedBox(),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Add(formKey: _formKey, namecontroller: _namecontroller,
        descriptionController: _descriptionController, LeaderController: _LeaderController
        , ProfesseurName: _ProfesseurName, LocationController:_LocationController, Points: _Points,
        mediaQuery: mediaQuery, Price: _price, action: widget.work, id: widget.id, part: widget.part),
      )

      ],
      );
    },
  );
  void check(){
    if (widget.work=="edit"){
      debugPrint("edit");
      debugPrint("edit"+ widget.activity.split(".").last);
      log(widget.activity.split(".").last);
      if (widget.activity.split(".").last=="Events"){
        context.read<AcivityFBloc>().add(GetActivitiesByid(act: activity.Events, id: widget.id));
        _loadEventModel(widget.id);  }
      else if (widget.activity.split(".").last=="Meetings"){
        context.read<AcivityFBloc>().add(GetActivitiesByid(act: activity.Meetings, id: widget.id));
        _loadMeetingModel(widget.id);


      }
      else {
        context.read<AcivityFBloc>().add(GetActivitiesByid(act: activity.Trainings, id: widget.id));
        _loadTrainingModel(widget.id);

      }
    }
    else{
      reset();


    }
  }
}