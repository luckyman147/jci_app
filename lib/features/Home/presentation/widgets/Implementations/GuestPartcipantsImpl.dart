
import 'package:jci_app/features/Home/domain/enums/ParticipantWithEvents.dart';

import '../../../../auth/AuthWidgetGlobal.dart';
import '../../bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import '../../bloc/Activity/BLOC/guests/guests_bloc.dart';
import '../Activity/ActivityDetailsComponents.dart';
import '../Paticipants&guests/Components.dart';
import '../components/GuestWidget.dart';
import '../shimmer/ShimmerButton.dart';

Widget ShowPartipants(String activityId,List<String> particpants) {
  return BlocBuilder<ParticpantsBloc, ParticpantsState>(
    builder: (context, state) {
      switch (state.status) {
        case ParticpantsStatus.loading:
          return const ShimmerParticipants();
        case ParticpantsStatus.initial:
        case ParticpantsStatus.failed:
          context.read<ParticpantsBloc>().add(
              LoadIsParttipatedList(particpants,activityId: activityId));

          return const ShimmerParticipants();
        case ParticpantsStatus.loaded:
        case ParticpantsStatus.changed:
        case ParticpantsStatus.success:
        case ParticpantsStatus.Present:
        case ParticpantsStatus.Absent:

        case ParticpantsStatus.empty:
          return ParticpantsComponents.ParticipantsWidget(
              state.PartcipantsSearch, activityId, context);
        default:
          context.read<ParticpantsBloc>().add(
              LoadIsParttipatedList(particpants,activityId: activityId));

          return const ShimmerParticipants();
      }
    },
  );
}

Widget ShowGuests(String activityId) {
  return BlocBuilder<GuestsBloc, GuestsState>(
    builder: (context, state) {
      switch (state.status) {
        case GuestStatus.initial:
          return const ShimmerParticipants();
        case GuestStatus.loading:
        case GuestStatus.ToMember:
          return const ShimmerParticipants();
        case GuestStatus.changed:
        case GuestStatus.failed:
          context.read<GuestsBloc>().add(
              GetGuestsOfActivityEvent(activityId: activityId));
          return const ShimmerParticipants();


        case GuestStatus.success:
        case GuestStatus.loaded:
          return GuestWidget(
            guests: state.guestsSearch, activityId: activityId, index: 0,);
        default:
          context.read<GuestsBloc>().add(
              GetGuestsOfActivityEvent(activityId: activityId));

          return const ShimmerParticipants();
      }
    },
  );
}

Widget ShowAllGuests(String activityId) {
  return BlocBuilder<GuestsBloc, GuestsState>(
    builder: (context, state) {
      switch (state.status) {
        case GuestStatus.initial:
        case GuestStatus.loading:
          return const ShimmerParticipants();
        case GuestStatus.failed:

          return const Text("data");
        case GuestStatus.changed:


          return const ShimmerParticipants();

        case GuestStatus.ToMember:
          context.read<GuestsBloc>().add(const GetAllGuestsEvent());
          return const ShimmerParticipants();


        case GuestStatus.loaded:
          return GuestWidget.GuestALL(context, state.Allguests, activityId);
        default:


          return const ShimmerParticipants();
      }
    },
  );
}
