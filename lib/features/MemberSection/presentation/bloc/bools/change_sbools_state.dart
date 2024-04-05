part of 'change_sbools_cubit.dart';
enum StatesBool{Initial,Points,Activities,Teams,Members}
enum SettingsBools{Initial,Profile,Language,Mode,Notifications,Help}
 class ChangeSboolsState extends Equatable {
   final StatesBool state;
   final SettingsBools settings;

  const ChangeSboolsState({this.state=StatesBool.Initial,this.settings=SettingsBools.Initial});
  ChangeSboolsState copyWith({StatesBool? state,SettingsBools? settings}) {


    return ChangeSboolsState(state: state??this.state,settings: settings??this.settings);
  }
  @override
  List<Object> get props => [state,settings];
}

class ChangeSboolsInitial extends ChangeSboolsState {

  @override
  List<Object> get props => [];
}
