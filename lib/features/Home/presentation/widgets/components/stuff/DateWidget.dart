import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';

import '../../../../../changelanguages/presentation/bloc/locale_cubit.dart';
import '../../../../Activity_Global.dart';
import '../../Activity/AddActivityWidgets.dart';
import '../../Formz.dart';



class TimesWidget extends StatelessWidget {
  const TimesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 18.0, vertical: 8),
            child: SizedBox(
                width: mediaQuery.size.width,
                child: const BeginTimeWidget()

            )),
        AddWidgetComponents.    AddEndDateButton(mediaQuery,"Show End date".tr(context)),
        EndDateWidget(LabelText: 'End Date'.tr(context), SheetTitle: "Date and Hour of End".tr(context), HintTextDate: 'End Date'.tr(context), HintTextTime: 'End Time'.tr(context),
        ),
      ],
    );
  }
}

class DateFieldWidget extends StatefulWidget {
  final String labelText;
  final String sheetTitle;
  final String hintTextDate;
  final String hintTextTime;
  final TimeType timeType;
  final DateTime date;
  final MediaQueryData mediaQuery;

  const DateFieldWidget({
    Key? key,
    required this.labelText,
    required this.sheetTitle,
    required this.hintTextDate,
    required this.hintTextTime,
    required this.timeType,
    required this.date,
    required this.mediaQuery,
  }) : super(key: key);

  @override
  _DateFieldWidgetState createState() => _DateFieldWidgetState();
}

class _DateFieldWidgetState extends State<DateFieldWidget> {
  TimeOfDay selectedDate = TimeOfDay.now();
  DateTime time = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelText,
            style: PoppinsRegular(18, textColorBlack),
          ),
          BlocBuilder<FormzBloc, FormzState>(
            builder: (context, state) {
              return _buildBottomSheet(context, state);
            },
          ),
        ],
      ),
    );
  }

  InkWell _buildBottomSheet(BuildContext context, FormzState state) {
    return bottomSheet(
      context,
      widget.mediaQuery,
      widget.sheetTitle,
      widget.date,
      widget.hintTextDate,
      widget.hintTextTime,
          () async {
        await _selectTime(context);
      },
          () async {
        await _selectDate(context);
      },
          () {
        _submitDateTime(context);
      },
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.dial,
      initialTime: selectedDate,
    );
    if (selectedTime != null && mounted) {
      setState(() {
        selectedDate = selectedTime;
      });
      context.read<FormzBloc>().add(jokerTimeChanged(joketimer: selectedTime));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      currentDate: time,
      lastDate: DateTime.now().add(const Duration(days: 365)),
      onDatePickerModeChange: (mode) {},
    );

    if (selectedDate != null && mounted) {
      setState(() {
        time = selectedDate;
      });
      context.read<FormzBloc>().add(jokerChanged(joke: selectedDate));
    }
  }

  void _submitDateTime(BuildContext context) {
    final DateTime combinedDateTime = ActivityAction.combineTimeAndDate(selectedDate, time);

    if (widget.timeType == TimeType.begin) {
      context.read<FormzBloc>().add(BeginTimeChanged(date: combinedDateTime));
    } else if (widget.timeType == TimeType.end) {
      context.read<FormzBloc>().add(EndTimeChanged(date: combinedDateTime));
    } else {
      context.read<FormzBloc>().add(RegistraTimeChanged(date: combinedDateTime));
    }

    context.pop();
  }


}

class ChooseDateWidget extends StatelessWidget {
  final DateTime todayDate;

  final String format;
  final Function() onTap;
  final String text;
  final LocaleState locale;

  const ChooseDateWidget({
    Key? key,
    required this.todayDate,

    required this.format,
    required this.onTap,
    required this.text,
    required this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return InkWell(
      onTap: onTap,
      child: BlocBuilder<FormzBloc, FormzState>(
        builder: (context, state) {
          return Container(
            width: mediaQuery.size.width,
            decoration: BoxDecoration(
              border: Border.all(color: textColorBlack),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: PoppinsLight(18, textColorBlack),
                  ),
                  Text(
                    DateFormat(
                      format,
                      locale.locale == const Locale("en") ? "en" : "fr",
                    ).format(todayDate),
                    style: PoppinsSemiBold(
                      mediaQuery.devicePixelRatio * 5,
                      textColorBlack,
                      TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
class ChooseTimeWidget extends StatelessWidget {
  final TimeOfDay todayTime;

  final String format;
  final Function() onTap;
  final String text;

  const ChooseTimeWidget({
    Key? key,
    required this.todayTime,

    required this.format,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return InkWell(
      onTap: onTap,
      child: BlocBuilder<FormzBloc, FormzState>(
        builder: (context, state) {
          return Container(
            width: mediaQuery.size.width,
            decoration: BoxDecoration(
              border: Border.all(color: textColorBlack),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: PoppinsLight(18, textColorBlack),
                  ),
                  Text(
                    todayTime.format(context),
                    style: PoppinsSemiBold(
                      mediaQuery.devicePixelRatio * 5,
                      textColorBlack,
                      TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}