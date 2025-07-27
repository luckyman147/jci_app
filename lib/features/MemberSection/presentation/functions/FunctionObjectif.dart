import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/BuildingBlocks-Permissions/Permissions/Presentation/Bloc/roles/role__bloc.dart';
import '../../data/model/UserObjectifsInfosModel.dart';
import '../../domain/entity/ActionDetails.dart';
import '../../domain/entity/Objectif.dart';
import '../../domain/entity/UserObjectifInfos.dart';
import '../../global-pres.dart';
import '../bloc/objectifs/ObjectifForm/objectif_form_cubit.dart';
import '../constants/ObjectifTypesForm.dart';

class ObjectifFunctions{
  static Map<String, bool> validateForm(ObjectifFormState state, TextEditingController pointsController, TextEditingController scoreController) {
    return {
      "groupObjectif": state.groupObjectif != null,
      "objectifActionType": state.objectifActionType != null,
      "objectifTarget": state.objectifActionType == ObjectifActionType.Discover ||  ( scoreController.text.isNotEmpty && int.tryParse(scoreController.text) != null && int.tryParse(scoreController.text)! > 0),
      "feature": state.feature != null,
      "cibles": state.cibles.isNotEmpty,
      "privacy": state.groupObjectif!=null&& ObjectiveTypesForm.isPrivacyNullForGroup(state.groupObjectif!) || state.privacy != null || (state.feature!=null && state.feature==FeaturesType.Objectif),
      "difficulty":state.groupObjectif!=null&& ObjectiveTypesForm.isPrivacyNullForGroup(state.groupObjectif!,) || state.difficulty != null,
      "points": pointsController.text.isNotEmpty && int.tryParse(pointsController.text) != null && int.tryParse(pointsController.text)! > 0,

    };
  }
  static Map<String, List<UserObjectifInfos>> groupBy(
      List<UserObjectifInfos> userObjectifInfos,String groupBy) {

    Map<String, List<UserObjectifInfos>> groupedUserObjectifs = {};

    for (var userObjectifInfo in userObjectifInfos) {
      switch (groupBy) {
        case "Group Objectif":
          String groupObjectif = userObjectifInfo.objectif.groupObjectif!.name;
          if (!groupedUserObjectifs.containsKey(groupObjectif)) {
            groupedUserObjectifs[groupObjectif] = [];
          }
          groupedUserObjectifs[groupObjectif]!.add(userObjectifInfo);
          break;
        case "Feature":
          String feature = userObjectifInfo.objectif.feature.name;
          if (!groupedUserObjectifs.containsKey(feature)) {
            groupedUserObjectifs[feature] = [];
          }
          groupedUserObjectifs[feature]!.add(userObjectifInfo);
          break;
        case "Status":
        // Determine the status based on points and isCompleted
          String status;
          if (userObjectifInfo.userObjectif.isCompleted) {
            status = "Completed";
          } else if (userObjectifInfo.userObjectif.currentProgress > 0) {
            status = "Pending";
          } else {
            status = "Not Started";
          }

          // Group by status
          if (!groupedUserObjectifs.containsKey(status)) {
            groupedUserObjectifs[status] = [];
          }
          groupedUserObjectifs[status]!.add(userObjectifInfo);
          break;
        default:
          break;
      }
    }
    return groupedUserObjectifs;

 }

 static UserObjectif getUserObjectif(Objectif objectif, List<UserObjectifInfos> userObjectifsInfos) {
    // Find the matching UserObjectifInfos for the given Objectif
    final matchedUserObjectif = userObjectifsInfos.firstWhere(
          (info) => info.objectif.id == objectif.id,
      orElse: () => userObjectifsInfosModel(
        objectif: objectif,
        userObjectif: UserObjectif( false, DateTime.now(),
          currentProgress: 0 // Default progress
          , objectifId: '', // Default completion status
        ),
      ),
    );

    return matchedUserObjectif.userObjectif;
  }

}