

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/features/Home/domain/entities/Event.dart';
import 'package:jci_app/features/Home/domain/entities/training.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/IsVisible/bloc/visible_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/textfield/textfield_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/textfield/textfield_bloc.dart';


import 'package:jci_app/features/Home/presentation/widgets/AddActivityWidgets.dart';
import 'package:jci_app/features/Home/presentation/widgets/Compoenents.dart';
import 'package:jci_app/features/auth/domain/entities/LoginMember.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../domain/entities/Meeting.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../widgets/Formz.dart';

class CreateUpdateActivityPage extends StatefulWidget {
  const CreateUpdateActivityPage({Key? key}) : super(key: key);

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




  //Form key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);


    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () {},
          child: BlocBuilder<FormzBloc, FormzState>(
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
    message: ste.message, context: context);
    }
                  if (ste is LoadingAddDeleteUpdateState){
  LoadingWidget();}


      },
            builder: (context, state) {
              return BlocBuilder<ActivityCubit, ActivityState>(
  builder: (context, acti) {
    return GestureDetector(
                onTap: (){
                  final dur=DateTime.now().add(Duration(hours: 2));


                  if (acti.selectedActivity==activity.Events){if (_formKey.currentState!.validate()){
                  final act=Event(registrationDeadline: ste.registrationTimeInput.value??dur, LeaderName: _LeaderController.text,
                      name: _namecontroller.text, description: _descriptionController.text, ActivityBeginDate: ste.beginTimeInput.value??DateTime.now(),
                      ActivityEndDate: ste.endTimeInput.value??dur,
                      ActivityAdress: _LocationController.text, ActivityPoints: int.parse(_Points.text), categorie: ste.category.name, IsPaid: vis.isPaid,
                      price: 0, Participants: [], CoverImages: [ste.imageInput.value!.path. toString()], id: "id");
                  context.read<AddDeleteUpdateBloc>().add(AddACtivityEvent(act: act, type: activity.Events));}}
                  else if (acti.selectedActivity==activity.Trainings){
                    if (_formKey.currentState!.validate()){
                    final act =Training(id: "id", ProfesseurName: _ProfesseurName.text, Duration: 0, name: _namecontroller.text,
                        description: _descriptionController.text, ActivityBeginDate: ste.beginTimeInput.value??DateTime.now(), ActivityEndDate: ste.endTimeInput.value??dur,
                        ActivityAdress: _LocationController.text, ActivityPoints: int.parse(_Points.text) , categorie:ste.category.name , IsPaid: vis.isPaid,
                        price: 0, Participants: [], CoverImages: [ste.imageInput.value!.path. toString()]);
    context.read<AddDeleteUpdateBloc>().add(AddACtivityEvent(act: act, type: activity.Trainings));

    }}
                  else {
                    if (_formKey.currentState!.validate()) {
                      debugPrint("agenda: ${combineTextFields(statef.textFieldControllers)}");
                      final act = Meeting(
                          name: _namecontroller.text,
                          description: _descriptionController.text,
                          ActivityBeginDate: ste.beginTimeInput.value ??
                              DateTime.now(),
                          ActivityEndDate: ste.endTimeInput.value ?? dur,
                          ActivityAdress: _LocationController.text,
                          ActivityPoints: int.parse(_Points.text),
                          categorie: ste.category.name,
                          IsPaid: false,
                          price: 0,
                          Participants: [],
                          CoverImages: [],
                          id: "id",
                          Director: [],
                          agenda: combineTextFields(statef.textFieldControllers));
                    }
                  }
                  context.go("/home");


                },
                child: Container(
                  height: mediaQuery.size.height / 15,
                  decoration: BoxDecoration(
                      color: PrimaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                        child: Text(
                          "Save",
                          style: PoppinsRegular(
                              mediaQuery.devicePixelRatio * 7, textColorWhite),
                        )),
                  ),
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
),
        ),
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
                firstLine(),
              showImagePicker(vis.selectedActivity, mediaQuery),
              TextfieldNormal(
                    "${vis.selectedActivity.name} Name", "Name of ${vis.selectedActivity.name} here", _namecontroller,

                        (value){
                      context.read<FormzBloc>().add(ActivityNameChanged(activityName: value));
                    }
                ),
               showLeader(vis.selectedActivity),

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
Widget showLeader(activity act){
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
    }):SizedBox();
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
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Text(
              "Agenda",
              style: PoppinsRegular(18, textColorBlack),
            ),
          ),
          TextFieldGenerator()]
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
      PriceWidget(mediaQuery),

    ],
  );
  List<String> combineTextFields(List<TextEditingController> controllers) {
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
}