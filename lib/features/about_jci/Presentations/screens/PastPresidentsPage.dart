import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/widgets/TaskComponents.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/ActionJci/action_jci_cubit.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/presidents_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/screens/AddUpdatePresidentsPage.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/Fubnctions.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/dialogs.dart';

import '../widgets/PresidentsImpl.dart';

class PresidentsPage extends StatefulWidget {
  const PresidentsPage({Key? key}) : super(key: key);

  @override
  State<PresidentsPage> createState() => _PresidentsPageState();
}

class _PresidentsPageState extends State<PresidentsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }
  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<PresidentsBloc>().add(GetAllPresidentsEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Past Presidents',style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none),),
            ProfileComponents.buildFutureBuilder(buildAddButton(() {

Dialogs.ShoUpdateAddPresident(context, null, PresidentsAction.Add);
            }), true, "", (p0) => FunctionMember.isSuper())
          ],
        ),
      ),
      body: SafeArea(child:





        PresidentsImpl.GetAllPresidents(_scrollController,mounted)
        ,)

    );
  }
}
