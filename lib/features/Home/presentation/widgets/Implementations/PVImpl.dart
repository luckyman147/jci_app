import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/PV/pv_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/PVWidget.dart';

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
           }

           if (state.Message.isNotEmpty && state.status==PvStatus.error) {
             SnackBarMessage.showErrorSnackBar(message: state.Message, context: context);
           }
           else if (state.Message.isNotEmpty && state.status==PvStatus.loaded) {
             SnackBarMessage.showSuccessSnackBar(message: state.Message, context: context);
           }
    },);
  }
}
