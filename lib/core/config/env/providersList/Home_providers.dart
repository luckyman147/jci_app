import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/PV/pv_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/Participants/particpants_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/guests/guests_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/ChangeString/change_string_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/DescriptionBoolean/description_bool_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Poll/poll_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/calendar/calendar_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/category/category_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityComment/activity_comment_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/IsVisible/bloc/visible_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/textfield/textfield_bloc.dart';
import 'package:jci_app/injection_container.dart' as di;
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> homeProviders = [
  BlocProvider(
      create: (_) => di.sll<AcivityFBloc>()
        ..add(const GetActivitiesOfMonthEvent(act: activity.Events))),
  BlocProvider(create: (_) => di.sll<VisibleBloc>()),
  BlocProvider(create: (_) => di.sll<TextFieldBloc>()),
  BlocProvider(create: (_) => di.sll<ParticpantsBloc>()),
  BlocProvider(create: (_) => di.sll<CategoryBloc>()),
  BlocProvider(create: (_) => di.sll<GuestsBloc>()),
  BlocProvider(create: (_) => di.sll<PollBloc>()),
  BlocProvider(create: (_) => di.sll<ActivityCommentBloc>()),
  BlocProvider(create: (_) => di.sll<PvBloc>()),
  BlocProvider(create: (_) => di.sll<FormzBloc>()),
  BlocProvider(create: (_) => di.sll<AddDeleteUpdateBloc>()),
  BlocProvider(create: (_) => CalendarCubit()),
  BlocProvider(create: (_) => ActivityCubit()),
  BlocProvider(create: (_) => DescriptionBoolBloc()),
  BlocProvider(create: (_) => ChangeStringBloc()),
  BlocProvider(create: (_) => PageIndexBloc()),
];