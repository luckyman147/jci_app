import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/features_cubit.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/roles/role__bloc.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Notifications/notification_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberPermissions/member_permission_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/ObjectifUserProgress/user_objectif_progress_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/ObjectifForm/objectif_form_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/objectifs/objectif_bloc.dart';
import 'package:jci_app/injection_container.dart' as di;

import '../../../../features/MemberSection/presentation/bloc/ rolesManagement/role_management__cubit.dart';

List<SingleChildWidget> memberProviders = [
  BlocProvider(create: (_) => di.sll<MembersBloc>()),
  BlocProvider(create: (_) => di.sll<UserObjectifProgressCubit>()),
  BlocProvider(create: (_) => di.sll<ChangeSboolsCubit>()),
  BlocProvider(create: (_) => di.sll<NotificationBloc>()),
  BlocProvider(create: (_) => di.sll<MemberManagementBloc>()),
  BlocProvider(create: (_) => di.sll<MemberPermissionBloc>()),
  BlocProvider(create: (_) => ObjectifFormCubit()),
  BlocProvider(create: (_) => di.sll<ObjectifBloc>()),
  BlocProvider(create: (_) => di.sll<RoleBloc>()),
  BlocProvider(create: (_) => di.sll<FeaturesCubit>()),
  BlocProvider(create: (_) => RoleManagementCubit()),

];