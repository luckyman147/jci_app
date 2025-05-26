import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTasks/get_task_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskFilter/taskfilter_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/Timeline/timeline_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/members/members_cubit.dart';
import 'package:jci_app/features/Teams/presentation/bloc/NumPages/num_pages_bloc.dart';
import 'package:jci_app/injection_container.dart' as di;
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> teamProviders = [
  BlocProvider(create: (_) => di.sl<GetTeamsBloc>()),
  BlocProvider(create: (_) => di.sl<GetTaskBloc>()),
  BlocProvider(create: (_) => di.sl<NumPagesBloc>()),
  BlocProvider(create: (_) => di.sl<TaskVisibleBloc>()),
  BlocProvider(create: (_) => di.sl<TimelineBloc>()),
  BlocProvider(create: (_) => di.sl<MembersTeamCubit>()),
  BlocProvider(create: (_) => di.sl<TaskfilterBloc>()),
];