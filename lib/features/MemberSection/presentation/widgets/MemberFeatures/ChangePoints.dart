
import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/permissions_bloc.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/functions/PermissionFunctions.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../../core/config/env/Constants.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../../intro/presentation/widgets.global.dart';
import '../../bloc/bools/change_sbools_cubit.dart';
import '../../bloc/memberBloc/member_management_bloc.dart';
import '../../functions/functionMember.dart';

class ChangePoints extends StatelessWidget {
  final MediaQueryData mediaQuery;
  final MemberManagementState state;


  final String id;

  const ChangePoints({
    super.key,
    required this.mediaQuery,
    required this.state,


    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Points adjustment section (now takes 60% width)
        _buildPointsAdjustmentSection(context),
        const SizedBox(height: 12), // Increased spacing
        // Save button section
        _buildSaveButtonSection(context),
      ],
    );
  }

  Widget _buildPointsAdjustmentSection(BuildContext context) {
    return SizedBox(
      height: 59,
      width: mediaQuery.size.width * 0.6, // Increased from 0.5 to 0.6
      child: BlocBuilder<ChangeSboolsCubit, ChangeSboolsState>(
        builder: (context, ste) {
          return Row(
            children: [
              _buildIconButton(
                icon: Icons.remove,
                onTap: () => context.read<MemberManagementBloc>().add(const RemovePoints()),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    state.clone.toInt().toString(),
                    style: PoppinsRegular(19, Colors.black),
                  ),
                ),
              ),
              _buildIconButton(
                icon: Icons.add,
                onTap: () => context.read<MemberManagementBloc>().add(const AddPoints()),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.black, size: 30),
        ),
      ),
    );
  }

  Widget _buildSaveButtonSection(BuildContext context) {
    return BlocSelector<MemberManagementBloc, MemberManagementState, bool>(
      selector: (state) => state.typeResult == TypeResult.Loading,
      builder: (context, isLoading) {
        if (isLoading) return const LoadingWidget();

        final hasPermission = _checkPermissions(context);
        final shouldEnable = hasPermission && state.clone != state.points;

        return _buildSaveButton(shouldEnable, context);
      },
    );
  }

  bool _checkPermissions(BuildContext context) {
    final state = context.read<PermissionsBloc>().state;
    return PermissionsFunctions.HasPermission(
        state,
        Constants.MANAGE_POINTS,
        PermissionType.canUpdate
    );
  }

  Widget _buildSaveButton(bool enabled, BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? () => FunctionMember.savePoints(id, state.clone, context) : null,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 50,
          width: mediaQuery.size.width , // Give button more space
          decoration: BoxDecoration(
            color: enabled ? SecondaryColor : ColorsApp.ThirdColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              "Save".tr(context),
              style: PoppinsRegular(18, Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
