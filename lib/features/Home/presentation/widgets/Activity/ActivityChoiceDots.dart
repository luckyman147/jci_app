import 'package:jci_app/features/Home/domain/Dtos/ActivityParam.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/guests/guests_bloc.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../Activity_Global.dart';
import '../../bloc/PageIndex/page_index_bloc.dart';
import '../Functions/ActivityFunctions.dart';
import '../Implementations/GuestPartcipantsImpl.dart';
import '../Paticipants&guests/PartcipantsWidget.dart';
import 'ActivityDetailsComponents.dart';


class ActivityChoiceDots extends StatelessWidget {
  const ActivityChoiceDots({super.key, required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return
   Padding(
             padding: const EdgeInsets.all(16.0),
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 // Header
                 Text(
                   "Choose an Option",
                   style: PoppinsSemiBold(17, ColorsApp.textColorBlack, TextDecoration.none),
                 ),
                 const SizedBox(height: 20),
                 // Grid Buttons

                 GridView.count(
                   shrinkWrap: true,
                   crossAxisCount: 2,
                   childAspectRatio: 1.9,
                   mainAxisSpacing: 10,
                   crossAxisSpacing: 10,
                   children: [

                     actionRow(
                       mediaQuery,
                       activity,
                       textColorBlack,
                       Icons.play_arrow,
                       "Start Meeting",
                           () {

                       },
                       //pop

                       context,
                     ),



                     actionRow(
                       mediaQuery,
                       activity,
                       textColorBlack,
                       Icons.timer_rounded,
                       "Reminder",
                           () {
                             context
                           .read<ParticpantsBloc>()
                           .add(SendReminderEvent(reminderParams: ReminderParams(activity.activityBasics.activityAdress,ActivityName: activity.activityBasics.name,
                                 ActivityBeginDate: activity.activityBasics.activityBeginDate.toIso8601String())));
                             ///pop
                             Navigator.pop(context);

                             },
                       //pop

                       context,
                     ),
                     actionRow(
                       mediaQuery,
                       activity,
                       textColorBlack,
                       Icons.edit,
                       "Update".tr(context),
                           () {
                         ActivityFunctions.UpdateAction(context, activity);
                       },
                       context,
                     ),
                     actionRow(
                       mediaQuery,
                       activity,
                       textColorBlack,
                       Icons.person_3,
                       "Participants",
                           () {
                             context.read<PageIndexBloc>().add(
                               SetParticipantIndexEvent( ParticipantIndex: 0),
                             );
Logger().i("activity id ${activity.participation.participants .map((e) => e.toString())}");
   //routes to the participants page
context.read<ParticpantsBloc>().add(
    LoadIsParttipatedList(context.read<AcivityFBloc>().state.activityById!.participation.participants,activityId: activity.activityBasics.id));
                         Navigator.push(
                           context,
                           MaterialPageRoute(
                             builder: (context) => PartcipantsMainwidget(activity: activity),
                           ),
                         );


                       },
                       context,
                     ), actionRow(
                       mediaQuery,
                       activity,
                       textColorBlack,
                       FontAwesomeIcons.crown,
                       "Guests",
                           () {
Navigator.pop(context);
                        context.read<GuestsBloc>().add( GetGuestsOfActivityEvent(activityId: activity.activityBasics.id));
   //routes to the participants page

showModalBottomSheet(

  isScrollControlled: true,
    useSafeArea: true,
    elevation: 10,
    shape:const  RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    showDragHandle: true,



    context: context, builder: (context){
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                               height: mediaQuery.size.height,
                               child: ShowGuests(activity.activityBasics.id)),
                        );

                       });



                       },
                       context,
                     ),

                     BlocBuilder<ActivityCubit, ActivityState>(
                       builder: (context, state) {
                         return actionRow(
                           mediaQuery,
                           activity,
                           Colors.red,
                           Icons.delete,
                           "Delete".tr(context),
                               () {
                             ActivityFunctions.DeleteAction(context, activity, state);
                           },
                           context,
                         );
                       },
                     ),

                   ],
                 ),
               ],
             ),
           );


    }
}


