import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/core/util/DialogWidget.dart';
import 'package:jci_app/features/MemberSection/presentation/bloc/Members/members_bloc.dart';
import 'package:jci_app/features/MemberSection/presentation/components/ProfileComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/components/TextFieldsComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/components/buttonsComponents.dart';
import 'package:jci_app/features/MemberSection/presentation/functions/functionMember.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/core/Member.dart';

import '../../../../../core/util/snackbar_message.dart';
import '../../../../../core/widgets/CommonTextField.dart';
import '../../../../Home/presentation/widgets/Activity/AddActivityWidgets.dart';
import '../../components/AboutMemberComponent.dart';

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
  showDialog(context: context, builder: (context) =>  LoadingDialog());
}
     if(state .userStatus==UserStatus.Updated){
      SnackBarMessage.showSuccessSnackBar(message: "Updated Succefully", context: context);

      context.go('/home');
      context.read<MembersBloc>().add(const GetUserProfileEvent(true));
    }
    else if(state.userStatus ==UserStatus.Error){
      SnackBarMessage.showErrorSnackBar(message: state.Errormessage, context: context);

    }

  },
  child: Form(
    key:_formKey ,
    child: Column(
            children: [

              AboutMemberComponent.imagezChanged(state.images[0],med,context)
    ,
              TextfieldNormal(name: "First Name".tr(context),
                 hintText:  "Enter First Name".tr(context),
controller:                   firstNameController,
                  onChanged: (poo){}),
              TextfieldNormal(name: "Last Name".tr(context),
                 hintText:  "Enter Last Name". tr(context),
                 controller:  lastNameController,onChanged: (poo){}),
              TextfieldDescription( name: "My Bio".tr(context),
                 hintText:  "Enter A Bio".tr(context),
                controller:   descriptionController,onChanged:  (p0) => null),
              TextFieldComponets.TextfieldNum("Phone Number".tr(context), "Enter  Phone Number".tr(context),NumberController,(poo){},context),
              ButtonsMemberComponents.SaveChangesButton(()async{  FunctionMember.saveMember(  widget.member,firstNameController,lastNameController,NumberController,
                  state.images[0],context,_formKey,descriptionController);},context,200.sp),
          ]),
  ),
);
  },
),
      )
    );
  }

  

}
