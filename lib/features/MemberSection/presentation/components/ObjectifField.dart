import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';

import '../../../../core/strings/objectifsIcon.dart';
import '../../../Home/Activity_Global.dart';
import '../../../common/enums/PrivacyType.dart';
import '../../domain/entity/ActionDetails.dart';
class FormNormal extends StatelessWidget {
  final TextInputType keyboard;
  final TextEditingController controller;
  final String label;
  final String validatorMessage;
  final int multiline;
  final bool isError;

  const FormNormal({
    Key? key,
    this.keyboard = TextInputType.text,
    required this.controller,
    required this.label,
    required this.validatorMessage,
    this.multiline = 1, required this.isError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        forceErrorText: isError?validatorMessage:null,
        cursorColor: PrimaryColor,
        maxLines: multiline,
        keyboardType: keyboard,
        enableSuggestions: true,
        controller: controller,

        style: PoppinsRegular(14.sp, ColorsApp.textColorBlack),
        decoration: ObjectifsField.inputDecorationObjectif(label.tr(context)),
        validator: (value) => value!.isEmpty ? validatorMessage.tr(context) : null,
      ),
    );
  }
}
class DropDown<T> extends StatelessWidget {
  final T selected;
  final List<T> options;
  final Function(T) onChanged;
  final String validator;
  final bool isError ;
final Color borderColor;

  const DropDown({
    Key? key,
    this.borderColor=ColorsApp.textColorBlack,
    required this.selected,
    required this.options,
    required this.onChanged,
    required this.validator, required this.isError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<T>(

            value: options.contains(selected) ? selected : null,
            decoration: ObjectifsField.inputDecorationObjectif(validator).copyWith(
              enabledBorder: isError?border(Colors.red):border(borderColor),
            ),
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
                     op is Enum ? op.name.doublesWords.tr(context) : op.toString().tr(context),
                      style: PoppinsRegular(15.sp, ColorsApp.textColorBlack),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (value) => onChanged(value!),
            validator: (value) => value == null ? validator : null,
          ),

          isError?Padding(
            padding:paddingSemetricVerticalHorizontal(),
child: Text(validator.tr(context),style: PoppinsLight(17.sp, Colors.red),),
          ):Container()
        ],
      ),
    );
  }
}
class ObjectifsField {
  static InputDecoration inputDecorationObjectif(String label) {
    return InputDecoration(
      enabledBorder: border(ColorsApp.textColorBlack),
      errorBorder: border(Colors.red),
      errorStyle: PoppinsLight(15.sp, Colors.red),
               focusedErrorBorder: border(Colors.red),
      focusedBorder: border(PrimaryColor),
      hintText: label,
      hintStyle: PoppinsNorml(17.sp, ColorsApp.ThirdColor),
    );
  }
}


