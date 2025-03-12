

import 'dart:developer';

import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/Member.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../Home/domain/enums/ActionImage.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../auth/AuthWidgetGlobal.dart';
import '../../global-pres.dart';
import '../constants/decoration.dart';
import '../widgets/member/DescriptionWidget.dart';
import '../widgets/member/functionMember.dart';
import 'buttonsComponents.dart';

class AboutMemberComponent{

  static  Stack imagezChanged(String memberphoto,MediaQueryData mediaQuery,BuildContext context) {

    final ImagePicker picker = ImagePicker();

    return Stack(
      children: [
        Positioned(child:
        ClipOval(
          child: memberphoto.isEmpty || memberphoto == "assets/images/jci.png" ||memberphoto == vip
              ? Image.asset(vip
            ,
            fit: BoxFit.contain,
            width: 120,
            height: 120,
          )
              : Image.network(
            memberphoto,
            fit: BoxFit.contain,
            width: 120,
            height: 120,
          ),
        ),








        ),

        Positioned(
          bottom: 10,

          right: 0,
          child: SizedBox(
            height: 30,
            width: 30,
            child: IconButton(
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(PrimaryColor)),
              icon: const Center(child: Icon(Icons.camera_enhance,color: textColorWhite,size: 15,)), onPressed: () async {
              final XFile? picked =
              await picker.pickImage(source: ImageSource.gallery);
              if (picked != null) {
                context
                    .read<TaskVisibleBloc>()
                    .add(ChangeImageEvent( picked.path,ActionImage.ADD));
              }
            },),
          ),)


      ],
    );
  }


  static ClipOval SHAPE(String imageBytes, double height) {
    return ClipOval(
      child: Image.network(
        imageBytes,
        width: height,
        height: height,
        fit: BoxFit.contain, // Set the fit property of the Image widget to cover the entire CircleAvatar widget
      ),
    );
  }
    static   Widget CircleProfile(Member member,BuildContext context){
      Logger().i(member.Images.toString());

      return member.Images.isNotEmpty ?
      SizedBox(
        width: 80,
        height: 80,
        child: CircleProgressBar(
          foregroundColor: PrimaryColor,
          backgroundColor: textColorWhite,
          value: FunctionMember.calculateObjectifs(member.userObjectifs)/member.userObjectifs.length,
          child:
          member.Images.isNotEmpty?
          phot(member.Images[0],context,80):Image.asset(vip),
        ),
      ):
      NoPHoto(80,FunctionMember.calculateObjectifs(member.userObjectifs)/member.userObjectifs.length);
    }

    static SizedBox phot(String memberPhoto,BuildContext context,double height) {

      final screenSize = MediaQuery.of(context).size;
      final avatarSize = (screenSize.width / 3).round();

      return SizedBox(
          width: height,
          height: height,


          child:CircleAvatar(
            radius: avatarSize / 2,

            child: SizedBox(

              child: SHAPE(memberPhoto, height),
            ),
          )
      );
    }



    static SizedBox NoPHoto(double height,double value) {
      return SizedBox(

        width: height,
        height: height,
        child: CircleProgressBar(
          backgroundColor: textColorWhite,
          foregroundColor: PrimaryColor,
          value: value
          ,
          child: Container(


            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: AssetImage(vip)),
            ),

          ),
        ),
      );
    }

  static Widget MemberHeaader(Member member,BuildContext context){
    return SizedBox(
      height: 280,
      width: 350,
      child: Stack(
        children: [
          Center(
            child: Container(
                height: 200,
                width: 350,
                decoration: boxDecoration
            ),
          ),

          //use the positioned widget to place

          Positioned(
              top: 0,
              right: 0,
              left: 0,
              child:AboutMemberComponent. CircleProfile(member,context)

          ),

          DescriptionUser(member: member),


          ButtonsMemberComponents.    ButtonUser(context, member)



        ],
      ),
    );}

}