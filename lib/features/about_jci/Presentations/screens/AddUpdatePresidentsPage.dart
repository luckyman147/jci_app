
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/app_theme.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import 'package:jci_app/features/Teams/presentation/bloc/TaskIsVisible/task_visible_bloc.dart';
import 'package:jci_app/features/about_jci/Domain/entities/President.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/ActionJci/action_jci_cubit.dart';
import 'package:jci_app/features/about_jci/Presentations/bloc/presidents_bloc.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/BoardComponents.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/Fubnctions.dart';
import 'package:jci_app/features/about_jci/Presentations/widgets/dialogs.dart';

import '../../../Home/presentation/widgets/AddActivityWidgets.dart';

class AddUpdatePage extends StatefulWidget {
  final President? president;
  final PresidentsAction action;
  const AddUpdatePage({Key? key, this.president, required this.action}) : super(key: key);

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}


class _AddUpdatePageState extends State<AddUpdatePage> {
final TextEditingController name= TextEditingController();

final ScrollController controller = ScrollController();
  final _formKey = GlobalKey<FormState>();

@override
  void initState() {
  if (widget.president != null) {
      name.text = widget.president!.name;

      context.read<ActionJciCubit>().changeYear(widget.president!.year);

  }

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {

  name.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
              Row(
                children: [
                  BackButton(color: Colors.black,onPressed: (){
                    context.read<TaskVisibleBloc>().add(const ChangeImageEvent(""));
                    context.read<ActionJciCubit>().changeYear("");

                    Navigator.pop(context);
                  },),
                  Text(widget.action == PresidentsAction.Add ? '${"Add".tr(context)} ${"President".tr(context)}' : '${"Update".tr(context)} ${"President".tr(context)}',style: PoppinsRegular(18, textColorBlack),),
                ],
              ),

          //    ProfileComponents.imagezChanged(state.image,MediaQuery.of(context),context),
              TextfieldNormal(context,"${"President".tr(context)} ${"Name".tr(context)}", "${"Enter".tr(context)} ${"Presidents".tr(context)}  ${"Name".tr(context)}",name,(poo){}),
             buildAddyear(context, ste),
      //add Select Year
          //  PresWidgets.yearForm(ste.year, context, mounted, controller),
             Padding(
               padding: paddingSemetricVerticalHorizontal(h: 18),
               child: SizedBox(
                 height: 50,
                 width: MediaQuery.of(context).size.width * 1,
                 child: BoardComponents.ButtomActin(context, () =>          JCIFunctions.       update( state, context,name,widget.president,widget.action,_formKey,ste)
                     , "Save Changes".tr(context), PrimaryColor, textColorWhite, true),
               ),
             )
            ],
          ),
    );
      },
    ),
    );
      },
    ),
      );

  }

  InkWell buildAddyear(BuildContext context, ActionJciState ste) {
    return InkWell(
              onTap: (){
                Dialogs.showYearPresidentsSelectionDialog(context,);
              },
              child: Padding(
                padding: paddingSemetricHorizontal(h: 18, ),
                child: Container(
                height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: PrimaryColor,width: 3)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ste.year == "" ? "Select Year".tr(context) : ste.year,
                          textAlign: TextAlign.center,
                          style: PoppinsNorml(17, ste.year.isNotEmpty?textColorBlack:ThirdColor),),

                      ],
                    ),
                  ),
                ),
              ),
           );
  }




}
