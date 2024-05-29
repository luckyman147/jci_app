part of 'change_sbools_cubit.dart';
enum StatesBool{Initial,Points,Activities,Teams,Members,Objectifs,JCI,Description}
enum JciStates{Initial,Presentations,Board,Presidants}
enum SettingsBools{Initial,Profile,Language,Mode,Notifications,Help,Members}
 class ChangeSboolsState extends Equatable {
   final StatesBool state;
   final SettingsBools settings;
   final bool IsActive;
   final List<String> previosPages;
   final List<String> upcomingPages;
   final bool isOwner;
   final bool isObscur;
   final JciStates jciState;

  const ChangeSboolsState({this.state=StatesBool.Initial,this.settings=SettingsBools.Initial,this.previosPages=const [],this.upcomingPages=const [],this.isOwner=true,
    this.jciState=JciStates.Initial,
    this.isObscur=true,

    this.IsActive=true});
  ChangeSboolsState copyWith({StatesBool? state,SettingsBools? settings,List<String>? previosPages,
    JciStates? jciState,
    bool? isObscur,

    List<String>? upcomingPages,bool? IsActive,}) {


    return ChangeSboolsState(state: state??this.state,settings: settings??this.settings,
    jciState: jciState??this.jciState,
    isObscur: isObscur??this.isObscur,

        previosPages: previosPages??this.previosPages,upcomingPages: upcomingPages??this.upcomingPages,IsActive: IsActive??this.IsActive,isOwner: isOwner);
  }
  @override
  List<Object> get props => [state,settings,previosPages,upcomingPages,IsActive,isOwner,jciState,isObscur];
}

class ChangeSboolsInitial extends ChangeSboolsState {

  @override
  List<Object> get props => [];
}
