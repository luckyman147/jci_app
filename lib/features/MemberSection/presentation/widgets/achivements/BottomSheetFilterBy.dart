import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/Home/Activity_Global.dart';

import '../../../domain/entity/Objectif.dart';
import '../../components/ObjectifField.dart';
import 'FilterWiget.dart';
class BottomSheets {
  static void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full height scrolling
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return FilterWidget();
      },
    );
  }

}
