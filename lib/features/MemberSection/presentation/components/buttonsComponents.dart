import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/features/intro/presentation/widgets.global.dart';

import '../../../../core/Member.dart';
import '../../../../core/MemberModel.dart';
import '../../../../core/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../global-pres.dart';
import '../bloc/objectifs/objectif_bloc.dart';
import '../widgets/achivements/BottomSheetFilterBy.dart';
import '../widgets/member/MemberImpl.dart';
import '../widgets/member/functionMember.dart';

class ButtonsMemberComponents{
  static Padding SaveChangesButton(Function() onPressed
      ,BuildContext ctx   ) {
    return Padding(
      padding: paddingSemetricHorizontal(h: 20),
      child: Row(

        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: SecondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: onPressed,
              child: Text("Save".tr(ctx),style: PoppinsSemiBold(20, textColorWhite, TextDecoration.none
              ),)),
        ],
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
                  Padding(
                      padding: paddingSemetricHorizontal(),
                      child:
                      MemberImpl.Isowner( ShowAction(context, member,      (){


                        context.go('/modifyUser?user=${jsonEncode(MemberModel.fromEntity(member).toJson())}');},"Edit Profile".tr(context)),true)
                  )
                  ,ShowAction(context, member,      (){          FunctionMember.Showinfo(context, member);},"Contact".tr(context)),
                ],
              ),
            ),
          ),
        ));
  }

  static ElevatedButton ShowAction(BuildContext context, Member member,Function() onPress,String text) {
    return ElevatedButton(
      onPressed: () {
        onPress();
      },
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(textColorWhite),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side:const  BorderSide(color: textColor))),
      ),
      child: Text(text,style: PoppinsRegular(17, textColorBlack, ),),
    );
  }



}
class FilterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
     alignment: Alignment
        .centerLeft,
      child: TextButton(
        onPressed: () => BottomSheets.showFilterBottomSheet(context),
        child: Text(
          "Filter By",
          style: PoppinsSemiBold(20.sp, ColorsApp.textColorBlack, TextDecoration.underline),
        ),
      ),
    );
  }
}
