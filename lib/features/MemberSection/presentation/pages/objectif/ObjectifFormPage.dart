import 'package:auto_route/annotations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/MemberSection/domain/dto/UpdateObjectiveProgressDTO.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/achivements/ObjectifForm.dart';

import '../../../../../core/app_theme.dart';
import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../domain/entity/ActionDetails.dart';
import '../../../domain/entity/Objectif.dart';
import '../../../global-pres.dart';
import '../../bloc/objectifs/ObjectifForm/objectif_form_cubit.dart';
import '../../bloc/objectifs/ObjectifUserProgress/user_objectif_progress_cubit.dart';
import '../../bloc/objectifs/objectif_bloc.dart';
import '../../components/buttonsComponents.dart';
@RoutePage()
class Objectifformpage extends StatelessWidget {
  const Objectifformpage({super.key, required this.MemberId, required this.event, this.obj,});
  final String MemberId;
  final ObjectiveEvent event;
  final Objectif? obj;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            BackButton(onPressed: () {
              Navigator.pop(context);
              context.read<ObjectifFormCubit>().reset();
            },),
            Padding(
              padding: paddingSemetricHorizontal(),
              child: Text("Create objectif",
                style: PoppinsRegular(18.sp, ColorsApp.textColorBlack),),
            ),
          ],
        ),
      ),

      body: BlocListener<ObjectifBloc, ObjectifState>(
        listener: (context, state) {

if (state.status==ObjectifStatus.Updated){

  context.read<ObjectifFormCubit>().reset();

  // Reset dropdown selections if needed

  SnackBarMessage.showSuccessSnackBar(message: "Objectif Updated succefully", context: context);
  context.read<UserObjectifProgressCubit>().updateProgressUserObjective(UpdateObjectiveProgressDTO(
      userId: MemberId,
      actionType: ObjectifActionType.Update.name,
      feature: [FeaturesType.Objectif.name], progress: 1));


  context.read<ObjectifBloc>().add(
      GroupByEvent(groupBy: null));
  //close the form
  Navigator.pop(context);
  //close bottom sheet
  Navigator.pop(context);


  context.read<ObjectifBloc>().add(LoadObjectifs(userId: MemberId,isRefreshed: true));
}
else          if (state.status == ObjectifStatus.Created) {



            context.read<ObjectifFormCubit>().reset();

            // Reset dropdown selections if needed

            SnackBarMessage.showSuccessSnackBar(message: "Objectif Creation succefully", context: context);
            context.read<UserObjectifProgressCubit>().updateProgressUserObjective(UpdateObjectiveProgressDTO(
                userId: MemberId,
                actionType: ObjectifActionType.Create.name,
                feature: [FeaturesType.Objectif.name], progress: 1));

            //close the form
            Navigator.pop(context);

            context.read<ObjectifBloc>().add(
                GroupByEvent(groupBy: null));
            context.read<ObjectifBloc>().add(LoadObjectifs(userId: MemberId,isRefreshed: true));
          }
          else if (state.status==ObjectifStatus.FailureCreation){
            SnackBarMessage.showErrorSnackBar(message: "Objectif Creation Failed", context: context);
          }

        },
        child: SingleChildScrollView(child: ObjectifForm(event: event,editObj: obj,)),
      ),);
  }

}
