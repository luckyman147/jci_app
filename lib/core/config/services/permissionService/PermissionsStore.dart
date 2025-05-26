import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../BuildingBlocks-Permissions/Permissions/Data/Models/FeaturePermissionsModel.dart';
import 'package:encrypt_shared_preferences/provider.dart';
class SecurePermissionStore {
  final SharedPreferences storage;

  SecurePermissionStore({required this.storage});

  // Save a list of FeaturePermissionsModel with an expiration time
  Future<void> savePermissionsList(
      List<FeaturePermissionsModel> models, Duration duration) async {
    int expiryTime = DateTime.now().add(duration).millisecondsSinceEpoch;
    final decodeddata = models.map((model) => model.toMap()).toList();
//Logger().w(decodeddata);
    Map<String, dynamic> data = {
      "permissions": decodeddata,
      "expiryTime": expiryTime,
    };

    await storage.setString("feature_permissions", jsonEncode(data),
       );
  }

  // Fetch permissions by feature IDs (load from storage or API if missing)
  Future<List<FeaturePermissionsModel>> getPermissions(
      List<String> featureIds) async {
    String? jsonData =
        await storage.getString("feature_permissions",);
    List<FeaturePermissionsModel> storedPermissions = [];

    if (jsonData != null) {
      Map<String, dynamic> data = jsonDecode(jsonData);

      // Check if the data has expired
      int expiryTime = data["expiryTime"] ?? 0;
      if (DateTime.now().millisecondsSinceEpoch > expiryTime) {
        await removePermissions(); // Expired, clear storage
      } else {
        List<Map<String, dynamic>> permissionsList =
            List<Map<String, dynamic>>.from(data["permissions"]);
        storedPermissions = permissionsList
            .map((map) => FeaturePermissionsModel.fromMap(
                map["featureId"], map["permissions"]))
            .toList();
      }
    }

    // Check for missing feature permissions

    return storedPermissions;
  }

  // Remove permissions
  Future<void> removePermissions() async {
    await storage.clear();
  }
}
