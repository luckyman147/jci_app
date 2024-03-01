import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ACtivityOfweek/activity_ofweek_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/AddDeleteUpdateActivity/add_delete_update_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/formzBloc/formz_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';
import 'package:jci_app/features/Home/presentation/bloc/ChangeString/change_string_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/DescriptionBoolean/description_bool_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/ResetPassword/reset_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';
import 'package:jci_app/features/intro/presentation/bloc/bools/bools_bloc.dart';
import 'package:jci_app/features/intro/presentation/bloc/index_bloc.dart';
import 'package:jci_app/features/intro/presentation/bloc/internet/internet_bloc.dart';

import '../../../features/Home/presentation/bloc/IsVisible/bloc/visible_bloc.dart';
import '../../../features/Home/presentation/bloc/textfield/textfield_bloc.dart';
import '../../../injection_container.dart' as di;

// ignore: depend_on_referenced_packages
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> providersList = [
  BlocProvider(
      create: (_) => di.sl<AcivityFBloc>()
        ..add(const GetActivitiesOfMonthEvent(act: activity.Events))),
  BlocProvider(
      create: (_) => di.sl<ActivityOfweekBloc>()
        ..add(const GetOfWeekActivitiesEvent(act: activity.Events))),
  BlocProvider(create: (_) => InternetCubit()..CheckConnection()),
  BlocProvider(create: (_) => di.sl<ResetBloc>()),
  BlocProvider(create: (_)=> di.sl<VisibleBloc>()),
  BlocProvider(create: (_)=> di.sl<TextFieldBloc>()),
  BlocProvider(
      create: (_) => di.sl<AuthBloc>()..add(const RefreshTokenEvent())),
  BlocProvider(create: (_) => di.sl<SignUpBloc>()),
  BlocProvider(create: (_) => di.sl<LoginBloc>()),

  BlocProvider(create: (_) => localeCubit()..getSavedLanguage()),
  BlocProvider(create: (_) => ActivityCubit()),
  BlocProvider(create: (_) => di.sl<FormzBloc>()),
  BlocProvider(create: (_) => di.sl<AddDeleteUpdateBloc>()),
  BlocProvider(create: (_) => ToggleBooleanBloc(initialValue: true)),
  BlocProvider(create: (_) => DescriptionBoolBloc()),
  BlocProvider(create: (_) => ChangeStringBloc("Events")),
  BlocProvider(create: (_) => PageIndexBloc(0)),
  BlocProvider(create: (_) => BoolBloc()..add(resetEvent())),
  BlocProvider(create: (_) => IndexBloc(0)),
];