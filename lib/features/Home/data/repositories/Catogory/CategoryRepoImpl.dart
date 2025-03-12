import 'package:dartz/dartz.dart';
import 'package:jci_app/core/Handlers/Handler.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/core/error/Failure.dart';
import 'package:jci_app/features/Home/data/datasources/Category/CategoryLocalDataSource.dart';
import 'package:jci_app/features/Home/data/model/Category/CategotyModel.dart';
import 'package:jci_app/features/Home/domain/entities/Category.dart';
import 'package:jci_app/features/Home/domain/repsotories/CategoriesRepo.dart';

import '../../datasources/Category/CategoryRemoteDataSource.dart';

class CategoryRepoImpl implements CategoryRepo {
  final CategoryRemoteDataSource categoryRemoteDataSource;
  final CategoryLocalDataSource categoryLocalDataSource;
final Handler<Category> categorieHandler;
final Handler<List<Category>> categoriesHandler;
final Handler<Unit> unitHandler;
  CategoryRepoImpl(this.categorieHandler, this.categoriesHandler, this.unitHandler, {required this.categoryRemoteDataSource, required this.categoryLocalDataSource});

  @override
  Future<Either<Failure, Unit>> createCategory(Category category) async{
    return unitHandler.handle(onCall: ()async{
      final categorymodel=CategoryModel.fromEntity(category);
      await categoryLocalDataSource.createCategory(categorymodel);
     return await categoryRemoteDataSource.createCategory(categorymodel);



    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
throw e;
    });

  }

  @override
  Future<Either<Failure, Unit>> deleteCategory(String id)async {
    return unitHandler.handle(onCall: ()async{
      await categoryLocalDataSource.deleteCategory(id);
      return await categoryRemoteDataSource.deleteCategory(id);
    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
throw e;
    });
  }

  @override
  Future<Either<Failure, List<Category>>> getAllCategories() async{
    return categoriesHandler.handle(onCall: ()async{
      final local=await categoryLocalDataSource.getAllCategories();
      if (local.isNotEmpty) {
        return local.map((e) => e.toEntity()).toList();
      }
      final categories=await categoryRemoteDataSource.getAllCategories();
      await categoryLocalDataSource.cacheCategories(categories);
      return categories.map((e) => e.toEntity()).toList();
    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
throw e;
    });
  }

  @override
  Future<Either<Failure, Category>> getCategoryById(String id)async {
    return categorieHandler.handle(onCall: ()async{
      final local=await categoryLocalDataSource.getCategoryById(id);
      if (local.CategoryId.isNotEmpty) {
        return local.toEntity();
      }
      final category=await categoryRemoteDataSource.getCategoryById(id);
      return category.toEntity();
    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
throw e;
    });
  }

  @override
  Future<Either<Failure, List<Category>>> getCategoryByName(String name)async {
    return categoriesHandler.handle(onCall: ()async{

      final categories=await categoryRemoteDataSource.getCategoryByName(name);
      return categories.map((e) => e.toEntity()).toList();
    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
throw e;
    });
  }

  @override
  Future<Either<Failure, Unit>> updateCategory(Category category) async{
    return unitHandler.handle(onCall: ()async{
      final categorymodel=CategoryModel.fromEntity(category);
      await categoryLocalDataSource.createCategory(categorymodel);
      return await categoryRemoteDataSource.createCategory(categorymodel);
    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
throw e;
    });

  }

  @override
  Future<Either<Failure, List<Category>>> fetchCategoriesByIds(List<String> ids) async{
    return categoriesHandler.handle(onCall: ()async{

      final categories=await categoryRemoteDataSource.fetchCategoriesByIds(ids);
      return categories.map((e) => e.toEntity()).toList();
    }, onError: (e){
      if (e is Exception) {
        return e.get_failure;
      }
throw e;
    });

  }



}