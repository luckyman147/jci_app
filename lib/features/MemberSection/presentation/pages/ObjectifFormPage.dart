import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/MemberSection/presentation/widgets/achivements/ObjectifForm.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../global-pres.dart';
import '../bloc/objectifs/ObjectifForm/objectif_form_cubit.dart';
import '../bloc/objectifs/objectif_bloc.dart';
import '../components/buttonsComponents.dart';

class Objectifformpage extends StatelessWidget {
  const Objectifformpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title:    Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

BackButton(onPressed: (){
  Navigator.pop(context);
  context.read<ObjectifFormCubit>().reset();

},),
            Padding(
              padding: paddingSemetricHorizontal(),
              child: Text("Create objectif",style:PoppinsRegular(18.sp, ColorsApp.textColorBlack) ,),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(child: ObjectifForm()),);
  }

}
