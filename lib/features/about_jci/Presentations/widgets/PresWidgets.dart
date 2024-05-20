import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/presidents_bloc.dart';

import '../../../../core/strings/app_strings.dart';
import '../../../Home/presentation/widgets/Functions.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../Domain/entities/President.dart';
import '../bloc/ActionJci/action_jci_cubit.dart';
import '../screens/AddUpdatePresidentsPage.dart';
import 'Fubnctions.dart';
import 'dialogs.dart';

class PresWidgets{

  static double  FirstDescriptionHeight(BuildContext context) => JCIFunctions.getHeight("description_jci_Inter".tr(context), 16, MediaQuery.of(context).size.width/1.7);
  static double  SecondDescriptionHeight(BuildContext context) => JCIFunctions.getHeight("description_jci_Tunisia".tr(context), 16, MediaQuery.of(context).size.width/1.7);
  static double  ThirdDescriptionHeight(BuildContext context) => JCIFunctions.getHeight("description_jci_HammamSousse".tr(context), 16, MediaQuery.of(context).size.width/1.7);
  static Padding HeaderText(String title,BuildContext context){
    return Padding(
      padding: paddingSemetricHorizontal(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
width: MediaQuery.of(context).size.width/1.1,
            child: Text(title,
                textAlign: TextAlign.justify,

                style:PoppinsSemiBold(16, textColorBlack, TextDecoration.none)),
          ),
          BorderGradients(),
        ],
      ),
    );
  }
  static Padding description(String text,String images,BuildContext context){
    return Padding(
      padding: paddingSemetricHorizontal(),
      child: Column(
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width/1.5,
              child: Text(text,

                  style:PoppinsRegular(17, textColorBlack, ))),

          SizedBox(height: 10,),


        ],
      ),
    );
  }

static   Container BorderGradients() {
    return Container(
      width: 200.0,
      height: 5.0,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 4.0,
            color: Colors.transparent, // Transparent color for the border
          ),
        ),
        gradient: LinearGradient(
          colors: [PrimaryColor, SecondaryColor], // Gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  static SizedBox buildSlider(BuildContext context, List<double> heights, List<String> images,ScrollController controller) {
    List<Color> colors = [PrimaryColor, Colors.green,SecondaryColor];
    log(heights[1].toString());
    return SizedBox(
      width: MediaQuery.of(context).size.width / 3,
      height: heights.reduce((a, b) => a + b),
      child: ListView.builder(
        controller: controller,
        itemCount: heights.length * 2 , // Number of circles and dividers
        itemBuilder: (context, index) {
          if (index.isEven ) {
            // Circle
            int imageIndex = index ~/ 2;
            return avatarImage(images[imageIndex]);
          } else {
            // Divider
            int dividerIndex = (index - 1) ~/ 2;
            return Container(
              height: heights[dividerIndex]-20,
              child: VerticalDivider(
                color: colors[dividerIndex],
                thickness: 1.0,
              ),
            );
          }
        },
      ),
    );
  }

  static Center avatarImage(String images) {
    return Center(
            child: Container(
              width: 100.0,
              height: 100.0,
              child: CircleAvatar(
                radius: 100.0,
                backgroundImage: AssetImage(images),
              ),
            ),
          );
  }

static Widget sheetbody(BoxDecoration boxDecoration, President? president, TextEditingController name,bool mounted,
    TaskVisibleState ste,
    BuildContext context) {
  return
  BlocListener<PresidentsBloc, PresidentsState>(
  listener: (context, state) {
    JCIFunctions.ListenerIsAdded(state, context);
    // TODO: implement listener}
  },
  child: SingleChildScrollView(

            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonActions(context, boxDecoration,Icons.edit,"Edit President",()

                  async{

                    if (!mounted) return;


                    context.read<ActionJciCubit>().changeAction(PresidentsAction.Update);
                    Dialogs.ShoUpdateAddPresident(context, president, PresidentsAction.Update );



                  }),


                  ButtonActions(context, boxDecoration,Icons.photo,"Change  Image",()async{

                    final  image=  await  ActivityAction.convertBase64ToXFile(president!.CoverImage);
if (!mounted) return;
if (image!=null){
  context.read<TaskVisibleBloc>().add(
      ChangeImageEvent(image.path));
}
else{
  context.read<TaskVisibleBloc>().add(
      ChangeImageEvent(vip));

}

JCIFunctions.UpdatePresidentsImage(context,president!);
                  }),   ButtonActions(context, boxDecoration,Icons.delete,"Delete",(){
                    context.read<ActionJciCubit>().changeAction(PresidentsAction.Delete);
                    context.read<PresidentsBloc>().add(DeletePresident(president!.id));
                  }),

                ]),
          ),
);

}


static  Padding ButtonActions(BuildContext context, BoxDecoration boxDecoration,IconData icon,String text,Function() onpressed) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: onpressed,
      child: Container(
          height: 120,
          width: MediaQuery.of(context).size.width/4,
          decoration: boxDecoration,
          child: Padding(
            padding: paddingSemetricVertical(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: textColorWhite,
                      shape: BoxShape.circle,

                      border: Border.all(color: textColorBlack, width: 1.0),

                    ),

                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(icon),
                    )),
                Text(text.tr(context),
                  textAlign: TextAlign.center,
                  style: PoppinsSemiBold(MediaQuery.of(context).devicePixelRatio*4, textColorBlack, TextDecoration.none),),
              ],),
          )),
    ),
  );
}

}