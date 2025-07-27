

import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/roles/RolePage.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/member/MemberImpl.dart';

import '../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/roles/role__bloc.dart';
import '../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import '../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../core/Member.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/config/env/Constants.dart';
import '../../../../core/strings/app_strings.dart';
import '../../../Home/domain/enums/ActionImage.dart';
import '../../../Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import '../../../auth/AuthWidgetGlobal.dart';
import '../../global-pres.dart';
import '../constants/decoration.dart';
import '../widgets/member/BottomShettMember.dart';
import '../widgets/member/DescriptionWidget.dart';
import '../functions/functionMember.dart';
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
  static Widget CircleProfile(Member member, BuildContext context) {


    return member.Images.isNotEmpty
        ? SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.bottomRight, // Position the icon at the bottom right
        children: [
          CircleProgressBar(
            strokeWidth: 5,
            foregroundColor: PrimaryColor,
            backgroundColor: ColorsApp.BackWidgetColor
            ,
            value: FunctionMember.calculateObjectifs(member.userObjectifs) / member.userObjectifs.length,
            child: member.Images.isNotEmpty
                ? phot(member.Images[0], context, 80)
                : Image.asset(vip),
          ),
          // Add an icon on top of the photo

       MemberImpl.isOwner(

          Container(
            padding: EdgeInsets.all(4), // Adjust padding as needed
            decoration: BoxDecoration(
              color: ColorsApp.PrimaryColor, // Background color for the icon
              shape: BoxShape.circle, // Circular shape for the icon container
            ),
            child: Icon(
              Icons.edit, // Replace with your desired icon
              size: 20, // Adjust icon size
              color: ColorsApp.textColorWhite, // Adjust icon color
            ),
          )

       , true)
        ],
      ),
    )
        : NoPHoto(80, FunctionMember.calculateObjectifs(member.userObjectifs) / member.userObjectifs.length);
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
    return Column(
mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        //use the positioned widget to place

Container(
decoration: profilbox(),
  child: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TheImportantInfosWidget(member, context),

        if (member.description.isNotEmpty)
          Padding(
            padding:paddingSemetricVerticalHorizontal(),
            child: AutoSizeText("${member.description } ",

              style: PoppinsRegular(14.sp, ColorsApp.ThirdColor, ),),
          ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (member. email.isNotEmpty)
            IconTextButton(icon: Icons.email, text: member.email,),
            if (member. phone.isNotEmpty)
            IconTextButton(icon: Icons.phone_android, text: member.phone,),
          ],
        ),

      ],

    ),
  ),
),

        DescriptionUser(member: member),




       //     ButtonsMemberComponents.    ButtonUser(context, member)



      ],
    );}

  static Row TheImportantInfosWidget(Member member, BuildContext context) {
    return Row(
        children: [
          Padding(
            padding:paddingSemetricHorizontal(h:12.sp),
            child: AboutMemberComponent. CircleProfile(member,context),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DescriptionName(member: member, ),
              SizedBox(
                height: 39,
                child: Row(

                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AutoSizeText(
                      member.roleName.toString(),
                      style: PoppinsRegular(20.sp, ColorsApp.PrimaryColor,),
                    ),
                    AsyncComponents.buildFutureBuilder(
                        IconButton(
                          onPressed: () {
                           RolePage.show(context, member);
                           context.read<RoleBloc>().add(FetchRolesEvent());

                          },
                          icon:  Icon(Icons.edit_rounded,color: ColorsApp.PrimaryColor,size: 17,),
                        ),PermissionType.canRead,
                        Constants.MANAGE_MEMBERS

                    ),

                  ],
                ),
              ),


            ],
          ),

        ],
      );
  }

  static BoxDecoration profilbox() {
    return BoxDecoration(
borderRadius: BorderRadius.circular(17),
color: ColorsApp.textColorWhite,
border: Border.all(color: ColorsApp.textColorBlack,width: 2),
boxShadow:
  [BoxShadow(
    color: ColorsApp.BackWidgetColor.withOpacity(.3),
    spreadRadius: 5,
    offset: Offset(0, 5)
      ,blurRadius: 5


  )]

);
  }

}