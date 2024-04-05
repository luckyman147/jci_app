import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/bools/change_sbools_cubit.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/MemberImpl.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';

import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

class MemberSectionPage extends StatefulWidget {

  const MemberSectionPage({Key? key}) : super(key: key);

  @override
  State<MemberSectionPage> createState() => _MemberSectionPageState();
}

class _MemberSectionPageState extends State<MemberSectionPage> {
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
            child:
                  MemberImpl.MemberWidget("id"),

              ),


    );
  }
}
