part of 'user_objectif_progress_cubit.dart';
enum ProgresStatus{Initial,Loaded,Failure,Empty}
 class UserObjectifProgressState extends Equatable {
  const UserObjectifProgressState( { this.progresStatus=ProgresStatus.Initial ,this.userProgresUpdates=const []});
  final List<UserObjectifInfos> userProgresUpdates;
final ProgresStatus progresStatus;
  UserObjectifProgressState copyWith({
    ProgresStatus?progress,
  List<UserObjectifInfos>?userProgressUpdates,
  }){
    return UserObjectifProgressState(
      progresStatus: progress??this.progresStatus,
    userProgresUpdates: userProgressUpdates??this.userProgresUpdates
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [userProgresUpdates,progresStatus];
}

final class UserObjectifProgressInitial extends UserObjectifProgressState {
  @override
  List<Object> get props => [];
}
