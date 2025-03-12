import 'package:flutter/material.dart';
import '../../../../../../core/app_theme.dart';

import '../../../../../../core/config/locale/app__localizations.dart';

class SearchTextField extends StatelessWidget {


  final Function(String) onChanged;
  final String hintText;
  final String? errorText;

  const SearchTextField({
    Key? key,
required this.onChanged, required this.hintText, this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery=MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: TextField(
        style: PoppinsRegular(
          mediaQuery.devicePixelRatio * 5,
          textColorBlack,
        ),
        onChanged: (value) {
          onChanged(value);

        },
        decoration: InputDecoration(
          errorText: errorText != null ? "Empty Field".tr(context) : null,
          prefixIcon: const Icon(
            Icons.search,
            color: textColor,
          ),
          hintText: hintText.tr(context),
          hintStyle: PoppinsRegular(
            mediaQuery.devicePixelRatio * 4,
            textColor,
          ),
          focusedBorder: border(PrimaryColor),
          enabledBorder: border(ThirdColor),
          errorBorder: border(Colors.red),
          focusedErrorBorder: border(Colors.red),
          errorStyle: ErrorStyle(16, Colors.red),
        ),
      ),
    );
  }
}
