import 'package:jci_app/features/Home/domain/entities/Category.dart';
import 'package:jci_app/features/auth/domain/usecases/USesCasesGlobal.dart';

abstract class CategoryRepo{
  Future<Either<Failure,List<Category>>> getAllCategories();
  Future<Either<Failure,Category>> getCategoryById(String id);
  Future<Either<Failure,Unit>> createCategory(Category category);
  Future<Either<Failure,Unit>> updateCategory(Category category);
  Future<Either<Failure,Unit>> deleteCategory(String id);
  Future<Either<Failure,List<Category>>> getCategoryByName(String name);
  Future<Either<Failure,List<Category>>> fetchCategoriesByIds(List<String> ids);
}