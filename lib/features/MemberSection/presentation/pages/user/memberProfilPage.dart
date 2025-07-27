import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/member/MemberImpl.dart';

import '../../bloc/Members/members_bloc.dart';
import '../../widgets/notifications/NotificationDrawer.dart';

@RoutePage()
class MemberSectionPage extends StatefulWidget {
  final String id;

  const MemberSectionPage({Key? key, required this.id}) : super(key: key);

  @override
  State<MemberSectionPage> createState() => _MemberSectionPageState();
}

class _MemberSectionPageState extends State<MemberSectionPage> {
  late String _previousData;
  @override
  void reassemble() {
    super.reassemble();
    // This gets called during hot reload
    context.read<MembersBloc>().add(const GetUserProfileEvent(true));
  }

  @override
  void initState() {
    _previousData = widget.id;

    // TODO: implement initState
    super.initState();
  }

// Add this to your state class
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
    drawer: const NotificationsDrawer(),

      body: SafeArea(
        child:
        MemberImpl.memberWidget(widget.id,_scaffoldKey),

      ),


    );
  }
}
