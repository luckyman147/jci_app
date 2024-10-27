

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/memberPermissions/member_permission_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/MemberImpl.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';

import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

class MemberSectionPage extends StatefulWidget {
final String id;
  const MemberSectionPage({Key? key, required this.id}) : super(key: key);

  @override
  State<MemberSectionPage> createState() => _MemberSectionPageState();
}

class _MemberSectionPageState extends State<MemberSectionPage> {
 late String _previousData ;
  @override
  void initState() {


    _previousData = widget.id;
    // TODO: implement initState
    super.initState();
  }
  @override
  void didUpdateWidget(covariant MemberSectionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.id != widget.id) {
      _previousData = oldWidget.id;
    }
  }

  @override
  bool shouldRebuild(MemberSectionPage oldWidget) {
    return oldWidget.id != _previousData;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(

      body: SafeArea(
            child:
                  MemberImpl.MemberWidget(widget.id),

              ),


    );
  }
}
