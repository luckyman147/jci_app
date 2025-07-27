part of 'category_bloc.dart';

 class CategoryState extends Equatable {
   const CategoryState({
    this.categories=const [],
    this.Clonecategories=const [],
    this.isLoading=false,
     this.SelectedCategories=const [],
    this.error="",
    this.category,
     this.PageIndex=0,
    this.CategoryName="",
  });
final bool isLoading;
final String error;
  final List<Category> categories ;
  final List<Category> Clonecategories ;
  final List<Category> SelectedCategories ;
  final Category? category;
  final String CategoryName;
  final int PageIndex;
  //copywith method
   CategoryState copyWith({


     bool? isLoading,
      String? error,
     Category? category,
      String? CategoryName,
     List<Category>? SelectedCategories,

     List<Category>? categories,
     int? PageIndex,
    List<Category>? Clonecategories,
  }) {
    return CategoryState(
      PageIndex: PageIndex ?? this.PageIndex,
      CategoryName: CategoryName ?? this.CategoryName,
      category: category ?? this.category,
      SelectedCategories: SelectedCategories ?? this.SelectedCategories,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      categories: categories ?? this.categories,
      Clonecategories: Clonecategories ?? this.Clonecategories,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [categories,
    PageIndex,
    Clonecategories,CategoryName,isLoading,error,SelectedCategories,category];
}

final class CategoryInitial extends CategoryState {
  @override
  List<Object> get props => [];
}
