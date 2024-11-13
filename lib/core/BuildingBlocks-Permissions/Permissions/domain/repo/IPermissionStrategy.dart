
import '../../../../../features/auth/AuthWidgetGlobal.dart';
import '../../Presentation/PermissionsBLoc/permissions_bloc.dart';

abstract class IPermissionStrategy {
  Widget buildWidget(PermissionCheckedState state);
}
