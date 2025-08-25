part of 'category_bloc.dart';

 sealed class CategoryEvent extends Equatable {

}

class CategoryNameChanged extends CategoryEvent {
  final String name;
  CategoryNameChanged({required this.name});
  @override
  List<Object> get props => [name];
}

class ChangeIndex extends CategoryEvent {
  final int index;
  ChangeIndex({required this.index});
  @override
  List<Object> get props => [index];
}
class GetAllCategoriesEvent extends CategoryEvent {
   final bool isRefreshed;
   //Constrator
    GetAllCategoriesEvent({this.isRefreshed = false});
  @override
  List<Object> get props => [isRefreshed];
}
class GetCategoryByNameEvent extends CategoryEvent {
  final String name;
  GetCategoryByNameEvent({required this.name});
  @override
  List<Object> get props => [name];
}
class GetCategoryByIdEvent extends CategoryEvent {
  final String id;
  GetCategoryByIdEvent({required this.id});
  @override
  List<Object> get props => [id];
}
class CreateCategoryEvent extends CategoryEvent {
  final Category category;
  CreateCategoryEvent({required this.category});
  @override
  List<Object> get props => [category];
}
class UpdateCategoryEvent extends CategoryEvent {
  final Category category;
  UpdateCategoryEvent({required this.category});
  @override
  List<Object> get props => [category];
}
class DeleteCategoryEvent extends CategoryEvent {
  final String id;
  DeleteCategoryEvent({required this.id});
  @override
  List<Object> get props => [id];
}
class SelectCategoryEvent extends CategoryEvent {
  final Category category;
  final ActionImage actionImage;
  SelectCategoryEvent(this.actionImage, {required this.category});
  @override
  List<Object> get props => [category,actionImage];
}
class ResetCategoryEvent extends CategoryEvent {
  @override
  List<Object> get props => [];
}
class InitCategoryEvent extends CategoryEvent {
  @override
  List<Object> get props => [];
}
class FetchCategoriesById extends CategoryEvent {
  final List<String> categories;
  FetchCategoriesById({required this.categories});
  @override
  List<Object> get props => [categories];
}
class throwError extends CategoryEvent {
  final String message;
  throwError({required this.message});
  @override
  List<Object> get props => [message];
}