import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/PV/pv_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/pv&notes/PVWidget.dart';

import '../../../../MemberSection/domain/dto/UpdateObjectiveProgressDTO.dart';
import '../../../../MemberSection/domain/entity/ActionDetails.dart';
import '../../../../MemberSection/domain/entity/Objectif.dart';
import '../../../../MemberSection/presentation/bloc/objectifs/ObjectifUserProgress/user_objectif_progress_cubit.dart';
import '../../../Activity_Global.dart';
import '../shimmer/ShimmerPV.dart';

class PVImpl extends StatelessWidget {
  final String activityId;
  const PVImpl({super.key, required this.activityId});

  @override
  Widget build(BuildContext context) {
    return    BlocConsumer<PvBloc,PvState>(


         builder: (context, state) {
      switch (state.status) {
        case PvStatus.loading:
          return PVLoadingWidget();
        case PvStatus.initial:
        case PvStatus.error:

          context.read<PvBloc>().add(
              GetPvList(activityId));
          return PVLoadingWidget();
        case PvStatus.loaded:
        case PvStatus.Deleted:
        case PvStatus.Added:

          return PVListWidget(
              pvList: state.pvs,
          );
        default:
          context.read<PvBloc>().add(
              GetPvList( activityId));
          return PVLoadingWidget();
    }


    }, listener: (BuildContext context, PvState state) {
           if (state.Message.isNotEmpty && state.status==PvStatus.Added) {
             SnackBarMessage.showSuccessSnackBar(message: state.Message, context: context);
             context.read<PvBloc>().add(GetPvList(activityId));
             context.read<UserObjectifProgressCubit>().updateProgressUserObjective(
               UpdateObjectiveProgressDTO(
                 userId: '', // Provide the actual user ID
                 actionType: ObjectifActionType.Create.name,
                 feature: [FeaturesType.Pv.name],
               ),
             );

           }

           if (state.Message.isNotEmpty && state.status==PvStatus.error) {
             SnackBarMessage.showErrorSnackBar(message: state.Message, context: context);
           }
           else if (state.Message.isNotEmpty && state.status==PvStatus.Deleted) {
             SnackBarMessage.showSuccessSnackBar(message: state.Message, context: context);
             context.read<PvBloc>().add(GetPvList(activityId));

             context.read<UserObjectifProgressCubit>().updateProgressUserObjective(


               UpdateObjectiveProgressDTO(
                 userId: '', // Provide the actual user ID
                 actionType: ObjectifActionType.Delete.name,
                 feature: [FeaturesType.Pv.name],
               ),
             );
             context.read<UserObjectifProgressCubit>().updateProgressUserObjective(


               UpdateObjectiveProgressDTO(
                 userId: '', // Provide the actual user ID
                 actionType: ObjectifActionType.Create.name,
                 feature: [FeaturesType.Pv.name],progress: -1
               ),
             );
           }
    },);
  }
}
