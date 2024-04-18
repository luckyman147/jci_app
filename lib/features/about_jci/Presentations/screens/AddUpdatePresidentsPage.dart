import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/about_jci/Domain/entities/President.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/ActionJci/action_jci_cubit.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/presidents_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/Fubnctions.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/PresWidgets.dart';

import '../../../../core/util/snackbar_message.dart';
import '../../../Home/presentation/widgets/AddActivityWidgets.dart';
import '../../../MemberSection/presentation/widgets/ProfileComponents.dart';

class AddUpdatePage extends StatefulWidget {
  final President? president;
  final PresidentsAction action;
  const AddUpdatePage({Key? key, this.president, required this.action}) : super(key: key);

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}


class _AddUpdatePageState extends State<AddUpdatePage> {
final TextEditingController name= TextEditingController();
final TextEditingController year= TextEditingController();
final ScrollController controller = ScrollController();
  final _formKey = GlobalKey<FormState>();

@override
  void initState() {
  if (widget.president != null) {
      name.text = widget.president!.name;
      year.text = widget.president!.year;
      context.read<ActionJciCubit>().changeYear(widget.president!.year);

  }

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {

  name.dispose();
  year.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.black,onPressed: (){
          context.read<TaskVisibleBloc>().add(ChangeImageEvent(""));
          context.read<ActionJciCubit>().changeYear("");

          Navigator.pop(context);
        },),
        title:  Text(widget.action == PresidentsAction.Add ? 'Add President' : 'Update President'),
      ),
      body: SafeArea(child: SingleChildScrollView(
        child: BlocBuilder<TaskVisibleBloc, TaskVisibleState>(
  builder: (context, state) {
    return BlocListener<PresidentsBloc, PresidentsState>(
  listener: (context, state) {
  JCIFunctions.  ListenerIsAdded(state, context);
    // TODO: implement listener
  },
  child: BlocBuilder< ActionJciCubit, ActionJciState>(
  builder: (context, ste) {
    return Form(
      key: _formKey,
      child: Column(
            children: [

              ProfileComponents.imagezChanged(state.image,MediaQuery.of(context),context),
              TextfieldNormal(context,"President Name", "Enter Presidents  name",name,(poo){}),
              TextfieldNormal(context,"Year ", "Enter Year",year,(poo){}),
      //add Select Year
          //  PresWidgets.yearForm(ste.year, context, mounted, controller),
              ProfileComponents.SaveChangesButton((){
         JCIFunctions.       update( state, context,name,widget.president,widget.action,_formKey,year);
              }),
            ],
          ),
    );
  },
),
);
  },
),
      ),)
    );
  }




}
