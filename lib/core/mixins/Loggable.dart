import 'package:logger/logger.dart';

import '../../injection_container.dart';

mixin Loggable {
  Logger get log => sll<Logger>();
}
