
import '../Entities/Permission.dart';

class CheckPermissionDtos{
  final String featureId;final PermissionType permissionType;

  CheckPermissionDtos({required this.featureId, required this.permissionType});
}