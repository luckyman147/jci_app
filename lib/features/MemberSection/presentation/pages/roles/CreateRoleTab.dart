import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Role.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/widgets/loading_widget.dart';
import 'package:jci_app/core/util/snackbar_message.dart';
import 'package:jci_app/core/widgets/CommonTextField.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/permissions/features_cubit.dart';
import '../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/roles/role__bloc.dart';
import '../../../../../core/widgets/StandardTextFieldWidget.dart';
import '../../bloc/ rolesManagement/role_management__cubit.dart';

import '../../components/ObjectifField.dart';
import '../../components/buttonsComponents.dart';
import '../../widgets/role/RoleImplemtation.dart';

class CreateUpdateRolePage extends StatefulWidget {
  const CreateUpdateRolePage({super.key, this.role});
  final Role? role;

  /// Static method to show the page and initialize required data
  static void show(BuildContext context,{Role? role}) {
    context.read<FeaturesCubit>().fetchFeatures();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>  CreateUpdateRolePage(role: role,),
      ),
    );
  }

  @override
  State<CreateUpdateRolePage> createState() => _CreateRolePageState();
}

class _CreateRolePageState extends State<CreateUpdateRolePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _scrollController = ScrollController(); // Add this line
  @override
  void dispose() {
    _nameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  late String type;
  @override
  void initState() {
    if (widget.role!=null){

    type="Update";
      _nameController.text=widget.role!.roleName;
      context.read<RoleManagementCubit>().update(widget.role!.RoleCategory);
      context.read<FeaturesCubit>().FromRolePermissions(widget.role!.permissions);
    }else {
      type="Create";
    }
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        mini: true,
        backgroundColor: ColorsApp.ThirdColor,
        child: const Icon(Icons.arrow_upward, color: Colors.white),
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        },
      ),
      body: SafeArea(
        child: BlocListener<RoleBloc, RoleState>(
          listener: _handleRoleStateChanges,
          child: _buildPageContent(),
        ),
      ),
    );
  }

  /// Handles role creation/update state changes
  void _handleRoleStateChanges(BuildContext context, RoleState state) {
    if (state.status == RoleApiStatus.Created || state.status == RoleApiStatus.Updated) {
      _resetForm();
      SnackBarMessage.showSuccessSnackBar(
          message: "Role ${type}d Successfully",
          context: context
      );
      context.read<FeaturesCubit>().fetchFeatures();


      Navigator.pop(context);

    }
    else if (state .status==RoleApiStatus.Error) {
      _nameController.clear();
      SnackBarMessage.showErrorSnackBar(
          message: state.message??"Something went wrong",
          context: context
      );

    }
  }

  /// Resets all form fields and state
  void _resetForm() {
    _nameController.clear();
    context.read<RoleManagementCubit>().clear();
    context.read<FeaturesCubit>().clear_Features();
  }

  /// Builds the main page content
  Widget _buildPageContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            const SizedBox(height: 16),
            _buildFormSection(),
          ],
        ),
      ),
    );
  }

  /// Builds the header section with back button and title
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BackButton(onPressed: () => Navigator.pop(context)),
        Text(
          "$type Role",
          style: PoppinsSemiBold(17, ColorsApp.textColorBlack, TextDecoration.none),
        ),
        _buildSaveButton(),
      ],
    );
  }

  /// Builds the save button with loading state
  Widget _buildSaveButton() {
    return BlocSelector<RoleBloc, RoleState, bool>(
      selector: (state) => state.status == RoleApiStatus.Loading,
      builder: (context, isLoading) {
        return isLoading
            ? const LoadingWidget()
            : ButtonsMemberComponents.SaveChangesButton(
       (){
         if (!_submit()  ) {
           SnackBarMessage.showErrorSnackBar(
               message: "Please fill all required fields or Modify Permissions",
               context: context
           );

         }

       },
          context,
          MediaQuery.of(context).size.width / 3.5,
        );
      },
    );
  }

  /// Builds the form section
  Widget _buildFormSection() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRoleNameField(),
          const SizedBox(height: 16),
          _buildRoleCategoryField(),
          const SizedBox(height: 16),
          const HeaderFieldText(name: "Role Permissions"),
          const FeatureImplementations(),
        ],
      ),
    );
  }

  /// Builds the role name text field
  Widget _buildRoleNameField() {
    return TextfieldNormal(
      name: "Role Name",
      hintText: 'Enter role name here',
      controller: _nameController,
      onChanged: (_) {},
    );
  }

  /// Builds the role category dropdown
  Widget _buildRoleCategoryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: paddingSemetricHorizontal(),
          child: const HeaderFieldText(name: "Role Category"),
        ),
        BlocBuilder<RoleManagementCubit, CibleType?>(
          builder: (context, selectedCategory) {
            return DropDown<CibleType?>(
              selected: selectedCategory,
              options: CibleType.values,

              onChanged: (type) => context.read<RoleManagementCubit>().toggle(type!),
              validator: "Please select role category",
              isError: selectedCategory == null,
              borderColor: ColorsApp.ThirdColor,
            );
          },
        ),
      ],
    );
  }



  /// Validates and submits the form
  bool _submit() {
    final hasChanged = context.read<FeaturesCubit>().state.havePermissionsChanged();
    final hasCategory = context.read<RoleManagementCubit>().state != null;

    if (_formKey.currentState!.validate() && hasChanged && hasCategory) {
      final features = context.read<FeaturesCubit>().state.featuresModified;

      final role = Role(
        id: widget.role!=null?widget.role!.id:"",
        permissions: features.map((feat) => FeaturePermissions(
          featureId: feat.featureId,
          permissions: feat.permissions,
        )).toList(),
        RoleCategory: context.read<RoleManagementCubit>().state!,
        roleName: _nameController.text,
      );
if (widget.role==null) {
  context.read<RoleBloc>().add(CreateRoleEvent(role: role));
}else{
  context.read<RoleBloc>().add(UpdateRoleInfosEvent(role: role));

}
      return true;
    }
    return false;
  }
}