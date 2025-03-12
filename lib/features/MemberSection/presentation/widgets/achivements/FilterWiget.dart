import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/app.dart';

import '../../../../Home/Activity_Global.dart';
import '../../../domain/entity/Objectif.dart';
import '../../components/ObjectifField.dart';
import '../../components/buttonsComponents.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Filter Options",
              style: PoppinBold(20.sp, ColorsApp.textColorBlack, TextDecoration.none),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 1.5,
              child: DropDown<FeaturesType?>(
                selected: null,
                options: FeaturesType.values,
                onChanged: (value) {},
                validator: 'Type',
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width / 2,
              child: DropDown<ObjectifDifficulty?>(
                selected: null,
                options: ObjectifDifficulty.values,
                onChanged: (value) {},
                validator: "Difficulty",
              ),
            ),
            SizedBox(height: 16),
            ButtonsMemberComponents.SaveChangesButton((){
              Navigator.pop(context);


            }, context)
          ],
        ),
      ),
    );

  }
}
