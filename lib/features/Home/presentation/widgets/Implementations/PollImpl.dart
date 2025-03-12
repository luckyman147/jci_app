import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/strings/Images.string.dart';
import 'package:jci_app/features/Home/presentation/bloc/Poll/poll_bloc.dart';
import 'package:jci_app/features/Home/presentation/widgets/Fields/AddPoll.dart';
import 'package:jci_app/features/Home/presentation/widgets/activityDetailsWidget/PollWidget.dart';
import 'package:jci_app/features/Home/presentation/widgets/shimmer/ShimmerPollWidget.dart';

import '../../../Activity_Global.dart';
import '../../../domain/enums/PollEnum.dart';

class PollImpl extends StatelessWidget {
  const PollImpl({super.key, required this.activityId});
  final String activityId ;

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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Column(
                children: [
                  Image.asset(images.hello, height: 100.h,),
                  Text('No Polls Available',style: PoppinsRegular(16.sp, ColorsApp.textColorBlack),),
                ],
              ),
            ),
          ),
        );
      }
      
      
      return PollListWidget(polls: state.polls);
        default:
      ctx.read<PollBloc>().add(FetchPolls(ActivityId: activityId));
      
      return const CircularProgressIndicator();
      }
      
      
      
      
      }, listener: (ctx,state){
        if(state.pollEnum == PollEnum.Error){
          SnackBarMessage.showErrorSnackBar(message: "Failed to delete", context: ctx);
      
          context.read<PollBloc>().add(ReseTSTate());
          context.read<PollBloc>().add(FetchPolls(ActivityId: activityId));
      
        }
        if(state.pollEnum == PollEnum.Added || state.pollEnum == PollEnum.Deleted){
          context.read<PollBloc>().add(ReseTSTate());
          context.read<PollBloc>().add(FetchPolls(ActivityId: activityId));
      
        }
      
      },),
    );
  }
}
