import 'package:flutter/material.dart';
import 'package:jci_app/core/app_theme.dart';

import '../widgets/PresidentsImpl.dart';

class PresidentsPage extends StatefulWidget {
  const PresidentsPage({Key? key}) : super(key: key);

  @override
  State<PresidentsPage> createState() => _PresidentsPageState();
}

class _PresidentsPageState extends State<PresidentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Past Presidents',style: PoppinsSemiBold(18, textColorBlack, TextDecoration.none),),
      ),
      body: SafeArea(child:





        PresidentsImpl.GetAllPresidents()
        ,)

    );
  }
}
