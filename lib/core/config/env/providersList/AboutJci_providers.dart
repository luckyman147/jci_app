import 'package:provider/single_child_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/BoardBloc/boord_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/Board/YearsBloc/years_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/presidents_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/ActionJci/action_jci_cubit.dart';
import 'package:jci_app/injection_container.dart' as di;

List<SingleChildWidget> aboutJciProviders = [
  BlocProvider(create: (_) => di.sl<BoordBloc>()),
  BlocProvider(create: (_) => di.sl<YearsBloc>()),
  BlocProvider(create: (_) => di.sl<PresidentsBloc>()),
  BlocProvider(create: (_) => di.sl<ActionJciCubit>()),
];