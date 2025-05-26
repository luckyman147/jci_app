import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/util/snackbar_message.dart';
import 'package:jci_app/features/intro/presentation/widgets.global.dart';

import '../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import '../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';
import '../../../../core/Member.dart';
import '../../../../core/MemberModel.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../global-pres.dart';
import '../bloc/objectifs/objectif_bloc.dart';
import '../widgets/achivements/BottomSheetFilterBy.dart';
import '../widgets/member/MemberImpl.dart';
import '../functions/functionMember.dart';

class ButtonsMemberComponents{
  static Padding SaveChangesButton(Function() onPressed
      ,BuildContext ctx, double width   ) {
    return Padding(
      padding: paddingSemetricHorizontal(h: 20),
      child: SizedBox(
        width: width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: SecondaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: onPressed,
            child: Text("Save".tr(ctx),style: PoppinsSemiBold(20, textColorWhite, TextDecoration.none
            ),)),
      ),
    );
  }
  static Positioned ButtonUser(BuildContext context, Member member) {
    return Positioned(
        top: 170,
        right: 0,
        left: 0,
        child:
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: paddingSemetricHorizontal(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShowAction(context,      (){          FunctionMember.Showinfo(context, member);},"Contact".tr(context)),
                ],
              ),
            ),
          ),
        ));
  }
static   IconButton FlashButton(BuildContext context, Role role,Function() onPressed,IconData icon,Color color) {
  return IconButton(
    onPressed: onPressed,
    icon:  Icon(icon,color: ColorsApp.textColorWhite,),
    style: IconButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14), // Adjust for desired rectangle sharpness
        side: const BorderSide(color:ColorsApp.textColor, width: 1),
      ),
    // Adjust padding as needed
    ),
  );
}
  static ElevatedButton ShowAction(BuildContext context,Function() onPress,String text,{bool isPrimary=true}) {
    return ElevatedButton(
      onPressed: () {
        onPress();
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(isPrimary?PrimaryColor:ColorsApp.textColorWhite),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side:const  BorderSide(color: ColorsApp.ThirdColor))),
      ),
      child: AutoSizeText(text,style: PoppinsRegular(17.sp, isPrimary?textColorWhite:ColorsApp.textColorBlack, ),),
    );
  }

static Widget buttonWithicon(String label,Function () onPressed,IconData icon,BuildContext context,ObjectiveEvent event){
    return   SizedBox(
      width: MediaQuery.of(context).size.width/2.5,
      child: GestureDetector(
        onTap: () {
         onPressed();
        },
        child: BlocSelector<ObjectifBloc, ObjectifState, bool>(
  selector: (state) {
    return state.status == ObjectifStatus.CreationLoading && state.event == event;
    // TODO: return selected state
  },
  builder: (context, state) {
    return Container(
          decoration: BoxDecoration(
            border: Border.all(color: ColorsApp.textColorBlack),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              state?const LoadingWidget():
              Icon(

               icon
                ,
                size: 30,
              ),
              const SizedBox(height: 8),
             state?SizedBox():
              Text(
                label,
                style: PoppinsSemiBold(17.sp, ColorsApp.textColorBlack, TextDecoration.none)
              ),
            ],
          ),
        );
  },
),
      ),
    );


}
static  Widget buildCreateObjectif(Function() onPressed,String label ,String feature) {
    return AsyncComponents.buildFutureBuilder(
        Padding(
          padding: paddingSemetricHorizontal(),
          child: IconButton(
            style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: ColorsApp.textColorBlack, width: 2),
                )
            ),
            onPressed: onPressed, icon:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              Text( label,style:PoppinsRegular(14.sp, ColorsApp.textColorBlack) ,),],) ,


          ),
        )

        , PermissionType.canCreate, feature);
  }

}

class IconTextButton extends StatelessWidget {
  final IconData icon; // Icon to display
  final String text; // Text to display

  const IconTextButton({
    Key? key,
    required this.icon,
    required this.text,
 // Default border width
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon, // Icon passed as parameter
            size: 24, // Adjust icon size
            color:ColorsApp.textColor , // Icon color
          ),
          SizedBox(width: 8), // Space between icon and text
          GestureDetector(
           onTap: ()=>_copyToClipboard(context,text),
            child: SizedBox(
              width: MediaQuery.of(context).size.width/1.5,
              child: AutoSizeText(
                text, // Text passed as parameter
                style: PoppinsRegular(17.sp, ColorsApp.textColorBlack),
                 // Ensure text fits in one line
                minFontSize: 6, // Minimum font size for auto-sizing
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    SnackBarMessage.showSuccessSnackBar(message: "Copied", context: context);
  }
}


class FilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
     alignment: Alignment
        .centerRight,
      child: IconButton(
        onPressed: () => BottomSheets.showFilterBottomSheet(context),
        icon:const  Icon(Icons.category, color: ColorsApp.textColorBlack),

      ),
    );
  }
}
