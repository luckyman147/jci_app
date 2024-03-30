import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';

import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
//import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamImpl.dart';

import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../Home/presentation/widgets/Compoenents.dart';
import '../../domain/entities/Team.dart';
import '../bloc/GetTasks/get_task_bloc.dart';
import '../widgets/funct.dart';


class AllTeamsScreen extends StatefulWidget {
  const AllTeamsScreen({Key? key}) : super(key: key);

  @override
  State<AllTeamsScreen> createState() => _AllTeamsScreenState();
}

class _AllTeamsScreenState extends State<AllTeamsScreen> {
  final _scrollController = ScrollController();
  @override
  void initState() {

     context.read<GetTaskBloc>().add(resetevent());
    context.read<GetTeamsBloc>().add(GetTeams(isPrivate: false));
    // context.read<TaskVisibleBloc>().add(changePrivacyEvent(Privacy.Primary));


     _scrollController.addListener(_onScroll);

    super.initState();
  }  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
  void _onScroll() {
    if (_isBottom) context.read<GetTeamsBloc>().add(GetTeams(isPrivate: false));
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return SafeArea(child: BlocConsumer<TaskVisibleBloc, TaskVisibleState>(
  builder: (context, state) {
    return Column(
       children: [
       Header(context, state, mediaquery),
 Padding(
  padding: paddingSemetricVerticalHorizontal(h: mediaquery.size.width/13),
  child: Status(context, state),
)
,
           Expanded(

                   child:allTeams("",_scrollController,false) ,),

       ],

    );
  }, listener: (BuildContext context, TaskVisibleState state) {

    },
));
  }



  Row Status(BuildContext context, TaskVisibleState state) {
    return Row(
  mainAxisAlignment: MainAxisAlignment.center,

  children: [


  StatusContainer((){
    context.read<TaskVisibleBloc>().add(changePrivacyEvent(Privacy.Primary));

    // Dispatch event to initialize GetTeamsBloc and fetch teams with updated privacy
    context.read<GetTeamsBloc>().add(initStatus());
    context.read<GetTeamsBloc>().add(GetTeams(isPrivate: false,isUpdated: state.isUpdated));
  },"Primary",state.privacy==Privacy.Primary,Privacy.Primary),
  SizedBox(width: 10,),
  StatusContainer((){
    context.read<TaskVisibleBloc>().add(changePrivacyEvent(Privacy.Private));

    // Dispatch event to initialize GetTeamsBloc and fetch teams with updated privacy
    context.read<GetTeamsBloc>().add(initStatus());
    context.read<GetTeamsBloc>().add(GetTeams(isPrivate: true,isUpdated: state.isUpdated));
    context.read<TaskVisibleBloc>().add(ChangeIsUpdatedEvent(false));

  },"Private",state.privacy==Privacy.Private,Privacy.Private),


],);
  }



  ElevatedButton StatusContainer(Function() onPressed, String text,bool isActive,Privacy privacy) {
    return ElevatedButton(
      style: styleFrom(isActive),
      onPressed: onPressed, child: Text(text,style:PoppinsRegular(16, isActive?textColorWhite:textColorBlack),),);
  }



  Row Header(BuildContext context, TaskVisibleState state, MediaQueryData mediaquery) {
    return Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           SizedBox(
             height: 50,

             child: SeachRow(context, state, mediaquery),
           ),
           SecondRowPart(state, context),

         ],
       );
  }

  Row SecondRowPart(TaskVisibleState state, BuildContext context) {
    return Row(
             children: [
               state.willSearch==false?
              IconButton(onPressed: () {
                context.read<TaskVisibleBloc>().add(ChangeWillSearchEvent(true));
              }, icon: Icon(Icons.search,color: textColorBlack,)):

               IconButton(onPressed: (){
                 context.read<TaskVisibleBloc>().add(ChangeWillSearchEvent(false));
                 context.read<GetTeamsBloc>().add(GetTeams(isPrivate: state.privacy==Privacy.Private));

               }, icon: Icon(Icons.cancel,color: textColorBlack,),),
               AddButton(color: PrimaryColor, IconColor: textColorBlack, icon: Icons.add_rounded,
                   onPressed: () {
final team=jsonEncode(Team.empty().toJson());
context.go('/CreateTeam?team=${team}');
               }),


             ],
           );
  }

  Row SeachRow(BuildContext context, TaskVisibleState state, MediaQueryData mediaquery) {
    return Row(
               children: [
                 BackButton(
                     onPressed: () {
                       context.read<PageIndexBloc>().add(SetIndexEvent(index: 0));
                     }
                 ),
                 state.willSearch==false?
                 Text("Teams ",style:PoppinsSemiBold(21, textColorBlack, TextDecoration.none)):
                     SizedBox(
                        width: mediaquery.size.width*0.6,
                       height: 50,
                       child: TextField(
                         style: PoppinsRegular(16, textColorBlack) ,
                         decoration: InputDecoration(
                           hintText: "Search Teams",
                           hintStyle: PoppinsRegular(16, textColor),
                           border: InputBorder.none,
                         ),
                         onChanged: (value) {
searchFunction(value, context,state.privacy==Privacy.Private);

                         }),
                     ),
               ],
             );
  }


}
