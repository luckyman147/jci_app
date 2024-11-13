import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jci_app/features/intro/presentation/bloc/bools/bools_bloc.dart';

void main() {
  group('BoolBloc', () {
    // Test initial state
    test('initial state is Bool1State(true)', () {
      final bloc = BoolBloc();
      expect(bloc.state, const Bool1State(true));
    });

    // Test the SetBool1Event
    blocTest<BoolBloc, BoolState>(
      'emits [Bool1State(true), Bool2State(false), Bool3State(false)] when SetBool1Event is added',
      build: () => BoolBloc(),
      act: (bloc) => bloc.add(SetBool1Event(true)),
      expect: () => [
        const Bool1State(true),
        const Bool2State(false),
        const Bool3State(false),
      ],
    );

    // Test the SetBool2Event
    blocTest<BoolBloc, BoolState>(
      'emits [Bool2State(true), Bool1State(false), Bool3State(false)] when SetBool2Event is added',
      build: () => BoolBloc(),
      act: (bloc) => bloc.add(SetBool2Event(true)),
      expect: () => [
        const Bool2State(true),
        const Bool1State(false),
        const Bool3State(false),
      ],
    );

    // Test the SetBool3Event
    blocTest<BoolBloc, BoolState>(
      'emits [Bool3State(true), Bool1State(false), Bool2State(false)] when SetBool3Event is added',
      build: () => BoolBloc(),
      act: (bloc) => bloc.add(SetBool3Event(true)),
      expect: () => [
        const Bool3State(true),
        const Bool1State(false),
        const Bool2State(false),
      ],
    );

    // Test the reset event
    blocTest<BoolBloc, BoolState>(
      'emits [Bool1State(true), Bool2State(false), Bool3State(false)] when resetEvent is added',
      build: () => BoolBloc(),
      act: (bloc) => bloc.add(resetEvent()),
      expect: () => [
        const Bool1State(true),
        const Bool2State(false),
        const Bool3State(false),
      ],
    );
  });
}
