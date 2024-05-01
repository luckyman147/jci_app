
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/services/MemberStore.dart';

import 'package:jci_app/features/Home/presentation/bloc/Activity/BLOC/ActivityF/acivity_f_bloc.dart';
import 'package:jci_app/features/Home/presentation/bloc/Activity/activity_cubit.dart';


import '../../../../core/app_theme.dart';
import '../../../auth/data/models/Member/AuthModel.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';


import 'Compoenents.dart';

import 'HomeComp.dart';

class HomeWidget extends StatefulWidget {
  final activity Activity;

  const HomeWidget({Key? key, required this.Activity}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  void initState() {
    context.read<AcivityFBloc>().add(
        GetActivitiesOfMonthEvent(act: widget.Activity));


    super.initState();
  }


  Future<MemberModel?> _loadMemberModel() async {
    return await MemberStore.getModel();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        drawer:HomeComponents. buildDrawer(context,mediaQuery),
        appBar: AppBar(title:HomeComponents. buildHeader(mediaQuery),


          centerTitle: true,
          toolbarHeight: mediaQuery.size.height / 10,
          backgroundColor: backgroundColored,
          surfaceTintColor: backgroundColored,
          foregroundColor: textColorBlack,
          shadowColor: textColorWhite,


          actions: const [
            CalendarButton(color: BackWidgetColor,
              IconColor: textColorBlack,),
            SearchButton(color: BackWidgetColor,
              IconColor: textColorBlack,),
          ],
        ),
        body: BlocConsumer<ActivityCubit, ActivityState>(
          listener: (context, state) {},
          builder: (context, state) {
            return

              SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: mediaQuery.size.height / 33,
                        horizontal: mediaQuery.size.width / 20),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, ste) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [


                              HomeComponents.TeamsWidget(mediaQuery,context),
                              Padding(
                                padding: paddingSemetricVertical(v: 18),
                                child: MyActivityButtons(),
                              ),
                              buildBody(context, state.selectedActivity,
                                  mediaQuery)


                            ]

                        );
                      },
                    ),
                  ),
                ),
              );
          },
        ),
      ),
    );
  }



}
