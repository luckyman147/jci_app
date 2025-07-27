
// 6. date_picker_utils.dart
import '../../../Home/Activity_Global.dart';

class DatePickerUtils {
  static Future<void> showDatePickerDialog(
      BuildContext context, DateTime current, Function(DateTime) onSelect) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      currentDate: current,
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) onSelect(picked);
  }
}