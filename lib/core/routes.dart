import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:jci_app/features/Home/presentation/pages/CreateUpdateActivityPage.dart';
import 'package:jci_app/features/Home/presentation/pages/detailsPage.dart';
import 'package:jci_app/features/Home/presentation/widgets/SearchWidget.dart';
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



import '../features/Teams/presentation/screens/CreateTeamScreen.dart';
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


),

    GoRoute(
path: '/search',
builder: (BuildContext context, GoRouterState state) {
return SearchPage();
},


),



GoRoute(
  name: 'CreateTeam',
path: '/CreateTeam',
builder: (BuildContext context, GoRouterState state) {
return CreatTeamScreen();
},


),
GoRoute(
  name: 'Task',
path: '/TaskDetails/:teamId/:TaskId',
builder: (BuildContext context, GoRouterState state) {
  final  teamId = state.pathParameters['teamId']! ;
  final  TaskId = state.pathParameters['TaskId']! ;
  return CreateTaskScreen(teamId: teamId, taskId: TaskId,);
},



),






    GoRoute(
path: '/pin/:email',
builder: (BuildContext context, GoRouterState state) {
  final  email = state.pathParameters['email']! ;

  return Pincode(email: email,);
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
path: '/TeamDetails/:id',
builder: (BuildContext context,  state) {
  final  id= state.pathParameters['id']! ;
return TeamDetailsScreen(id: id,);
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
        return SettingsPage();

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
    ),GoRoute(path: '/SignUp',
      builder: (BuildContext context, GoRouterState state)=>SignUpPage(),
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