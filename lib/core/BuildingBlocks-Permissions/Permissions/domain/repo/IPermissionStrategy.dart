
import '../../../../../features/auth/AuthWidgetGlobal.dart';
abstract class Strategy<T,E> {
  Future<void> LoadPermissionsOfMaster(T t,E e);
}
