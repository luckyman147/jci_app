import 'package:dartz/dartz.dart';

import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/core/usescases/usecase.dart';

import '../entities/Category.dart';
import '../repsotories/CategoriesRepo.dart';

class getAllCategoriesUseCase extends UseCase<List<Category>,NoParams> {
  final CategoryRepo repository;

  getAllCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(NoParams params)async {
    return  await repository.getAllCategories();
  }

}
class getCategoryByIdUseCase extends UseCase<Category,String> {
  final CategoryRepo repository;

  getCategoryByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Category>> call(String params)async {
    return  await repository.getCategoryById(params);
  }

}
class createCategoryUseCase extends UseCase<Unit,Category> {
  final CategoryRepo repository;

  createCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Category params)async {
    return  await repository.createCategory(params);
  }

}
class updateCategoryUseCase extends UseCase<Unit,Category> {
  final CategoryRepo repository;

  updateCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Category params)async {
    return  await repository.updateCategory(params);
  }


}
class deleteCategoryUseCase extends UseCase<Unit,String> {
  final CategoryRepo repository;

  deleteCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String params)async {
    return  await repository.deleteCategory(params);
  }

}
class getCategoryByName extends UseCase<List<Category>,String> {
  final CategoryRepo repository;

  getCategoryByName(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(String params)async {
    return  await repository.getCategoryByName(params);
  }

}
class fetchCategoriesByIdsUseCase extends UseCase<List<Category>,List<String>> {
  final CategoryRepo repository;

  fetchCategoriesByIdsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Category>>> call(List<String> params)async {
    return  await repository.fetchCategoriesByIds(params);
  }

}