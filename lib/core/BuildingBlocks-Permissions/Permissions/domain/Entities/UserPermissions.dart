import 'FeaturePermissions.dart';

class UserPermissions {
  final String userId;
  final List<FeaturePermissions> featurePermissions;

  UserPermissions({required this.userId, required this.featurePermissions});}