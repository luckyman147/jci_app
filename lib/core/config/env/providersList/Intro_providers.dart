import 'package:provider/single_child_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';
import 'package:jci_app/features/intro/presentation/bloc/bools/bools_bloc.dart';
import 'package:jci_app/features/intro/presentation/bloc/index/index_bloc.dart';
import 'package:jci_app/features/intro/presentation/bloc/internet/internet_bloc.dart';
import 'package:jci_app/injection_container.dart' as di;

List<SingleChildWidget> introProviders = [
  BlocProvider(create: (_) => InternetCubit()..CheckConnection()),
  BlocProvider(create: (_) => di.sll<localeCubit>()..getSavedLanguage()),
  BlocProvider(create: (_) => BoolBloc()..add(resetEvent())),
  BlocProvider(create: (_) => IndexBloc(0)),
];
