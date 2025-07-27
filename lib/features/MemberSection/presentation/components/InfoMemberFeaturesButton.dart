import 'package:flutter_animate/flutter_animate.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/Data/DataSources/RemotePermissionsDataSources.dart';

import '../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import '../../../../core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';
import '../../../../core/app_theme.dart';
import '../../global-pres.dart';
import '../constants/decoration.dart';
import 'AboutMemberComponent.dart';

class InfoButtonMember extends StatelessWidget {
  final String header;
  final IconData icon;
  final VoidCallback onClick;
  final PermissionType type;
  final String featureId;

  const InfoButtonMember({
    Key? key,
    required this.header,
    required this.onClick,
    required this.icon,
    required this.type,
    required this.featureId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: paddingSemetricVertical(),
      child: AsyncComponents.buildFutureBuilder(
        InkWell(
          onTap: onClick,
          child: Container(

            width: MediaQuery.of(context).size.width ,
           // constraints: BoxConstraints(minHeight: 500, maxHeight: 800), // Prevents overflow
            decoration: AboutMemberComponent.profilbox(),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisSize: MainAxisSize.min, // Let content define height
                mainAxisAlignment: MainAxisAlignment.start, // Center the content
                children: [
                  Icon(icon, size: 30), // Adjust icon size
                  SizedBox(width: 8), // Add spacing
                  Text(
                    header,
                    textAlign: TextAlign.center, // Align text
                    style: PoppinsSemiBold(17, textColorBlack, TextDecoration.none),
                  ),
                ],
              ),
            ),
          ),
        ).animate(
          effects: [const FadeEffect(
            duration: Duration(milliseconds: 788)
          )]

        ),
        type,
        featureId,
      ),
    );
  }
}
