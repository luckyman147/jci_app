import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/util/DialogWidget.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/auth/domain/entities/Member.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../Home/presentation/widgets/AddActivityWidgets.dart';
import '../../../Home/presentation/widgets/Functions.dart';

class ModifyUser extends StatefulWidget {
  final Member member;
  const ModifyUser({Key? key, required this.member}) : super(key: key);

  @override
  State<ModifyUser> createState() => _ModifyUserState();
}

class _ModifyUserState extends State<ModifyUser> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController NumberController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    NumberController.dispose();
    descriptionController.dispose();
    _formKey.currentState?.dispose();
    // TODO: implement dispose
    super.dispose();
  }
 @override
  void initState() {

   firstNameController.text = widget.member.firstName;
    lastNameController.text = widget.member.lastName;
    NumberController.text = widget.member.phone;
    descriptionController.text = widget.member.description;

    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final med = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            BackButton(
              onPressed: () {
               context.go('/home');
              },
            ),
            Text(
              "${"Edit".tr(context)} Profile",
              style: PoppinsSemiBold(22, textColorBlack, TextDecoration.none),
            ),
          ],
        ),
      ),
      body:SingleChildScrollView(
        child: BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
  builder: (context, state) {
    return BlocListener<MembersBloc,MembersState>(
  listener: (context, state) {
if (state.userStatus == UserStatus.Loading) {
  showDialog(context: context, builder: (context) => LoadingDialog());
}
     if(state .userStatus==UserStatus.Updated){
      SnackBarMessage.showSuccessSnackBar(message: "Updated Succefully", context: context);

      context.go('/home');
      context.read<MembersBloc>().add(GetUserProfileEvent(true));
    }
    else if(state.userStatus ==UserStatus.Error){
      SnackBarMessage.showErrorSnackBar(message: state.Errormessage, context: context);

    }

  },
  child: Form(
    key:_formKey ,
    child: Column(
            children: [

       ProfileComponents.imagezChanged(state.image,med,context)
    ,
              TextfieldNormal(context,"First Name".tr(context), "Enter First Name".tr(context),firstNameController,(poo){}),
              TextfieldNormal(context,"Last Name".tr(context), "Enter Last Name". tr(context),lastNameController,(poo){}),
              TextfieldDescription(context, "My Bio".tr(context), "Enter A Bio".tr(context), descriptionController, (p0) => null),
              ProfileComponents.TextfieldNum("Phone Number".tr(context), "Enter  Phone Number".tr(context),NumberController,(poo){}),
              ProfileComponents.SaveChangesButton(()async{  FunctionMember.saveMember(  widget.member,firstNameController,lastNameController,NumberController,
                  state.image,context,_formKey,descriptionController);},context),
          ]),
  ),
);
  },
),
      )
    );
  }

  

}
