import 'package:jci_app/features/MemberSection/domain/entity/Objectif.dart';
import 'package:jci_app/features/MemberSection/domain/entity/UserObjectifInfos.dart';

class userObjectifsInfosModel extends UserObjectifInfos{
  userObjectifsInfosModel({required super.objectif, required super.userObjectif});

factory userObjectifsInfosModel.fromJson(Objectif objectif, UserObjectif userobjectifs) {
    return userObjectifsInfosModel(
      objectif: objectif,
      userObjectif: userobjectifs,
    );
  }

}