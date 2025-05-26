import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/features_cubit.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/roles/role__bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/role/RoleImplemtation.dart';

import '../../../../../core/Member.dart';
import '../../../../../core/config/env/Constants.dart';
import '../../../global-pres.dart';
import '../../components/buttonsComponents.dart';
import '../../functions/functionMember.dart';
import 'CreateRoleTab.dart';

class RolePage extends StatefulWidget {
  const RolePage({super.key, required this.member});

  final Member member;

  // Helper method that can be called statically
  static void show(BuildContext context, Member member) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RolePage(member: member),
      ),
    );
  }

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  @override

  void initState() {
    context.read<RoleBloc>().add(FetchRolesEvent());

    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Role Management'),

      ),
      body:
      BlocListener<RoleBloc, RoleState>(
        listener: (context, state) {

          if (state.status==RoleApiStatus.Changed){
          if(  Navigator.canPop(context)) {
            Navigator.pop(context);
          }
            FunctionMember.IfCurrentOwner(context, widget.member.id??"");
          }
          // TODO: implement listener
        },
        child: Column(

          children: [

            ButtonsMemberComponents.buildCreateObjectif(() {
              CreateUpdateRolePage.show(context);
            },
                "Create Role", Constants.MANAGE_MEMBERS
            ),
            Expanded(child: RoleImpl(
              roleName: widget.member.roleName, MemberId: widget.member.id!,)),

          ],
        ),
      ),
    );
  }
}

