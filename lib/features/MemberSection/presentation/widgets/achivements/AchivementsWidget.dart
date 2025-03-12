import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/app.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import 'package:jci_app/core/config/env/Constants.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/strings/objectifsIcon.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';
import 'package:jci_app/features/MemberSection/domain/entity/UserObjectifInfos.dart';
import 'package:jci_app/features/MemberSection/presentation/components/buttonsComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/ObjectifFormPage.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/achivements/ObjectifForm.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../core/Member.dart';
import '../../../../../core/app_theme.dart';
import '../../bloc/memberBloc/member_management_bloc.dart';
import 'package:flutter/material.dart';

import '../../bloc/objectifs/objectif_bloc.dart';
import '../../components/ObjectifField.dart';
import '../member/functionMember.dart';
import 'ObjectifImpl.dart';

class AchievementWidget extends StatelessWidget {
  final UserObjectif userObjectif;
  final Objectif objectif;

  const AchievementWidget({
    Key? key, required this.userObjectif, required this.objectif,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricHorizontal(),
      child: Container(

        decoration: BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.circular(14), // Curved border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border(
            left: BorderSide(
              color: ObjectifDifficultyColor().objectifDifficultyColor[objectif.difficulty]??ColorsApp.textColorWhite,
              width:6,
            ),
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          trailing: Text(
            "${userObjectif.currentProgress}/${objectif.target}",
            style: PoppinsRegular(17.sp, ColorsApp.ThirdColor),
          ),
          leading: Icon(
userObjectif.isCompleted
                ? Icons.check_circle
                :
            ObjectifIcons().objectifIcons[objectif.feature]!.icon,
            color: userObjectif.isCompleted
                ? Colors.green
                : ObjectifDifficultyColor().objectifDifficultyColor[objectif.difficulty]??textColor,
            size: 28, // Adjust icon size
          ),
          title:
          //TODO:Add Tr(context) to translate the text
          Text(
            "${objectif.objectifActionType.name} ${objectif.target??""} ${objectif.feature.name}",
            style: PoppinsSemiBold(
              17,
              userObjectif.isCompleted ? PrimaryColor : ColorsApp.textColorBlack,
              TextDecoration.none,
            ),
          ),
          subtitle: ClipRRect(
            borderRadius: BorderRadius.circular(10), // Round corners of progress bar
            child: LinearProgressIndicator(
              value: userObjectif.isCompleted?1:objectif.target==null?0:   userObjectif.currentProgress / objectif.target!,
              backgroundColor: ColorsApp.BackWidgetColor,
              valueColor: AlwaysStoppedAnimation<Color>(PrimaryColor),
              minHeight: 6, // Adjust height for better visibility
            ),
          ),
        ),
      ),
    );
  }
}


class BuildObjectifsWidget extends StatefulWidget {
  final Member member;
  final MemberManagementState state;


  const BuildObjectifsWidget({
    Key? key,
    required this.member,
    required this.state,
  }) : super(key: key);

  @override
  State<BuildObjectifsWidget> createState() => _BuildObjectifsWidgetState();
}

class _BuildObjectifsWidgetState extends State<BuildObjectifsWidget> {
  final PageController _pageController = PageController();
  final _scrollController = ScrollController();
  late ObjectifBloc objectifBloc;
  @override
  void initState() {
    super.initState();
    objectifBloc = BlocProvider.of<ObjectifBloc>(context);

   objectifBloc.add(LoadObjectifs(userId: widget.member.id??"",));
_scrollController.addListener(_onScroll);
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  void _onScroll() {
    if (_isBottom) objectifBloc.add(LoadMoreObjectifs(userId: widget.member.id??"", lastDocument: objectifBloc.state.lastDocument,));
  }


  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child:Column(
          children: [


            const SizedBox(height: 20),
            buildCreateObjectif((){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Objectifformpage(),
                ),
              );
            }),
        FilterButton()
            ,
            const SizedBox(height: 20),
            Expanded(
              child: Objectifimpl (controller: _scrollController, id: widget.member.id??"",),
            ),
          ],
        ),



    );
  }


  Widget buildCreateObjectif(Function() onPressed) {
    return AsyncComponents.buildFutureBuilder(
        Padding(
          padding: const EdgeInsets.all(8.0),
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
              Text("Create objectif",style:PoppinsRegular(14.sp, ColorsApp.textColorBlack) ,),],) ,


              ),
        )

        , PermissionType.canCreate, Constants.MANAGE_OBJECTIFS);
  }
}




