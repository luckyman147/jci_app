part of 'action_jci_cubit.dart';
enum PresidentsAction{
  Initial ,Add,Update,Delete
}
enum TypeDelete{
  Board,Member,Post,Role
}
 class ActionJciState extends Equatable {
  final PresidentsAction action;
final String year ;
final String cloneYear;
final TypeDelete typeDelete;

final Map<String,dynamic> member;
final int pageNum;
   ActionJciState({ this.action=PresidentsAction.Initial,this.year='',this.cloneYear='',this.member=const {}, this.pageNum=0,
   this.typeDelete=TypeDelete.Board,
   });
  ActionJciState copyWith({PresidentsAction? action,String? year,String? cloneYear,Map<String,dynamic>? member,int? pageNum,
  TypeDelete? typeDelete,

  }) {
    return ActionJciState(action: action??this.action,year: year??this.year??'',cloneYear: cloneYear??this.cloneYear??'',member: member??this.member??{},pageNum: pageNum??this.pageNum??0,
    typeDelete: typeDelete??this.typeDelete,

    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [action,year,cloneYear,member,pageNum,typeDelete];
}

class ActionJciInitial extends ActionJciState {
  @override
  List<Object> get props => [];
}
