import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/member/MemberImpl.dart';

import '../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/PermissionsBLoc/permissions_bloc.dart';
import '../../../../core/util/snackbar_message.dart';
import '../bloc/objectifs/objectif_bloc.dart';


class MemberSectionPage extends StatefulWidget {
  final String id;

  const MemberSectionPage({Key? key, required this.id}) : super(key: key);

  @override
  State<MemberSectionPage> createState() => _MemberSectionPageState();
}

class _MemberSectionPageState extends State<MemberSectionPage> {
  late String _previousData;

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
    return Scaffold(

      body: BlocListener<ObjectifBloc, ObjectifState>(
        listener: (context, state) {
          if (state.status == ObjectifStatus.Created) {
            SnackBarMessage.showSuccessSnackBar(message: "Objectif Creation succefully", context: context);


          }
          else if (state.status==ObjectifStatus.FailureCreation){
             SnackBarMessage.showErrorSnackBar(message: "Objectif Creation Failed", context: context);
          }
          // TODO: implement listener
        },
        child: SafeArea(
          child:
          MemberImpl.MemberWidget(widget.id),

        ),
      ),


    );
  }
}
