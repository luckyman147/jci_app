
import 'package:flutter_test/flutter_test.dart';
import 'package:jci_app/core/usescases/usecase.dart';

void main() {
  test(
    'make sure that the props of NoParams is []',
        () async {
      // assert
      expect(NoParams().props, []);
    },
  );
}