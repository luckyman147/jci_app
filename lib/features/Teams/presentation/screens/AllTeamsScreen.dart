import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/widgets/backbutton.dart';
import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamImpl.dart';

import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../Home/presentation/widgets/Compoenents.dart';
import '../widgets/CreateTeamWIdgets.dart';

class AllTeamsScreen extends StatefulWidget {
  const AllTeamsScreen({Key? key}) : super(key: key);

  @override
  State<AllTeamsScreen> createState() => _AllTeamsScreenState();
}

class _AllTeamsScreenState extends State<AllTeamsScreen> {
  @override
  void initState() {
    context.read<GetTeamsBloc>().add(GetTeams());
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return SafeArea(child: Column(
       children: [
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Row(
               children: [
                 BackButton(
                     onPressed: () {
                       context.read<PageIndexBloc>().add(SetIndexEvent(index: 0));
                     }
                 ),
                 Text("Teams ",style:PoppinsSemiBold(21, textColorBlack, TextDecoration.none)),
               ],
             ),
             Row(
               children: [
                 const SearchButton(
                 color: PrimaryColor, IconColor: textColorBlack,),
                 AddButton(color: PrimaryColor, IconColor: textColorBlack, icon: Icons.add_rounded, onPressed: () {
context.go('/CreateTeam');
                 }),


               ],
             ),

           ],
         ),



           Expanded(

            child:allTeams("") ,),

       ],

    ));
  }
}
