import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/SettingsComponents.dart';
import 'package:jci_app/features/changelanguages/presentation/bloc/locale_cubit.dart';

import '../../../Home/presentation/bloc/PageIndex/page_index_bloc.dart';
import '../../../auth/domain/entities/Member.dart';
import '../bloc/Members/members_bloc.dart';

class SettingsPage extends StatefulWidget {
  final Member member;
  const SettingsPage({Key? key, required this.member}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    context.read<localeCubit>().getSavedLanguage();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
          title:
          BackButton(
            onPressed: () {
              GoRouter.of(context).go('/home');


            },


          ),

      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: paddingSemetricVerticalHorizontal(),
              child: Text("Settings",style: PoppinsSemiBold(24, textColorBlack, TextDecoration.none),),
            ),
SettingsComponent.ColumnActions(context,widget.member),
          ],
        ),
      ),
    );
  }
}
