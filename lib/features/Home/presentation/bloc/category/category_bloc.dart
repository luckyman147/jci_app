import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:jci_app/features/Home/domain/usercases/CategoryUseCases.dart';

import '../../../../../core/error/Failure.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/usescases/usecase.dart';
import '../../../domain/entities/Category.dart';
import '../../../domain/enums/ActionImage.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc(this.GetCategoryByIdUseCase, this.GetCategoryByNameUseCase, this.GetAllCategoriesUseCase, this.CreateCategoryUseCase, this.UpdateCategoryUseCase, this.DeleteCategoryUseCase, this.FetchCategoriesByIdsUseCase) : super(CategoryInitial()) {
    on<GetAllCategoriesEvent>(_getAllCategories);
    on<GetCategoryByIdEvent>(_getCategoryById);
    on<GetCategoryByNameEvent>(_getCategoryByName);
    on<CreateCategoryEvent>(_createCategory);
    on<UpdateCategoryEvent>(_updateCategory);
    on<DeleteCategoryEvent>(_deleteCategory);
    on<SelectCategoryEvent>(_selectCategory);
    on<CategoryNameChanged>((event, emit) {
      emit(state.copyWith(CategoryName: event.name));
    });
on<ChangeIndex>((event, emit) {
      emit(state.copyWith(PageIndex: event.index));
    });
    on<throwError>((event, emit) {
      emit(state.copyWith(error: event.message));
    });
    on<ResetCategoryEvent>((event, emit) {
      emit(state.copyWith(Clonecategories: state.categories));
    });
    on<InitCategoryEvent>((event, emit) {
      emit(state.copyWith(SelectedCategories: []));
    });
    on<FetchCategoriesById>(_UpdateCategoriesEvent);
  }

  final getCategoryByIdUseCase GetCategoryByIdUseCase;
  final getCategoryByName GetCategoryByNameUseCase;
  final getAllCategoriesUseCase GetAllCategoriesUseCase;
  final createCategoryUseCase CreateCategoryUseCase;
  final updateCategoryUseCase UpdateCategoryUseCase;
  final deleteCategoryUseCase DeleteCategoryUseCase;
  final fetchCategoriesByIdsUseCase FetchCategoriesByIdsUseCase;


  void _getAllCategories(
      GetAllCategoriesEvent event,
      Emitter<CategoryState> emit
      ) async{
    emit(state.copyWith(isLoading: true));
    final result = await GetAllCategoriesUseCase(NoParams());
    emit(_mapFailureEither<List<Category>>((categories) => state.copyWith(categories: categories, Clonecategories: categories, isLoading: false), result));
  }


  CategoryState _mapFailureEither<T>(
      CategoryState Function(T) mapStateToSuccess,

      Either<Failure, T> either) {
    return either.fold(
          (failure) => state.copyWith(error: mapFailureToMessage(failure), isLoading: false),
          (act) => mapStateToSuccess(act),
    );
  }



  FutureOr<void> _getCategoryById(GetCategoryByIdEvent event, Emitter<CategoryState> emit)async {
    emit(state.copyWith(isLoading: true));
    final result = await GetCategoryByIdUseCase(event.id);
    emit(_mapFailureEither<Category>((category) => state.copyWith(category: category, isLoading: false), result));

  }

  Future<void> _getCategoryByName(GetCategoryByNameEvent event, Emitter<CategoryState> emit)async {
    if (event.name.isEmpty) {
      emit(state.copyWith(Clonecategories: state.categories));
      return;
    }
    emit(state.copyWith(isLoading: true));
    final result = await GetCategoryByNameUseCase(event.name);
    emit(_mapFailureEither<List<Category>>((categories) => state.copyWith(Clonecategories: categories, isLoading: false), result));
  }


  FutureOr<void> _createCategory(CreateCategoryEvent event, Emitter<CategoryState> emit)async {
    emit(state.copyWith(isLoading: true));
    final result = await CreateCategoryUseCase(event.category);
    emit(_mapFailureEither<Unit>((unit) => state.copyWith(isLoading: false,Clonecategories: [event.category,...state.Clonecategories]
    ,categories: [event.category,...state.categories]

    ), result));
  }


  FutureOr<void> _deleteCategory(DeleteCategoryEvent event, Emitter<CategoryState> emit) async{
    emit(state.copyWith(isLoading: true));
    final result = await DeleteCategoryUseCase(event.id);
    emit(_mapFailureEither<Unit>((unit) => state.copyWith(isLoading: false), result));

  }

  FutureOr<void> _updateCategory(UpdateCategoryEvent event, Emitter<CategoryState> emit)async {
    emit(state.copyWith(isLoading: true));
    final result = await UpdateCategoryUseCase(event.category);
    emit(_mapFailureEither<Unit>((unit) => state.copyWith(isLoading: false), result));
  }

  FutureOr<void> _selectCategory(SelectCategoryEvent event, Emitter<CategoryState> emit)async {
    if (event.actionImage == ActionImage.DELETE) {
  final cat =    state.SelectedCategories.where((element) => element.CategoryName != event.category.CategoryName).toList();
      emit(state.copyWith(SelectedCategories:  cat));

    } else {
      emit(state.copyWith(SelectedCategories: [...state.SelectedCategories, event.category]));
    }
  }

  FutureOr<void> _UpdateCategoriesEvent(FetchCategoriesById event, Emitter<CategoryState> emit)async {
    emit(state.copyWith(isLoading: true));
    final result = await FetchCategoriesByIdsUseCase(event.categories);
    emit(_mapFailureEither<List<Category>>((categories) => state.copyWith(SelectedCategories: categories, isLoading: false), result));
  }
}
