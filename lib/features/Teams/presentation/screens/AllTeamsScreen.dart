
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:jci_app/core/app_theme.dart';

import 'package:jci_app/features/Teams/presentation/bloc/GetTeam/get_teams_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TeamComponent.dart';

import 'package:jci_app/features/Teams/presentation/widgets/TeamImpl.dart';

import '../bloc/GetTasks/get_task_bloc.dart';



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
    context.read<GetTeamsBloc>().add(const GetTeams(isPrivate: false));
    context.read<TaskVisibleBloc>().add(const changePrivacyEvent(Privacy.Primary));


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
    if (_isBottom) context.read<GetTeamsBloc>().add(const GetTeams(isPrivate: false));
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return SafeArea(child: BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
  builder: (context, state) {
    return Column(
       children: [
      TeamComponent. Header(context, state, mediaquery),
 Padding(
  padding: paddingSemetricVerticalHorizontal(h: mediaquery.size.width/13),
  child: TeamComponent.Status(context, state),
)
,
           Expanded(

                   child:allTeams("",_scrollController,false) ,),

       ],

    );
  },
));
  }





}
