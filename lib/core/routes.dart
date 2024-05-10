import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jci_app/features/Home/presentation/pages/CreateUpdateActivityPage.dart';
import 'package:jci_app/features/Home/presentation/pages/detailsPage.dart';
import 'package:jci_app/features/Home/presentation/widgets/SearchWidget.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/ModifyUser.dart';
import 'package:jci_app/features/MemberSection/presentation/pages/memberProfilPage.dart';
import 'package:jci_app/features/Teams/presentation/screens/DetailsTaskScreen.dart';
import 'package:jci_app/features/Teams/presentation/screens/TeamDeatailsScreen.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:jci_app/features/Home/presentation/pages/Home_page.dart';
import 'package:jci_app/features/auth/presentation/pages/Forget_password_page.dart';
import 'package:jci_app/features/auth/presentation/pages/ResetPasswordPage.dart';
import 'package:jci_app/features/auth/presentation/pages/login_pages.dart';
import 'package:jci_app/features/auth/presentation/pages/pinPage.dart';
import 'package:jci_app/features/changelanguages/presentation/pages/screen.dart';
import 'package:jci_app/features/intro/presentation/bloc/index_bloc.dart';



import '../features/MemberSection/presentation/pages/SettingsPage.dart';
import '../features/Teams/domain/entities/Team.dart';
import '../features/Teams/presentation/screens/CreateTeamScreen.dart';
import '../features/auth/data/models/Member/AuthModel.dart';
import '../features/auth/presentation/pages/SignUPPage.dart';
import '../features/intro/presentation/pages/Introduction.dart';
import '../features/intro/presentation/pages/Splash_screen.dart';


GoRouter router(navigatorKey,text)  => GoRouter(
  initialLocation: text ??'/',

  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return SplashScreen();
      },
    ),
GoRoute(
path: '/forget',
builder: (BuildContext context, GoRouterState state) {
return ForgetPasswordPage();
},


),GoRoute(
path: '/Settings',
builder: (BuildContext context, GoRouterState state) {
  final userJson = state.uri.queryParameters['user'];
  final user = MemberModel.fromJson(jsonDecode(userJson!));
return SettingsPage(member: user,);
},


),

    GoRoute(
path: '/search',
builder: (BuildContext context, GoRouterState state) {
return SearchPage();
},


),



GoRoute(
  name: 'CreateTeam/',
path: '/CreateTeam',
builder: (BuildContext context, GoRouterState state) {
  final userJson = state.uri.queryParameters['team'];

  final user = Team.fromJson(jsonDecode(userJson!));
return CreatTeamScreen(team: user);
},


),
GoRoute(
  name: 'Task',
path: '/TaskDetails/:teamId/:TaskId',
builder: (BuildContext context, GoRouterState state) {
  final  teamId = state.pathParameters['teamId']! as Team;
  final  TaskId = state.pathParameters['TaskId']! ;
  return CreateTaskScreen(team:teamId , taskId: TaskId,);
},



),







GoRoute(
path: '/memberSection/:id',
builder: (BuildContext context, GoRouterState state) {

  final  email = state.pathParameters['id']! ;


  return MemberSectionPage(id: email,);
},


),
GoRoute(path: "/activity/:id/:activity/:index",
  builder: (BuildContext context,  state) {
    final  id = state.pathParameters['id']! ;
    final  activity = state.pathParameters['activity']! ;
    final  index = state.pathParameters['index']! ;
    return ActivityDetailsPage( Activity: activity, id: id, index: int.parse(index),);
  },
),



GoRoute(
path: '/reset/:email',
builder: (BuildContext context,  state) {
  final  email = state.pathParameters['email']! ;
return ResetPassword(email: email,);
},
),
GoRoute(
path: '/modifyUser',
builder: (BuildContext context,  state) {
  final userJson = state.uri.queryParameters['user'];
  final user = MemberModel.fromJson(jsonDecode(userJson!));
  return ModifyUser(member: user,);
},
),
GoRoute(
path: '/TeamDetails/:id/:index',
builder: (BuildContext context,  state) {
  final  id= state.pathParameters['id']! ;
  final index= state.pathParameters['index']! ;
return TeamDetailsScreen(id: id, index: int.parse(index),);
},
),

GoRoute(
      path: '/Intro',
      builder: (BuildContext context, GoRouterState state) {
        return IntroductionPage();

      },
    ),GoRoute(
      path: '/screen',
      builder: (BuildContext context, GoRouterState state) {
        return LanguagePage();

      },
    ),
    GoRoute(path: '/home',
      builder: (BuildContext context, GoRouterState state)=>HomePage(),


    ),

    GoRoute(path: '/create/:id/:activity/:action/:part',
      builder: (BuildContext context, GoRouterState state){
        final  id = state.pathParameters['id']! ;
        final  activity = state.pathParameters['activity']! ;
        final  action = state.pathParameters['action']! ;
        final  partie = state.pathParameters['part']! ;
        debugPrint('partie $partie');
        return CreateUpdateActivityPage(id: id, activity: activity, work: action, part: decodeListFromUrlEncodedString(partie),);},
    ),


    GoRoute(path: '/login',
      builder: (BuildContext context, GoRouterState state)=>LoginPage(),
    ),GoRoute(path: '/SignUp/:email/:name',
      builder: (BuildContext context, GoRouterState state){
        final userJson = state.pathParameters['name'];
        final gmail = state.pathParameters['email'];
        return

SignUpPage(email: gmail!, name: userJson

      );}
    )


  ],
);List<String> decodeListFromUrlEncodedString(String input) {
  if (input =="[]") {
    return <String>[];
  }
  final urlEncodedList = Uri.decodeComponent(input);
  final list = urlEncodedList.isNotEmpty ? urlEncodedList.split(',') : <String>[];
  return list;
}