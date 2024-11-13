
import '../Entities/FeaturePermissions.dart';

class CreateRoleDtos{
  final String roleName; final List<FeaturePermissions> features;

  CreateRoleDtos({required this.roleName, required this.features});
}