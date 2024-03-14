import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/DetailTeamWidget.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamImpl.dart';

import '../../../../core/strings/app_strings.dart';

class TeamDetailsScreen extends StatefulWidget {
  final String id;
  const TeamDetailsScreen({Key? key, required this.id}) : super(key: key);

  @override
  State<TeamDetailsScreen> createState() => _TeamDetailsScreenState();
}

class _TeamDetailsScreenState extends State<TeamDetailsScreen> {

  @override
  void initState() {
    context.read<GetTeamsBloc>().add(GetTeamById(widget.id));
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: PrimaryColor,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              onPressed: (){},
              child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add,color: textColorWhite, ),
                  Text("Add Task",style: PoppinsRegular(18, textColorWhite),)
                ],
              ) ),

          IconButton(onPressed: (){}, icon: Icon(Icons.calendar_today_outlined,color: PrimaryColor,)),
        ],
      ),

body: SafeArea(child: Column(

  children: [
    Header(context),
    Expanded(child: allTeams(widget.id)),
  ],
)),
    );
  }
}
