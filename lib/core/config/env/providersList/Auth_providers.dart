import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/Permissions/permissions_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/ResetPassword/reset_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/SignUp/sign_up_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/INPUTS/inputs_cubit.dart';
import 'package:jci_app/features/auth/presentation/bloc/bool/toggle_bool_bloc.dart';
import 'package:jci_app/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:jci_app/injection_container.dart' as di;
import 'package:provider/single_child_widget.dart';

import '../../../BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';

List<SingleChildWidget> authProviders = [
  BlocProvider(create: (_) => di.sl<ResetBloc>()),
  BlocProvider(
      create: (_) => di.sl<AuthBloc>()..add(const IsLoggedInEvent())),
  BlocProvider(create: (_) => di.sl<SignUpBloc>()),
  BlocProvider(create: (_) => di.sl<LoginBloc>()..add(const HandleUserEmail())),
  BlocProvider(create: (_) => InputsCubit()..resetInputs()),
  BlocProvider(create: (_) => ToggleBooleanBloc()),
  BlocProvider(create: (_) => di.sl<PermissionsBloc>()),
  BlocProvider(create: (_) => di.sl<PermissionsMemberBloc>()),
];