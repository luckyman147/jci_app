part of 'num_pages_bloc.dart';

 class NumPagesState extends Equatable {
   const NumPagesState({
     this.numPages = const [],
     this.CurrentPage = 1,
   } );
  final List<int> numPages;
  final int CurrentPage ;
   NumPagesState copyWith(
       {
          List<int>? numPages,
         int? CurrentPage,
 }) {
     return NumPagesState(
        CurrentPage: CurrentPage ?? this.CurrentPage,
         numPages: numPages ?? this.numPages,
     );
   }

  @override
  // TODO: implement props
  List<Object?> get props => [numPages,CurrentPage];

}

class NumPagesInitial extends NumPagesState {
  @override
  List<Object> get props => [];
}
