import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/Permission.dart';

import '../../../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/widgets/AsyncComponents.dart';
import '../../../../../../core/app_theme.dart';

class CreateOptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
final String permissionName;
  const CreateOptionButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.color,
    required this.permissionName ,
  });


  @override
  Widget build(BuildContext context) {
    return

      AsyncComponents.buildFutureBuilder(
        Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          foregroundColor: Colors.black,
        ),
        onPressed: onTap,
        child: AutoSizeText(
          label,
          style: PoppinsSemiBold(15.sp, Colors.black, TextDecoration.none),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
      ),
    ),PermissionType.canCreate,permissionName);
  }

  static Widget CreateRowOption(
      BuildContext context, {
        required String label,
         Color color=PrimaryColor,
        required IconData icon,
        required VoidCallback onTap,
        required String permissionName,
      }) {
    return  AsyncComponents.buildFutureBuilder( Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
        child:

        Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.1),
                  border: Border.all(color: color,width: 2)

                ),
                child: Icon(icon, color: color),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: PoppinsRegular(14, ColorsApp.textColorBlack),
            ),
          ],
        ),
      ),PermissionType.canCreate,permissionName
    );
  }

}
