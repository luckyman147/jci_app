
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/config/env/Constants.dart';
import 'package:jci_app/features/Home/domain/enums/Privacy.dart';
import 'package:jci_app/features/Home/presentation/widgets/Activity/AddActivityWidgets.dart';
import 'package:jci_app/features/Home/presentation/widgets/Fields/meetLinkTextField.dart';
import 'package:jci_app/features/Home/presentation/widgets/buttons/ButtonsComponent.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../core/widgets/CommonTextField.dart';
import '../../../Activity_Global.dart';
import '../../../domain/entities/Activitys/Place.dart';
import '../../bloc/Activity/BLOC/Places/place__cubit.dart';
import 'PlaceSeachBottomSheet.dart';

class LocationVisibility extends StatelessWidget {
  const LocationVisibility({
    super.key,
    required TextEditingController LocationController,
  }) : _LocationController = LocationController;

  final TextEditingController _LocationController;

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<VisibleBloc, VisibleState>(
      builder: (context, state) {
        return Column(
          children: [
            StatusButton(Status:        state.IsOnline, onPressed: (){
              context.read<VisibleBloc>().add(ChangeOnline( !state.IsOnline));
            }, isOn: Icons.online_prediction, isOff: Icons.place, textOn: "Online", textOff: "Local", colorOn: PrimaryColor, labelText: "Is Online")
            ,Visibility( visible:!state.IsOnline,


              child: TextfieldNormal(name: "Location",


                  hintText: "Location Here".tr(context), controller: _LocationController,
                  onChanged: (value){ }), ),

            Visibility(
              visible:state.IsOnline,
              child: TextFieldWithIcons(controller: _LocationController),
            ),
          ],
        );
      },
    );
  }
}

BlocBuilder<VisibleBloc, VisibleState> PrivacyWidget() {
  return BlocBuilder<VisibleBloc, VisibleState>(
    builder: (context, state) {
      return Padding(
        padding:paddingSemetricVertical(),
        child: Column(
          children: [
            StatusButton(Status: state.isPrivate, onPressed: (){
              context.read<VisibleBloc>().add(ChangePrivacy( !state.isPrivate));
            }, isOn: FontAwesomeIcons.lock, isOff: FontAwesomeIcons.globe, textOn: "Private", textOff: "Public", colorOn: Colors.red, labelText: "Privacy"),
            Visibility(
                visible: state.isPrivate,
                child: AddWidgetComponents.SelectMembers("Participants", UserChoice.MULTIPLE)),    ],
        ),
      );
    },
  );
}
