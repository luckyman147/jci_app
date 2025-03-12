import 'package:dartz/dartz.dart';
import 'package:jci_app/core/config/services/categoryStore.dart';
import 'package:jci_app/core/error/Exception.dart';

import '../../model/Category/CategotyModel.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel> getCategoryById(String id);
  Future<List<CategoryModel>> getCategoryByName(String name);

  Future<Unit >createCategory(CategoryModel categorymodel) ;


  Future<Unit > deleteCategory(String id) ;

  Future<Unit> cacheCategories(List<CategoryModel> categories) ;
  }
class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  @override
  Future<List<CategoryModel>> getAllCategories() async{
    final json=await CategoryStore.getCategories();
    if (json.isNotEmpty ) {
      return json;
    }
    return [];
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async{
    final json=await CategoryStore.getCategory();
    if (json.CategoryId.isNotEmpty ) {
      return json;
    }
    throw NotFoundException();
  }

  @override
  Future<List<CategoryModel>> getCategoryByName(String name)async {
    final json=await CategoryStore.getCategories();
    if (json.isNotEmpty ) {
      return json;
    }
    return [];
  }

  @override
  Future<Unit> createCategory(CategoryModel categorymodel)  async {
    try {
      final categories=await CategoryStore.getCategories();
      categories.add(categorymodel);
      await CategoryStore.setCategories(categories);
      return unit;
    } catch (error) {
      throw ServerException();
    }

  }

  @override
  Future<Unit> deleteCategory(String id) async{
    try {
      final categories=await CategoryStore.getCategories();
      categories.removeWhere((element) => element.CategoryId==id);
      await CategoryStore.setCategories(categories);
      return unit;
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<Unit> cacheCategories(List<CategoryModel> categories) async{
    try {
      await CategoryStore.setCategories(categories);
      return unit;
    } catch (error) {
      throw ServerException();
    }
  }
}