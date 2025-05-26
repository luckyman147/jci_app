import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/strings/failures.dart';
import 'package:jci_app/core/usescases/usecase.dart';
import 'package:jci_app/features/Home/domain/Dtos/PollDto.dart';
import 'package:jci_app/features/Home/domain/usercases/PollUsesCases.dart';
import 'package:jci_app/features/auth/AuthWidgetGlobal.dart';

import '../../../../../core/config/services/MemberStore.dart';
import '../../../../../core/config/services/store.dart';
import '../../../domain/entities/poll/Poll.dart';
import '../../../domain/entities/poll/PollOption.dart';
import '../../../domain/entities/poll/Vote.dart';
import '../../../domain/enums/PollEnum.dart';

part 'poll_event.dart';
part 'poll_state.dart';

class PollBloc extends Bloc<PollEvent, PollState> {
  PollBloc(
      this.createPollUseCase,
      this.getPollsOfActivityUseCase,
      this.addOptionUseCase,
      this.updateOption,
      this.updateVote,
      this.deletePollUseCase,
      this.getPollAsTemplatesUseCase,
      this.store,
      this.memberStore)
      : super(PollInitial()) {
    on<PollEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<AddPollEvent>(_AddPoll);
    on<FetchPolls>(_fetchPolls);
    on<ReseTSTate>((event, emit) {
      emit(state.copyWith(pollEnum: PollEnum.Initial, voted: {}));
    });
    on<AddOptionEvent>((event, emit) {
      emit(state.copyWith(options: [...state.options, event.pollOptions]));
    });
    on<CancelPollEvent>((event, emit) {
      emit(state.copyWith(options: []));
    });
    on<DeleteOptionEvent>((event, emit) {
      emit(state.copyWith(
          options: state.options
              .where((element) => element.id != event.pollOptions.id)
              .toList()));
    });
    on<InitOptions>(_votesInit);
    on<ChangeIsSelected>((event, emit) {
      emit(state.copyWith(isSelected: event.isSelected));
    });
    on<GetPollsAsTemplates>(_getTemplates);
    on<DeletePollEvent>(_deletePoll);
    on<voteEvent>(_addVote);
    on<unvoteEvent>(_removeVote);
    on<SubmitVotes>(_submitVotes);
  }

  Future<void> _getTemplates(
      GetPollsAsTemplates event, Emitter<PollState> emit) async {
    if (state.Templates.isNotEmpty) {
      return;
    }
    final result = await getPollAsTemplatesUseCase(NoParams());
    emit(_EitherSuccessOrFailure(
        result, (polls) => state.copyWith(Templates: polls)));
  }

  Future<void> _votesInit(InitOptions event, Emitter<PollState> emit) async {
    Logger().i("InitOptions");
    final usezrId = await store.getUserId();
    Map<String, bool> votes = {};
    for (var option in event.options) {
      if (option.votes.isEmpty) {
        votes[option.id] = false;
      } else {
        if (option.votes.any((element) => element.userId == usezrId)) {
          votes[option.id] = true;
        } else {
          votes[option.id] = false;
        }
      }
    }
    Logger().i("done");
    emit(state.copyWith(
      options: event.options,
      voted: votes,
    ));
  }

  final CreatePollUseCase createPollUseCase;
  final AddOptionUseCase addOptionUseCase;
  final Store store;
  final GetPollsOfActivityUseCase getPollsOfActivityUseCase;
  final UpdateOption updateOption;
  final UpdateVote updateVote;
  final MemberStore memberStore;
  final DeletePollUseCase deletePollUseCase;
  final GetPollAsTemplatesUseCase getPollAsTemplatesUseCase;
  _AddPoll(AddPollEvent event, Emitter<PollState> emit) async {
    emit(state.copyWith(pollEnum: PollEnum.Loading));
    final result = await createPollUseCase(event.poll);
    emit(_EitherSuccessOrFailure(
        result,
        (poll) => state.copyWith(
            polls: state.polls, pollEnum: PollEnum.CreatedPoll)));
  }

  _addVote(voteEvent event, Emitter<PollState> emit) async {
    final userEvent = await memberStore.getPrimitiveModel();
    final vote = Vote(
      userId: userEvent.id!,
      userImage: userEvent.Images.isNotEmpty ? userEvent.Images[0] : "",
    );

    // Update only the relevant poll option
    final updatedOptions = state.options.map((option) {
      if (option.id == event.pollOptionId) {
        return option.copyWith(
          voted: [...option.votes, vote],
        );
      }
      return option;
    }).toList();
    state.voted[event.pollOptionId] = true;

    emit(state.copyWith(
        options: updatedOptions, voted: state.voted, pollEnum: PollEnum.Voted));
  }

  _removeVote(unvoteEvent event, Emitter<PollState> emit) async {
    final userEvent = await memberStore.getPrimitiveModel();
    final userId = userEvent.id!;

    // Update only the relevant poll option
    final updatedOptions = state.options.map((option) {
      if (option.id == event.pollOptionId) {
        return option.copyWith(
          voted: option.votes.where((vote) => vote.userId != userId).toList(),
        );
      }
      return option;
    }).toList();
    state.voted[event.pollOptionId] = false;

    emit(state.copyWith(
        options: updatedOptions,
        voted: state.voted,
        pollEnum: PollEnum.Unvoted));
  }

  _fetchPolls(FetchPolls event, Emitter<PollState> emit) async {
    emit(state.copyWith(pollEnum: PollEnum.Loading));
    await emit.forEach<Either<Failure, List<Poll>>>(
      getPollsOfActivityUseCase.call(event.ActivityId),
      onData: (polls) {
        final pollList = polls.getOrElse(() => []);
        return state.copyWith(polls: pollList, pollEnum: PollEnum.Loaded);
      },
      onError: (failure, stack) {
        return state.copyWith(
            error: mapFailureToMessage(failure as Failure),
            pollEnum: PollEnum.Error);
      },
    );
  }

  _deletePoll(DeletePollEvent event, Emitter<PollState> emit) async {
    emit(state.copyWith(pollEnum: PollEnum.Loading));
    final result = await deletePollUseCase(event.poldto);
    emit(_EitherSuccessOrFailure(
        result, (r) => state.copyWith(pollEnum: PollEnum.Deleted)));
  }

  PollState _EitherSuccessOrFailure<T>(
      Either<Failure, T> Result, PollState Function(T) function) {
    return Result.fold(
      (failure) =>
          state.copyWith(error: failure.toString(), pollEnum: PollEnum.Error),
      (success) => function(success),
    );
  }

  _submitVotes(SubmitVotes event, Emitter<PollState> emit) async {
    emit(state.copyWith(pollEnum: PollEnum.Loading));
    final result = await updateVote(event.poldto);
    emit(_EitherSuccessOrFailure(
        result, (r) => state.copyWith(pollEnum: PollEnum.Loaded)));
  }
}
