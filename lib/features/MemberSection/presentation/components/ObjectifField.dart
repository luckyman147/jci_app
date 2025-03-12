import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';

import '../../../../core/strings/objectifsIcon.dart';
import '../../../Home/Activity_Global.dart';
import '../../domain/entity/ActionDetails.dart';
class FormNormal extends StatelessWidget {
  final TextInputType keyboard;
  final TextEditingController controller;
  final String label;
  final String validatorMessage;
  final int multiline;

  const FormNormal({
    Key? key,
    this.keyboard = TextInputType.text,
    required this.controller,
    required this.label,
    required this.validatorMessage,
    this.multiline = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        cursorColor: PrimaryColor,
        maxLines: multiline,
        keyboardType: keyboard,
        enableSuggestions: true,
        controller: controller,
        style: PoppinsRegular(14.sp, ColorsApp.textColorBlack),
        decoration: ObjectifsField.inputDecorationObjectif(label),
        validator: (value) => value!.isEmpty ? validatorMessage : null,
      ),
    );
  }
}
class DropDown<T> extends StatelessWidget {
  final T selected;
  final List<T> options;
  final Function(T) onChanged;
  final String validator;


  const DropDown({
    Key? key,
    required this.selected,
    required this.options,
    required this.onChanged,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField<T>(
        value: options.contains(selected) ? selected : null,
        decoration: ObjectifsField.inputDecorationObjectif(validator),
        items: options.map((op) {
          return DropdownMenuItem(
            alignment: Alignment.center,
            value: op,
            child: Row(

              children: [
                op.runtimeType == ObjectifDifficulty?Padding(
                  padding: paddingSemetricHorizontal(),
                  child: Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: ObjectifDifficultyColor().objectifDifficultyColor[op]!,
                      shape: BoxShape.circle,
                    ),
                  ),
                ):
                op.runtimeType == PrivacyType?Padding(
                  padding: paddingSemetricHorizontal(),
                  child: Container(
                    width: 10.w,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: op == PrivacyType.Public ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ):


                Padding(
                  padding: paddingSemetricHorizontal(),
                  child: Icon(
                    op.runtimeType == FeaturesType
                        ? ObjectifIcons().getIcon(op as FeaturesType).icon
                        : op.runtimeType == ObjectifActionType?ObjectifActionIcons.getIcon(op as ObjectifActionType):
                    op.runtimeType==GroupObjectif?GroupObjectifIcons.getIcon(op as GroupObjectif):null,

                  ),
                ),



                AutoSizeText(
                 op is Enum ? op.name.doublesWords : op.toString(),
                  style: PoppinsRegular(18.sp, ColorsApp.textColorBlack),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (value) => onChanged(value!),
        validator: (value) => value == null ? validator : null,
      ),
    );
  }
}
class ObjectifsField {
  static InputDecoration inputDecorationObjectif(String label) {
    return InputDecoration(
      enabledBorder: border(ColorsApp.textColorBlack),
      errorBorder: border(Colors.red),
      errorStyle: PoppinsRegular(14.sp, Colors.red),
      focusedBorder: border(PrimaryColor),
      hintText: label,
      hintStyle: PoppinsRegular(20.sp, ColorsApp.ThirdColor),
    );
  }
}


