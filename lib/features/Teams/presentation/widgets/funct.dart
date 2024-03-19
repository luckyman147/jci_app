import 'package:jci_app/features/auth/domain/entities/Member.dart';

bool doesObjectExistInList(List<Object> list, Object targetObject) {
  return list.contains(targetObject);
}
List<String> getIds(List<Member> objects) {
  if (objects.isEmpty || objects == null  ) {
    return [];
  }
  return objects.map((obj) => obj.id ).toList();
}
List<int> generateNumbers(int num) {
  return List.generate(num, (index) => num - index + 1).reversed.toList();
}
