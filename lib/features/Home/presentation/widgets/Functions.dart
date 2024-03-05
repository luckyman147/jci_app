import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';


import '../../../../core/app_theme.dart';
import '../../../../core/util/snackbar_message.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../domain/entities/Event.dart';
import '../../domain/entities/Meeting.dart';
import '../../domain/entities/training.dart';
import '../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../bloc/Activity/activity_cubit.dart';
import '../bloc/IsVisible/bloc/visible_bloc.dart';
import '../bloc/textfield/textfield_bloc.dart';

Future <void> ChooseTimeOFDay(BuildContext context,TimeOfDay Time,bool mounted )async {
  TimeOfDay time = Time;
  final temp = await showTimePicker(
    context: context,
    initialTime: time,
  );
  if (temp != null) {
    if(!mounted) return;
    debugPrint("$temp");
    context.read<FormzBloc>().add(jokerTimeChanged(joketimer: temp));
  }
}
Future<void> DatePicker(BuildContext context ,bool mounted)async {

  final temp = await showDatePicker(
    context: context,
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(Duration(days: 365)),
  );

  if (temp != null) {
    if (!mounted) return;
    context.read<FormzBloc>().add(jokerChanged(joke: temp));
  }
}
Widget Add({
  required GlobalKey<FormState> formKey,
required TextEditingController namecontroller,
required TextEditingController descriptionController,
required TextEditingController LeaderController,
required TextEditingController ProfesseurName,
required TextEditingController LocationController,
required TextEditingController Points,
  required TextEditingController Price,
  required MediaQueryData mediaQuery,



})=>BlocBuilder<FormzBloc, FormzState>(
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


                        if (acti.selectedActivity==activity.Events){if (formKey.currentState!.validate()){
                          final act=Event(registrationDeadline: ste.registrationTimeInput.value??dur,
                              LeaderName: LeaderController.text,
                              name: namecontroller.text, description: descriptionController.text,
                              ActivityBeginDate: ste.beginTimeInput.value??DateTime.now(),
                              ActivityEndDate: ste.endTimeInput.value??dur,
                              ActivityAdress: LocationController.text,
                              ActivityPoints: int.parse(Points.text),
                              categorie: ste.category.name, IsPaid: vis.isPaid,
                              price: int.parse(Price.text), Participants: [],
                              CoverImages: [ste.imageInput.value!.path. toString()],
                              id: "id");
                          context.read<AddDeleteUpdateBloc>().add(AddACtivityEvent(act: act, type: activity.Events));}}

                        else if (acti.selectedActivity==activity.Trainings){
                          if (formKey.currentState!.validate()){
                            final act =Training(id: "id", ProfesseurName: ProfesseurName.text, Duration: 0,
                                name: namecontroller.text,
                                description: descriptionController.text,
                                ActivityBeginDate: ste.beginTimeInput.value??DateTime.now(),
                                ActivityEndDate: ste.endTimeInput.value??dur,
                                ActivityAdress: LocationController.text,
                                ActivityPoints: int.parse(Points.text) , categorie:ste.category.name ,
                                IsPaid: vis.isPaid,
                                price:int.parse(Price.text), Participants: [],
                                CoverImages: [ste.imageInput.value!.path. toString()]);
                            context.read<AddDeleteUpdateBloc>().add(AddACtivityEvent(act: act, type: activity.Trainings));

                          }}
                        else {
                          if (formKey.currentState!.validate()) {
                            debugPrint("agenda: ${combineTextFields(statef.textFieldControllers)}");
                            final act = Meeting(
                                name: namecontroller.text,
                                description: descriptionController.text,
                                ActivityBeginDate: ste.beginTimeInput.value ??
                                    DateTime.now(),
                                ActivityEndDate: ste.endTimeInput.value ?? dur,
                                ActivityAdress: LocationController.text,
                                ActivityPoints: int.parse(Points.text),
                                categorie: ste.category.name,
                                IsPaid: false,
                                price: int.parse(Price.text),
                                Participants: [],
                                CoverImages: [],
                                id: "id",
                                Director: [ste.memberFormz.value!.id],
                                agenda: combineTextFields(statef.textFieldControllers));
                            context
                                .read<AddDeleteUpdateBloc>()
                                .add(AddACtivityEvent(act:act , type: activity.Meetings));
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
);List<String> combineTextFields(List<TextEditingController> controllers) {
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
Category getCategoryFromString(String categoryString) {
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
    default:
    // You can return a default category or throw an exception based on your use case.
      throw ArgumentError('Invalid category string: $categoryString');
  }
}
List<TextEditingController> createControllers(List<String> combinedControllers) {
  List<TextEditingController> controllers = [];

  for (int i = 0; i < combinedControllers.length; i++) {
    String combinedController = combinedControllers[i];

    // Assuming the format is 'Text (Duration min)'
    RegExp regex = RegExp(r'(.+) \((\d+) min\)');

    Match? match = regex.firstMatch(combinedController);

    if (match != null && match.groupCount == 2) {
      TextEditingController textController = TextEditingController(text: match.group(1)!);
      TextEditingController durationController = TextEditingController(text: match.group(2)!);

      controllers.add(textController);
      controllers.add(durationController);
    }
  }

  return controllers;
}
