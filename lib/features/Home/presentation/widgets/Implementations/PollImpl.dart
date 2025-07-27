import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/strings/Images.string.dart';
import 'package:jci_app/features/Home/presentation/bloc/Poll/poll_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Fields/AddPoll.dart';
import 'package:jci_app/features/Home/presentation/widgets/activityDetailsWidget/PollWidget.dart';
import 'package:jci_app/features/Home/presentation/widgets/shimmer/ShimmerPollWidget.dart';

import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../../core/config/env/Constants.dart';
import '../../../../MemberSection/domain/dto/UpdateObjectiveProgressDTO.dart';
import '../../../../MemberSection/domain/entity/ActionDetails.dart';
import '../../../../MemberSection/domain/entity/Objectif.dart';
import '../../../../MemberSection/presentation/bloc/objectifs/ObjectifUserProgress/user_objectif_progress_cubit.dart';
import '../../../Activity_Global.dart';
import '../../../domain/enums/PollEnum.dart';
import '../Activity/ActivityDetailsComponents.dart';
import '../components/poll/EmptyPollWidget.dart';
import 'ActivtysImplementations.dart';

class PollImpl extends StatelessWidget {
  const PollImpl({super.key, required this.activityId, required this.eventType});
  final String activityId ;
  final activity eventType;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{
        context.read<PollBloc>().add(FetchPolls(ActivityId: activityId));

      },
      child: BlocConsumer<PollBloc,PollState>(builder: (ctx,state){
      switch (state.pollEnum){
        case PollEnum.Initial:case PollEnum.Loading:
      return const ShimmerPollWidget();
      
        case PollEnum.Error:
      ctx.read<PollBloc>().add(FetchPolls(ActivityId: activityId));
      return const ShimmerPollWidget();
        case PollEnum.Loaded:
        case PollEnum.Added:
        case PollEnum.Deleted:
        case PollEnum.Voted:
      if (state.polls.isEmpty){
        return EmptyPollWidget(activityId: activityId, eventType: eventType);
      }
      
      
      return PollListWidget(polls: state.polls);
        default:
      ctx.read<PollBloc>().add(FetchPolls(ActivityId: activityId));
      
      return const CircularProgressIndicator();
      }
      
      
      
      
      }, listener: (ctx,state){

      },),
    );
  }
}
