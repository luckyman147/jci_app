import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:jci_app/features/intro/presentation/bloc/index/index_bloc.dart';


void main() {
  group('IndexBloc', () {
    test('emits IndexLoaded when SetIndexEvent is added', () {
      // Arrange
      const initialIndex = 0;
      final bloc = IndexBloc(initialIndex);

      // Act
      bloc.add(SetIndexEvent( index: 5));

      // Assert
      expectLater(
        bloc.stream,
        emitsInOrder([
          IndexInitial(initialIndex), // initial state
          IndexLoaded(5),             // after SetIndexEvent
        ]),
      );
    });

    test('emits IndexInitial(0) when resetIndex is added', () {
      // Arrange
      const initialIndex = 5;
      final bloc = IndexBloc(initialIndex);

      // Act
      bloc.add(resetIndex());

      // Assert
      expectLater(
        bloc.stream,
        emitsInOrder([
          IndexInitial(initialIndex), // initial state
          const IndexInitial(0),      // after resetIndex event
        ]),
      );
    });
  });
}
