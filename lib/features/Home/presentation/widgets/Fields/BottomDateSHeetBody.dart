import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jci_app/core/config/locale/app__localizations.dart';
import '../../../../../core/app_theme.dart';
import '../../../../changelanguages/presentation/bloc/locale_cubit.dart';

import '../components/stuff/DateWidget.dart'; // Assuming FormzBloc and other necessary imports

class BottomDateSheetBodyWidget extends StatelessWidget {

  final String sheetTitle;
  final DateTime date;
  final String hintTextDate;
  final String hintTextTime;
  final Function() timePickerFunction;
  final Function() datePickerFunction;
  final Function() saveMethod;
  final TimeOfDay time;

  const BottomDateSheetBodyWidget({
    Key? key,

    required this.sheetTitle,
    required this.date,
    required this.hintTextDate,
    required this.hintTextTime,
    required this.timePickerFunction,
    required this.datePickerFunction,
    required this.saveMethod,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SizedBox(
      height: mediaQuery.size.height / 2.5,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 10,
        ),
        child: BlocBuilder<localeCubit, LocaleState>(
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sheetTitle,
                  style: PoppinsSemiBold(
                    mediaQuery.devicePixelRatio * 6,
                    PrimaryColor,
                    TextDecoration.none,
                  ),
                ),
                ChooseDateWidget(
                  todayDate: date,
                  format: "MMM,dd,yyyy",
                  onTap: datePickerFunction,
                  text: hintTextDate,
                  locale: state,
                ),
                ChooseTimeWidget(
                  todayTime: time,
                  format: "hh:mm a",
                  onTap: timePickerFunction,
                  text: hintTextTime,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PrimaryColor,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  onPressed: saveMethod,
                  child: Center(
                    child: Text(
                      "Save".tr(context),
                      style: PoppinsSemiBold(
                        18,
                        textColorWhite,
                        TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
