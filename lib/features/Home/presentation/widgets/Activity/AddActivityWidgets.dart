
import 'dart:async';
import 'dart:developer';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Home/domain/entities/ParticipantDetailsParam.dart';
import 'package:jci_app/features/Home/domain/enums/Privacy.dart';


import 'package:jci_app/features/Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Fields/StandardTextFieldWidget.dart';
import 'package:jci_app/features/Home/presentation/widgets/Formz.dart';
import 'package:jci_app/features/Home/presentation/widgets/buttons/ButtonsComponent.dart';
import 'package:jci_app/features/Home/presentation/widgets/buttons/SaveButton.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/DateWidget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/CreateTeamWIdgets.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';

import '../../../../../core/PrimitiveUser/User.dart';
import '../../../../../core/app_theme.dart';
import '../../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../../../core/Member.dart';
import '../../bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import '../../bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import '../../bloc/Activity/activity_cubit.dart';
import '../../bloc/IsVisible/bloc/visible_bloc.dart';
import '../../bloc/textfield/textfield_bloc.dart';
import '../Fields/BottomDateSHeetBody.dart';
import '../Fields/ImagePicker.dart';
import '../Fields/TextFieldgenerator.dart';
import '../Functions/ActivityFunctions.dart';
import '../Functions/AddUpdateFunctions.dart';
import '../components/Compoenents.dart';
import '../Functions/Functions.dart';
import '../Members/component/MemberSelection.dart';
import '../components/ErrorDisplayMessage.dart';


class AddWidgetComponents {


  static Widget showLeader(activity act,mediaQuery,BuildContext context,TextEditingController  ProfesseurName ){
final Director=      act==activity.Events?"Leader":"Director";
return
      act==activity.Trainings
          ?
      TextfieldNormal(context,
          "Trainer Name".tr(context), "Name of the Trainer here".tr(context), ProfesseurName,
              (value){
            context.read<FormzBloc>().add(ProfesseurNameChanged(profName: value));
          }):



      SelectMembers("$Director Name", UserChoice.ONE);

  }

  static BlocBuilder<FormzBloc, FormzState> SelectMembers(String text,UserChoice choice) {
    return BlocBuilder<FormzBloc, FormzState>(
      builder: (context, state) {

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),

              child: Text(

                text.tr(context),
                style: PoppinsRegular(18, textColorBlack),
              ),
            ),

            choice==UserChoice.ONE?

            BottomMemberSheetWidget(
              member: state.memberFormz.value??User.UserTest()
                ,text: "Select  $text",title: text,
              errorText: state.Error,
              ):
            BottomPrivatePartcipantsSelectionsSheetWidget(
              members: state.PrivateParticipants
                ,text: "Select  $text",title: text,
              ),
            if (state .Error.isNotEmpty)
              Padding(
                padding:paddingSemetricHorizontal(h: 18),
                child: MessageDisplayWidget(
                  message: state.Error,
                ),
              ),
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
   const   Padding(

          padding:  EdgeInsets.symmetric(horizontal: 8.0),
          child:ImageActivityPicker()
      );









 static Widget showDetails(mediaQuery,activity act,DateTime time,BuildContext context ,TextEditingController price)=>
      act==activity.Meetings?
      const AgendaFieldWidget() :


      Column(

        children: [


          showRegistration(act, time,),


          PriceWidget(mediaQuery,price),

        ],
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

class AgendaFieldWidget extends StatelessWidget {
  const AgendaFieldWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 5),
            child: Text(
              "Agenda",
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
    );
  }
}




Widget TextfieldNormal(
    BuildContext context,
    String name,
    String hintText,
    TextEditingController controller,
    Function(String) onChanged,
    ) {
  return StandardTextFieldWidget(
    context: context,
    name: name,
    hintText: hintText,
    controller: controller,
    onChanged: onChanged,
    minLines: 1,
    maxLines: 2,
    keyboardType: name == "Points" || name.contains("Year") ? TextInputType.number : TextInputType.text,
    textInputAction: TextInputAction.next,
  );
}
Widget TextfieldDescription(
    BuildContext context,
    String name,
    String hintText,
    TextEditingController controller,
    Function(String) onChanged,
    ) {
  return StandardTextFieldWidget(
    context: context,
    name: name,
    hintText: hintText,
    controller: controller,
    onChanged: onChanged,
    isMultiline: true,
    minLines: 1,
    maxLines: 2,
    textInputAction: TextInputAction.done,
  );
}

Widget PriceWidget(mediaQuery,TextEditingController controller) => BlocBuilder<VisibleBloc, VisibleState>(
      builder: (context, state) {
        return Column(
          children: [
            StatusButton(Status:state.isPaid , onPressed: (){
                    context
                        .read<VisibleBloc>()
                        .add(VisibleIsPaidToggleEvent(!state.isPaid));

            }, isOn: Icons.attach_money, isOff: Icons.money_off, textOn: "Paid", textOff: "Free", colorOn: Colors.green, labelText: "Is Paid"),
            Visibility(
                visible: state.isPaid,
                child: StandardTextFieldWidget(
                  controller: controller,


                  keyboardType: TextInputType.number,
         context: context, name: 'Price', hintText: 'Price', onChanged: (String ) {  },
                ))
          ],
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
                child: BottomDateSheetBodyWidget(sheetTitle:  sheetTitle,date:  state.joker.value??DateTime.now(),hintTextDate:  hintTextDate,
                  hintTextTime:   hintTextTime,timePickerFunction:  timePickerFunction,datePickerFunction:  datePickerFunction,saveMethod: saveMethod ,time:state.jokertime.value??TimeOfDay.now() )
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
    border: Border.all(width: 2, color: ThirdColor),
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

