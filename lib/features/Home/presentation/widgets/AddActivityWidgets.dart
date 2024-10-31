
import 'dart:async';
import 'dart:developer';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';


import 'package:jci_app/features/Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Formz.dart';
import 'package:jci_app/features/Teams/presentation/widgets/CreateTeamWIdgets.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';

import '../../../../core/app_theme.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../auth/domain/entities/Member.dart';
import '../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../bloc/Activity/activity_cubit.dart';
import '../bloc/IsVisible/bloc/visible_bloc.dart';
import '../bloc/textfield/textfield_bloc.dart';
import 'AddUpdateFunctions.dart';
import 'Compoenents.dart';
import 'Functions.dart';
import 'MemberSelection.dart';


class AddWidgetComponents {


  static Widget showLeader(activity act,mediaQuery,BuildContext context,TextEditingController  ProfesseurName,TextEditingController LeaderController  ){

    return
      act==activity.Trainings
          ?
      TextfieldNormal(context,
          "Professeur Name".tr(context), "Professeur Name here".tr(context), ProfesseurName,
              (value){
            context.read<FormzBloc>().add(ProfesseurNameChanged(profName: value));
          }):
      act==activity.Events?
      TextfieldNormal(context,
          "Leader Name".tr(context), "Leader name here".tr(context), LeaderController,
              (value){
            context.read<FormzBloc>().add(LeaderNameChanged(leaderName: value));
          }):

      BlocBuilder<FormzBloc, FormzState>(
        builder: (context, state) {

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),

                child: Text(
                  "Director Name".tr(context),
                  style: PoppinsRegular(18, textColorBlack),
                ),
              ),
              bottomMemberSheet(context ,mediaQuery,
                  state.memberFormz.value??Member.memberTest,"Select A Director","Director"),
            ],
          );
        },
      );

  }
 static Widget showRegistration(activity act,DateTime time){
    return act==activity.Events?
    Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
        child:RegistrationTime(Registration: time,)
    ):const SizedBox();
  }
static   Widget showImagePicker(activity act ,mediaQuery)=>
      act==activity.Meetings?
      const SizedBox():
      Padding(

          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child:imageTeamPicker(mediaQuery)
      );


 static Widget Add({
    required GlobalKey<FormState> formKey,
    required TextEditingController namecontroller,
    required TextEditingController descriptionController,
    required TextEditingController LeaderController,
    required TextEditingController ProfesseurName,
    required TextEditingController LocationController,
    required TextEditingController Points,
    required TextEditingController Price,
    required MediaQueryData mediaQuery,
    required List<String> part,
    required String action,
    required String id,


  }) =>
      BlocBuilder<FormzBloc, FormzState>(
        builder: (context, ste) {
          return BlocBuilder<TextFieldBloc, TextFieldState>(
            builder: (context, statef) {
              return BlocBuilder<VisibleBloc, VisibleState>(
                builder: (context, vis) {
                  return BlocConsumer<AddDeleteUpdateBloc,
                      AddDeleteUpdateState>(
                    listener: (ctx, ste) {
                      AddUpdateFunctions.    Listener(ste, context);
                    },
                    builder: (context, state) {
                      return BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
                        builder: (context, state) {
                          return BlocBuilder<ActivityCubit, ActivityState>(
                            builder: (context, acti) {
                              return GestureDetector(
                                onTap: () {
                                  AddUpdateFunctions.      SaveActionFunction(acti, formKey, state, Price, ste, LeaderController, namecontroller, descriptionController, LocationController, Points, vis, part, action, id, context, ProfesseurName, statef);

                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: Text(
                                        "Save",
                                        style: PoppinsSemiBold(
                                            mediaQuery.devicePixelRatio * 6,
                                            PrimaryColor, TextDecoration.none),
                                      )),
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
          );
        },
      );











 static Widget showDetails(mediaQuery,activity act,DateTime time,BuildContext context ,TextEditingController price,TextEditingController LocationController)=>
      act==activity.Meetings?
      Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [


            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),

              child: Text(
                "Agenda".tr(context),
                style: PoppinsRegular(18, textColorBlack),
              ),
            ),
            BlocBuilder<TextFieldBloc, TextFieldState>(

              builder: (context, state) {
                if (state is TextfieldChanged) {

                  return
                    SizedBox(child: TextFieldGenerator(text: state.textFieldControllers,));
                }

                else{
                  return     SizedBox(child: TextFieldGenerator(text: state.textFieldControllers,));

                }
              },

            )]
      ) :


      Column(

        children: [


          showRegistration(act, time,),
          TextfieldNormal(context,"Location", "Location Here".tr(context), LocationController,
                  (value){
                context.read<FormzBloc>().add(LocationChanged(location: value));
              }
          ),
          PriceWidget(mediaQuery,price),

        ],
      );


 static  Widget firstLine({required String work, required mediaQuery,
    required List<String>part, required GlobalKey<FormState> formKey,
    required String id, required TextEditingController namecontroller, required TextEditingController descriptionController, required BuildContext context,
    required TextEditingController LeaderName, required TextEditingController prof, required TextEditingController price, required TextEditingController location, required TextEditingController points,


  }) =>
      BlocBuilder<PageIndexBloc, PageIndexState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackButton(
                onPressed: () {
                  AddUpdateFunctions.PopFunctions(work, context, id);
                },
              ),
              Row(
                children: [
                  work != "edit"
                      ?
                  Text("Add".tr(context),
                      style:
                      PoppinsSemiBold(18, textColorBlack, TextDecoration.none))
                      : Text("Edit".tr(context), style: PoppinsSemiBold(
                      18, textColorBlack, TextDecoration.none)),
                  work != "edit" ? const Padding(
                    padding: EdgeInsets.only(bottom: 2),
                    child: MyDropdownButton(),
                  ) : const SizedBox(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Add(formKey: formKey,
                    namecontroller: namecontroller,
                    descriptionController: descriptionController,
                    LeaderController: LeaderName,
                    ProfesseurName: prof,
                    LocationController: location,
                    Points: points,
                    mediaQuery: mediaQuery,
                    Price: price,
                    action: work,
                    id: id,
                    part: part),
              )

            ],
          );
        },
      );

 static  Widget AddEndDateButton(mediaQuery, String text) =>
      BlocBuilder<VisibleBloc, VisibleState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
            child: InkWell(
              onTap: () {
                context
                    .read<VisibleBloc>()
                    .add(VisibleEndDateToggleEvent(!state.isVisible));
              },
              child: Container(
                decoration: BoxDecoration(
                    color: PrimaryColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Icon(
                          Icons.calendar_today,
                          color: SecondaryColor,
                        ),
                      ),
                      Text(text,
                          style: PoppinsRegular(
                              mediaQuery.devicePixelRatio * 5, textColorBlack)),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );

}


class DateFieldWidget extends StatefulWidget {
  final String labelText;
  final String sheetTitle;
  final String hintTextDate;
  final String hintTextTime;
final TimeType timeType;
  final DateTime date;
  final MediaQueryData mediaQuery;


  const DateFieldWidget({
    Key? key,
    required this.labelText,
    required this.sheetTitle,
    required this.hintTextDate,
    required this.hintTextTime,
    required this.timeType,

    required this.date,
    required this.mediaQuery,

  }) : super(key: key);

  @override
  _DateFieldWidgetState createState() => _DateFieldWidgetState();
}

class _DateFieldWidgetState extends State<DateFieldWidget> {
  TimeOfDay selectedDate = TimeOfDay.now();
  DateTime time = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: PoppinsRegular(18, textColorBlack),
          ),
          BlocBuilder<FormzBloc, FormzState>(
            builder: (context, state) {
              return buildBottomSheet(context, state);
            },
          ),
        ],
      ),
    );
  }


  InkWell buildBottomSheet(BuildContext context, FormzState state) {
    return bottomSheet(
              context,
              widget.mediaQuery,
              widget.sheetTitle,
              widget.date,
              widget.hintTextDate,
              widget.hintTextTime,
              ()async {

                  final TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialEntryMode: TimePickerEntryMode.dial,
                    initialTime: selectedDate,
                  );
                  if (selectedTime != null) {
                    if (mounted) {
                      context.read<FormzBloc>().add(jokerTimeChanged(joketimer: selectedTime));
                      setState(() {
                        selectedDate = selectedTime;});
                    }
                  }
                },

             ()async {

               final temp = await showDatePicker(
                 context: context,

                 firstDate:DateTime.now(),
                 currentDate: time,
                 lastDate: DateTime.now().add(const Duration(days: 365)),
                 onDatePickerModeChange: (mode) {

                 },
               );

               if (temp != null) {
                 if (!mounted) return;

                 context.read<FormzBloc>().add(jokerChanged(joke: temp));
                  setState(() {
                    time = temp;
                  });
               }
             },
                (){
                if (widget.timeType == TimeType.begin) {
                  context.read<FormzBloc>().add(BeginTimeChanged(date: ActivityAction.combineTimeAndDate(selectedDate, time)));
                  context.pop();
                } else if (widget.timeType == TimeType.end) {
                  context.read<FormzBloc>().add(EndTimeChanged(date:ActivityAction. combineTimeAndDate(selectedDate, time)));
                  context.pop();

                }
                else{
                  context.read<FormzBloc>().add(RegistraTimeChanged(date:ActivityAction. combineTimeAndDate(selectedDate, time)));
                  context.pop();

                }
                }
            );
  }

  Future<void> ChooseTimeOFDay(BuildContext context, TimeOfDay Time, bool mounted) async {
    final temp = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: Time
    );
    if (temp != null) {
      if(!mounted) return;

      setState(() {
        context.read<FormzBloc>().add(jokerTimeChanged(joketimer: temp));
      });

    }
  }
}

Widget imagePicker(mediaQuery) {
  final ImagePicker picker = ImagePicker();
  return BlocBuilder<FormzBloc, FormzState>(
    builder: (context, state) {

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          InkWell(
            onTap: () async {
              final XFile? picked =
                  await picker.pickImage(source: ImageSource.gallery);
              if (picked != null) {
                context
                    .read<FormzBloc>()
                    .add(ImageInputChanged(imageInput: picked));
              }
            },
            child: Stack(
              children: [
                Container(

                  width: double.infinity,


                  color: PrimaryColor.withOpacity(.1),
                  child: state.imageInput.value != null && state.imageInput.value?.path != null&&state.imageInput.value?.path != ""
                      ? Image.file(
                          File(state.imageInput.value?.path ?? ""),
                          fit: BoxFit.cover,

                        )
                      :

                  Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 28.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_a_photo,
                                  size: 40,
                                  color: PrimaryColor,
                                ),
                                Text(
                                  "Add Image".tr(context),
                                  style: PoppinsRegular(19, PrimaryColor),
                                )
                              ],
                            ),
                          ),
                        ),
                ),

                state.imageInput.value != null && state.imageInput.value?.path != null&&state.imageInput.value?.path != ""?
                Positioned(
                    right: 0,

                    child:Padding(
                      padding: paddingSemetricVerticalHorizontal(v:mediaQuery.size.height/15,h: 5),

                      child: InkWell(
                        onTap: () async{
      final XFile? picked =
      await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
      context
          .read<FormzBloc>()
          .add(ImageInputChanged(imageInput: picked));
      }
      },
                                        child: Container(

                      decoration:
                      BoxDecoration(color: BackWidgetColor,
                      borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text("Edit".tr(context), style: PoppinsRegular(18, textColorBlack)),
                            const Icon(
                              Icons.edit,
                              color: textColorBlack,
                            ),
                          ],
                        ),
                      ),
                                        ),
                                      ),
                    ) ):const SizedBox()
              ],
            ),
          ),
        ],
      );
    },
  );
}

Widget TextfieldNormal(BuildContext context,String name, String HintText,
        TextEditingController controller, Function(String) onchanged) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: PoppinsRegular(18, textColorBlack),
          ),
          TextFormField(
            keyboardType:  name == "Points"||name.contains("Year")
                ? TextInputType.number
                : TextInputType.text,
            textInputAction: TextInputAction.next,
            autofocus: true,
            autocorrect: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              onchanged(value);
            },
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text'.tr(context);
              }
              return null;
            },
            style: PoppinsNorml(18, textColorBlack),
            controller: controller,
            decoration: InputDecoration(
                focusedBorder: border(PrimaryColor),
                enabledBorder: border(ThirdColor),
                errorBorder: border(Colors.red),
                focusedErrorBorder: border(PrimaryColor),

                errorStyle: ErrorStyle(18, Colors.red),
                hintStyle: PoppinsNorml(18, ThirdColor),
                hintText: HintText),
          ),
        ],
      ),
    );
Widget TextfieldDescription(BuildContext context,String name, String HintText,
        TextEditingController controller, Function(String) onChanged) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: PoppinsRegular(18, textColorBlack),
          ),
          TextFormField(autovalidateMode: AutovalidateMode.onUserInteraction,
            autocorrect: true,
            autofocus: true,
            autofillHints: [HintText],
            textInputAction: TextInputAction.done,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter some text'.tr(context);
              }
              return null;
            },
            onChanged: (value) {
              onChanged(value);
            },
            style: PoppinsNorml(18, textColorBlack),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            controller: controller,
            decoration: InputDecoration(
                focusedBorder: border(PrimaryColor),
                enabledBorder: border(ThirdColor),
                errorBorder: border(Colors.red),
                focusedErrorBorder: border(PrimaryColor),
                errorStyle: ErrorStyle(18, Colors.red),
                hintStyle: PoppinsNorml(18, ThirdColor),
                hintText: HintText),
          ),
        ],
      ),
    );


Widget chooseDate(DateTime todayDate, MediaQueryData mediaQuery, String Format,
        Function() onTap, String text,LocaleState locale) =>
    InkWell(
      onTap: () async {
        onTap();
      },

      child: BlocBuilder<FormzBloc, FormzState>(
  builder: (context, state) {
    return Container(
        width: mediaQuery.size.width,
        decoration: BoxDecoration(
            border: Border.all(color: textColorBlack),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: PoppinsLight(
                  18,
                  textColorBlack,
                ),
              ),
              Text(
                DateFormat(Format,locale.locale==const Locale("en")?"en":"fr").format(todayDate),
                style: PoppinsSemiBold(mediaQuery.devicePixelRatio * 5,
                    textColorBlack, TextDecoration.none),
              ),
            ],
          ),
        ),
      );
  },
),
    );
Widget chooseTime(TimeOfDay todaytime, MediaQueryData mediaQuery, String Format,
        Function() onTap, String text) =>
    InkWell(
      onTap: () async {
        onTap();
      },
      child: BlocBuilder<FormzBloc, FormzState>(
  builder: (context, state) {
    return Container(
        width: mediaQuery.size.width,
        decoration: BoxDecoration(
            border: Border.all(color: textColorBlack),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: PoppinsLight(
                  18,
                  textColorBlack,
                ),
              ),
              Text(
               todaytime.format(context),
                style: PoppinsSemiBold(mediaQuery.devicePixelRatio * 5,
                    textColorBlack, TextDecoration.none),
              ),
            ],
          ),
        ),
      );
  },
),
    );

Widget PriceWidget(mediaQuery,TextEditingController controller) => BlocBuilder<VisibleBloc, VisibleState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Is Paid".tr(context),
                    style: PoppinsRegular(
                        mediaQuery.devicePixelRatio * 6, textColorBlack),
                  ),
                  Checkbox(
                    value: state.isPaid,
                    onChanged: (bool? value) {

                      context
                          .read<VisibleBloc>()
                          .add(VisibleIsPaidToggleEvent(value!));
                    },
                    activeColor: PrimaryColor,
                    checkColor: textColorWhite,
                    splashRadius: 13,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ],
              ),
              Visibility(
                  visible: state.isPaid,
                  child: TextFormField(
                    controller: controller,
onChanged: (value) {
                     log(value);
                    },
                    style: PoppinsNorml(18, textColorBlack),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(

                        focusedBorder: border(PrimaryColor),
                        enabledBorder: border(ThirdColor),
                        hintStyle: PoppinsNorml(18, ThirdColor),
                        hintText: "Price".tr(context)),
                  ))
            ],
          ),
        );
      },
    );

InkWell bottomSheet(BuildContext context, MediaQueryData mediaQuery,
    String sheetTitle, DateTime date,
    String hintTextDate, String hintTextTime,
    Function() timePickerFunction,
    Function() datePickerFunction,
    Function() saveMethod,
    ) {
  return InkWell(
    onTap: () {
      showModalBottomSheet(
        context: context,
        builder: (ctx) {
          return BlocBuilder<FormzBloc, FormzState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: BottomShetBody(mediaQuery, sheetTitle, state.joker.value??DateTime.now(), hintTextDate,
                    hintTextTime, timePickerFunction, datePickerFunction,saveMethod ,state.jokertime.value??TimeOfDay.now() ,context)
              );
            },
          );
        },
      );
    },
    child:container(mediaQuery, date),
  );
}
Widget container(mediaQuery,DateTime date)=>BlocBuilder<FormzBloc, FormzState>(
  builder: (context, state) {
    return Container(
  width: mediaQuery.size.width,
  decoration: BoxDecoration(
    border: Border.all(width: 3, color: ThirdColor),
    borderRadius: BorderRadius.circular(15),
  ),
  child: Padding(
    padding: const EdgeInsets.all(15.0),
    child: Text(
      DateFormat("MMM,dd,yyyy, HH:mm a").format(date),
      style: PoppinsRegular(
        19,
        textColorBlack,
      ),
    ),
  ),
);
  },
);

Widget BottomShetBody(
    mediaQuery,String sheetTitle,
    DateTime date,
    String hintTextDate, String hintTextTime,
    Function() timePickerFunction,
    Function() datePickerFunction,
    Function() saveMethod,
    TimeOfDay time,
    BuildContext context,
    )=>SizedBox(
  height: mediaQuery.size.height / 2.5,
  width: double.infinity,
  child: Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 8.0,
      vertical: 10,
    ),
    child: BlocBuilder<localeCubit, LocaleState>(
  builder: (context, state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sheetTitle,
          style: PoppinsSemiBold(
            mediaQuery.devicePixelRatio * 6,
            PrimaryColor,
            TextDecoration.none,
          ),
        ),
        chooseDate(
         date,
          mediaQuery,
          "MMM,dd,yyyy",
          datePickerFunction,
          hintTextDate,state
          
        ),
        chooseTime(
time,
          mediaQuery,
          "hh:mm a",
          timePickerFunction,
          hintTextTime,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: PrimaryColor,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          onPressed: saveMethod,
          child: Center(
            child: Text(
              "Save".tr(context),
              style: PoppinsSemiBold(
                18,
                textColorWhite,
                TextDecoration.none,
              ),
            ),
          ),
        ),
      ],
    );
  },
),
  ),
);
class PrefixIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData iconData;

  const PrefixIconButton({super.key, required this.onPressed, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(iconData),
      onPressed: onPressed,
    );
  }
}
class TextFieldGenerator extends StatefulWidget {
  final List<TextEditingController>text;

  const TextFieldGenerator({super.key, required this.text});
  @override
  _TextFieldGeneratorState createState() => _TextFieldGeneratorState();
}

class _TextFieldGeneratorState extends State<TextFieldGenerator> {

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TextFieldBloc, TextFieldState>(
  builder: (context, state) {
    debugPrint(state.textFieldControllers.length.toString());
if (widget.text.isEmpty){
  context.read<TextFieldBloc>().add(AddTwoTextFieldEvent());
}
    return Column(
      children: [
        for (int index = 0; index < widget.text.length; index += 2)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 4),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none),
                    validator:  (value) {
                      if (value!.isEmpty) {
                        return 'Please enter some text'.tr(context);
                      }
                      return null;
                    },

                    controller: widget.text[index],
                    decoration: InputDecoration(

                      prefixIcon: PrefixIconButton(
                        onPressed: () {
                          if (index == widget.text.length - 2){
                            context.read<TextFieldBloc>().add(AddTwoTextFieldEvent());}
                          else{
                            context.read<TextFieldBloc>().add(RemoveTextFieldEvent([index, index + 1]));}


                        },
                        iconData: index==widget.text.length-2?Icons.add:Icons.remove,
                      ),
                      hintText: "Points N°${(index/2+1).toInt()}",
                      focusedBorder: border(PrimaryColor),
                      enabledBorder: border(ThirdColor),
                      focusedErrorBorder: border(Colors.red),
                      errorBorder: border(Colors.red),
                      errorStyle: ErrorStyle(18, Colors.red),
                      hintStyle: PoppinsNorml(18, ThirdColor),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    style: PoppinsSemiBold(18, textColorBlack,TextDecoration.none),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text'.tr(context);
                      }
                      return null;
                    },
                    controller: widget.text[index + 1],
                    decoration: InputDecoration(
                      hintText: "Duration",
                      focusedBorder: border(PrimaryColor),
                      enabledBorder: border(ThirdColor),
                      errorBorder: border(Colors.red),
                      focusedErrorBorder: border(Colors.red),
                      errorStyle: ErrorStyle(18, Colors.red),
                      hintStyle: PoppinsNorml(18, ThirdColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );

  },
);
  }

}
