import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

enum PermissionType{
  canRead,
  canCreate,
  canDelete,
  canUpdate
}
class Permission {
  final PermissionType type;
  final bool isGranted;
  Permission copyWith({
    PermissionType? type,
    bool? isGranted,
  }) {
    return Permission(
      type: type ?? this.type,
      isGranted: isGranted ?? this.isGranted,
    );
  }
  Permission({required this.type, required this.isGranted});}


extension PermissionTypeParsing on String {
  PermissionType toPermissionType() {

    switch (this.toLowerCase()) {
      case "canread":
        return PermissionType.canRead;
      case "cancreate":
        return PermissionType.canCreate;
      case "candelete":
        return PermissionType.canDelete;
      case "canupdate":
        return PermissionType.canUpdate;
      default:
        throw ArgumentError("Invalid permission type: $this");
    }
  }
}
