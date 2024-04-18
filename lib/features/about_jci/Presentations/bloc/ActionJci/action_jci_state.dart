part of 'action_jci_cubit.dart';
enum PresidentsAction{
  Initial ,Add,Update,Delete
}
 class ActionJciState extends Equatable {
  final PresidentsAction action;
final String year ;
final String cloneYear;
  const ActionJciState({ this.action=PresidentsAction.Initial,this.year='',this.cloneYear=''});
  ActionJciState copyWith({PresidentsAction? action,String? year,String? cloneYear}) {
    return ActionJciState(action: action??this.action,year: year??this.year??'',cloneYear: cloneYear??this.cloneYear??'');
  }

  @override
  // TODO: implement props
  List<Object?> get props => [action,year,cloneYear];
}

class ActionJciInitial extends ActionJciState {
  @override
  List<Object> get props => [];
}
