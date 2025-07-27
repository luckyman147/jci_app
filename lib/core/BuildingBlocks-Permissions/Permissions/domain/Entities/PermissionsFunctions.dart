import 'package:jci_app/core/BuildingBlocks-Permissions/Permissions/domain/Entities/FeaturePermissions.dart';

bool checkAllIdsExist(List<String> list1, List<FeaturePermissions> list2,)  {
  for (var id in list1) {
    // Check if list2 contains an item with the matching id
    bool exists = list2.any((item) => item.featureId == id);
    if (!exists) {
      // If any id doesn't exist in list2, return false
      return false;
    }
  }
  // If all ids exist in list2, return true
  return true;
}
