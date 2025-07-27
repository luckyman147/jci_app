import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jci_app/features/Home/presentation/pages/CreateUpdateActivityPage.dart';
import 'package:jci_app/features/Home/presentation/pages/detailsPage.dart';
import 'package:jci_app/features/Home/presentation/widgets/components/search/SearchWidget.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/user/ModifyUser.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/user/memberProfilPage.dart';
import 'package:jci_app/features/Teams/presentation/screens/DetailsTaskScreen.dart';
import 'package:jci_app/features/Teams/presentation/screens/TeamDeatailsScreen.dart';
import 'package:jci_app/features/Home/presentation/pages/Home_page.dart';
import 'package:jci_app/features/auth/presentation/pages/Forget_password_page.dart';
import 'package:jci_app/features/auth/presentation/pages/ResetPasswordPage.dart';
import 'package:jci_app/features/auth/presentation/pages/login_pages.dart';
import 'package:jci_app/features/changelanguages/presentation/pages/screen.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/user/SettingsPage.dart';
import 'package:jci_app/features/Teams/presentation/screens/CreateTeamScreen.dart';
import 'package:jci_app/features/auth/presentation/pages/InfoPage.dart';
import 'package:jci_app/features/auth/presentation/pages/SignUPPage.dart';
import 'package:jci_app/features/intro/presentation/pages/Introduction.dart';
import 'package:jci_app/features/intro/presentation/pages/Splash_screen.dart';

import 'package:jci_app/features/Teams/domain/entities/Team/Team.dart';

import '../../features/MemberSection/domain/entity/Objectif.dart';
import '../../features/MemberSection/presentation/bloc/memberBloc/member_management_bloc.dart';
import '../../features/MemberSection/presentation/bloc/objectifs/objectif_bloc.dart';
import '../../features/MemberSection/presentation/pages/objectif/ObjectifFormPage.dart';
import '../../features/MemberSection/presentation/pages/objectif/ObjectifPage.dart';
import '../../features/auth/AuthWidgetGlobal.dart';
import '../Member.dart';
import 'RedirectGuard.dart';
import 'StatusGuard.dart';



part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen|Page,Route')
class AppRouter extends RootStackRouter {
  AppRouter(this.statusGuard);
  final lastRouteGuard = LastRouteRedirectGuard();
  final StatusGuard statusGuard;

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true,guards: [statusGuard]
    ),
    AutoRoute(page: ObjectifformpageRoute.page),
    AutoRoute(page: ObjectifsRoute.page),

    AutoRoute(page: ForgetPasswordRoute.page),
    AutoRoute(page: PasswordResetSentRoute.page),
    AutoRoute(page: SettingsRoute.page),
    AutoRoute(page: SearchRoute.page),
 //   AutoRoute(page: CreateTeamRoute.page),
    AutoRoute(page: CreateTaskRoute.page),
    AutoRoute(page: MemberSectionRoute.page),
    AutoRoute(page: ActivityDetailsRoute.page,
      path: '/activity/:id/:activity/:index',
    ),

    AutoRoute(page: ResetPasswordRoute.page),
    AutoRoute(page: CreateTeamRoute.page,
    ),
    AutoRoute(page: ModifyUserRoute.page),
    AutoRoute(page: TeamDetailsRoute.page),
    AutoRoute(page: IntroductionRoute.page,guards:  [lastRouteGuard]),
    AutoRoute(page: LanguageRoute.page),
    AutoRoute(
      page: HomeRoute.page,
    //  guards: [authGuard], // 🚨 GUARD
    ),
    AutoRoute(page: CreateUpdateActivityRoute.page),
    AutoRoute(page: LoginRoute.page,guards: [lastRouteGuard]),
    AutoRoute(page: SignUpRoute.page,guards: [lastRouteGuard]),
  ];
}
