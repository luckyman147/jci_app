import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';

import '../../../../core/Member.dart';
import '../../../../core/app_theme.dart';
import '../../global-pres.dart';
import '../bloc/memberBloc/member_management_bloc.dart';
import '../widgets/achivements/AchivementsWidget.dart';

class ObjectifsPage extends StatelessWidget {
  final Member member;
  final MemberManagementState state;

  const ObjectifsPage({
    Key? key,
    required this.member,
    required this.state,
  }) : super(key: key);

  static void show(BuildContext context, Member member, MemberManagementState state) {

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ObjectifsPage(member: member, state: state),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(children: [
            BackButton(onPressed: ()=>Navigator.pop(context),),
            Text(
              'Objectives'.tr(context),
              style: PoppinsSemiBold(23.sp, ColorsApp.textColorBlack,TextDecoration.none),

            ),

          ],)
        ),
        
        body: SafeArea(

            child: BuildObjectifsWidget(member: member, state: state)));
  }}