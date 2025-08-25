import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../MemberSection/domain/dto/UpdateObjectiveProgressDTO.dart';
import '../../../../MemberSection/domain/entity/ActionDetails.dart';
import '../../../../MemberSection/domain/entity/Objectif.dart';
import '../../../../MemberSection/presentation/bloc/objectifs/ObjectifUserProgress/user_objectif_progress_cubit.dart';
import '../../../Activity_Global.dart';
import '../../../domain/Dtos/PArticipantParam.dart';
import '../../../domain/enums/AttendeceEmum.dart';
import '../Activity/ActivityDetailsComponents.dart';
import '../components/stuff/NetworkCachedImageWidget.dart';

class ParticpantsComponents{

  static Widget ParticipantsWidget(List<ParticipantsParams>  partipants,String activityid,BuildContext ctx)=>

      Container(

        decoration: BoxDecoration(
          border: Border.all(color: textColor,),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ActivityDetailsComponent.searchField((p0) {
              ctx.read<ParticpantsBloc>().add(SearchMemberByname(name: p0));
            }

                , "${"Search".tr(ctx)} ${"Participants".tr(ctx)}",false),

            BlocBuilder<ParticpantsBloc, ParticpantsState>(

              builder: (context, state) {
                if (state.isSelectAll) {
                  return BuildCheckbox(partipants, state, ctx);
                }
                return const  SizedBox();
              },
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(

                  itemCount: partipants.length,
                  itemBuilder: (ctx, index) {
                    final participant = partipants[index];



                    return PartcipantsBody(ColorsApp.textColorWhite, participant, activityid, ctx);
                  }, separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 11,);
                },
                ),
              ),
            ),
          ],
        ),
      );

  static Widget BuildCheckbox(List<ParticipantsParams> partipants, ParticpantsState state, BuildContext ctx) {
    return Padding(
      padding: paddingSemetricVerticalHorizontal(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: Checkbox.adaptive(
                    splashRadius: 20,
                    checkColor: ColorsApp.PrimaryColor,
                    activeColor: ColorsApp.backgroundColored,
                    value: partipants.length == state.PArtcipantsSelected.length,
                    onChanged: (value) {
                      ctx.read<ParticpantsBloc>().add(SelectPartcipantsEvent(partipants, params: null));
                    }),
              ),
              Text("Select All", style: PoppinsSemiBold(15, textColorBlack, TextDecoration.none)),
            ],
          ),
          IconButton(onPressed: (){
            ctx.read<ParticpantsBloc>().add(const ChangeSelectAll(value: false));
          }, icon:const  Icon(Icons. cancel, color: SecondaryColor)),
        ],
      ),
    );
  }

  static SingleChildScrollView PartcipantsBody(Color tileColor, ParticipantsParams participant, String activityid, BuildContext ctx) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: InkWell(
        onLongPress: () {

          ctx.read<ParticpantsBloc>().add(const ChangeSelectAll(value: true));
        },
        child: Container(
          height: 80.h,
          width: MediaQuery.of(ctx).size.width * 0.9,
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: ColorsApp.backgroundColored,),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BlocBuilder<ParticpantsBloc, ParticpantsState>(

                        builder: (context, state) {
                          if (state .isSelectAll) {
                            return SizedBox(
                              width: 30,
                              height: 30,
                              child: Checkbox.adaptive(
                                  checkColor: ColorsApp.PrimaryColor,
                                  activeColor: ColorsApp.backgroundColored,
                                  value: state.PArtcipantsSelected.contains(participant), onChanged: (value){

                                ctx.read<ParticpantsBloc>().add(SelectPartcipantsEvent(null,params: participant));

                              }),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                      ClipOval(child: CachedNetworkImageWidget(item: participant.partcipantImage, height: 30, width: 30)),
                      SizedBox(width: 10.w),
                      SizedBox(width: 200.w, child: AutoSizeText(participant.partcipantName!, style: PoppinsSemiBold(15, textColorBlack, TextDecoration.none))),
                    ],
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (participant.status != Attendance.Absent)
                    AbsenceButton(
                      participant,
                      activityid,
                      ctx,
                      Icons.close,
                          () => _handleAttendanceUpdate(
                        ctx,
                        participant,
                        activityid,
                        Attendance.Absent,
                        -1,
                      ),
                    ),
                  if (participant.status != Attendance.Present)
                    AbsenceButton(
                      participant,
                      activityid,
                      ctx,
                      Icons.check,
                          () => _handleAttendanceUpdate(
                        ctx,
                        participant,
                        activityid,
                        Attendance.Present,
                        1,
                      ),
                    ),
                ],
              )

              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  static Future<void> _handleAttendanceUpdate(
      BuildContext ctx,
      ParticipantsParams participant,
      String activityId,
      Attendance status,
      int progressChange,
      ) async {
    final params = ParticipantsParams(
      activityId,
      partcipantImage: participant.partcipantImage,
      status: status,
      partcipantName: participant.partcipantName,
      partipantId: participant.partipantId,
    );

    // Dispatch bloc event
    ctx.read<ParticpantsBloc>().add(CheckAbsenceEvent(params: params));

    // Create both DTOs
  /*  final checkInDto = UpdateObjectiveProgressDTO(
      userId: "", // TODO: replace with actual user ID
      actionType: ObjectifActionType.CheckIn.name,
      feature: [FeaturesType.Members.name],
      progress: progressChange,
    );

    final attendDto = UpdateObjectiveProgressDTO(
      userId: participant.partipantId,
      actionType: ObjectifActionType.Attend.name,
      feature: [
        FeaturesType.Activities.name,
        ctx.read<ActivityCubit>().state.selectedActivity.name,
      ],
      progress: progressChange,
    );

    // Run in parallel
    await Future.wait([
      _updateWithDelay(ctx, checkInDto, Duration.zero),
      _updateWithDelay(ctx, attendDto, const Duration(seconds: 20)),
    ]);*/
  }
static  Future<void> _updateWithDelay(
      BuildContext ctx,
      UpdateObjectiveProgressDTO dto,
      Duration delay,
      ) async {
    if (delay > Duration.zero) {
      await Future.delayed(delay);
    }
    if (!ctx.mounted) return;
    ctx.read<UserObjectifProgressCubit>().updateProgressUserObjective(dto);
  }

  static IconButton AbsenceButton(ParticipantsParams participant, String activityid, BuildContext ctx,IconData icon,Function() onPressed) {
    return IconButton.outlined(
      style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          side: const BorderSide(color: textColorBlack)
      ),
      icon: Icon(icon, color: textColorBlack),
      onPressed: () {
        onPressed();
        // Add your logic to remove participant
      },
    );
  }


}