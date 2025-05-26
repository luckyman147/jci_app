import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../core/Member.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../domain/dto/UpdateObjectiveProgressDTO.dart';
import '../../../domain/entity/ActionDetails.dart';
import '../../../domain/entity/Objectif.dart';
import '../../bloc/memberBloc/member_management_bloc.dart';
import '../../bloc/objectifs/ObjectifUserProgress/user_objectif_progress_cubit.dart';
import '../../bloc/objectifs/objectif_bloc.dart';
import '../../components/buttonsComponents.dart';
import '../../widgets/achivements/BuildObjectifWidget.dart';



class ObjectifsPage extends StatelessWidget {
  final Member member;
  final MemberManagementState state;

  const ObjectifsPage({
    Key? key,
    required this.member,
    required this.state,
  }) : super(key: key);

  static void show(BuildContext context, Member member,
      MemberManagementState state) {
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    BackButton(onPressed: () => Navigator.pop(context),),
                    Text(
                      'Objectives'.tr(context),
                      style: PoppinsSemiBold(
                          23.sp, ColorsApp.textColorBlack, TextDecoration.none),

                    ),
                  ],
                ),
                FilterButton()

              ],)
        ),

        body: BlocListener<UserObjectifProgressCubit, UserObjectifProgressState>(
          listener: (context, objState) {

          },
          child: SafeArea(

              child: BlocListener<ObjectifBloc, ObjectifState>(
                listener: (context, state) {
                  if (state.status == ObjectifStatus.Deleted) {
                    SnackBarMessage.showSuccessSnackBar(
                        message: "Objectif Deleted succefully",
                        context: context);
                    Navigator.pop(context);
                    context.read<UserObjectifProgressCubit>().updateProgressUserObjective(UpdateObjectiveProgressDTO(
                        userId: member.id!,
                        actionType: ObjectifActionType.Delete.name,
                        feature: [FeaturesType.Objectif.name], progress: 1));
                    context.read<ObjectifBloc>().add(
                        LoadObjectifs(userId: member.id!, isRefreshed: true));
                  }
                  // TODO: implement listener
                },
                child: BuildObjectifsWidget(member: member, state: state),
              )),
        ));
  }
}