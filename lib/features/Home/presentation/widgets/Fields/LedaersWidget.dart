

import 'package:jci_app/features/Home/presentation/widgets/Activity/AddActivityWidgets.dart';

import '../../../../../core/widgets/CommonTextField.dart';
import '../../../Activity_Global.dart';

class NameAndLeaders extends StatelessWidget {
  const NameAndLeaders({
    super.key,
    required TextEditingController namecontroller,
    required TextEditingController ProfesseurName,
    required this.vis,
  }) : _namecontroller = namecontroller, _ProfesseurName = ProfesseurName;

  final TextEditingController _namecontroller;
  final TextEditingController _ProfesseurName;

  final ActivityState vis;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        TextfieldNormal(
            name: "${vis.selectedActivity.name.tr(context)} ${"Name".tr(context)}" ,
           hintText:  "${"Name of".tr(context)} ${vis.selectedActivity.name.tr(context)} ${"here".tr(context)}",
            controller:  _namecontroller,

onChanged:                 (value){
              context.read<FormzBloc>().add(ActivityNameChanged(activityName: value));
            }
        ),
        AddWidgetComponents.      showLeader(vis.selectedActivity,mediaQuery,context,_ProfesseurName),
      ],
    );
  }
}