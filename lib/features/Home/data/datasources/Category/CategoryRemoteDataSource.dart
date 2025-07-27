import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:jci_app/core/error/Exception.dart';
import 'package:jci_app/features/Home/data/model/Category/CategotyModel.dart';
import 'package:logger/logger.dart';


abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getAllCategories();
  Future<CategoryModel> getCategoryById(String id);
  Future<Unit> createCategory(CategoryModel category);
  Future<Unit> updateCategory(CategoryModel category);
  Future<Unit> deleteCategory(String id);
  Future<Unit> UpdateNumberOfActivities(String id);
  Future<List<CategoryModel>> getCategoryByName(String name);
  Future<List<CategoryModel>> fetchCategoriesByIds(List<String> ids);
}
class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  CategoryRemoteDataSourceImpl(this._firestore);
  @override
  Future<List<CategoryModel>> fetchCategoriesByIds(List<String> ids) async {
    List<CategoryModel> categories = [];

    // Check if the list of IDs is not empty
    if (ids.isNotEmpty) {
      try {
        // Fetch categories where document ID is in the provided list of IDs
        QuerySnapshot snapshot = await _firestore
            .collection('categories') // Replace with your collection name
            .where(FieldPath.documentId, whereIn: ids)
            .get();

        // Map the documents to Category objects
        for (var doc in snapshot.docs) {
          categories.add(CategoryModel.fromJson(doc.data() as Map<String, dynamic>, ));
        }
      } catch (e) {
        // Handle the error
        throw ServerException();
      }
    }

    return categories;
  }

  @override
  Future<Unit> createCategory(CategoryModel category) async {
    try {
      final docRef = _firestore.collection('categories').doc(category.CategoryId.isEmpty ? null : category.CategoryId);

      // Update the `id` field in the document data
      final categoryData = category.toJson();
      categoryData['CategoryId'] = docRef.id;

      // Save the document with the updated `id`
      await docRef.set(categoryData);
      return unit;
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deleteCategory(String id) async {
    try {
      await _firestore.collection('categories').doc(id).delete();
      return unit;
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final querySnapshot = await _firestore.collection('categories').get();
      return querySnapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    } catch (error) {
      Logger().e("An error occurred while fetching all categories: $error");
      throw ServerException();
    }
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    try {
      final docSnapshot = await _firestore.collection('categories').doc(id).get();
      if (docSnapshot.exists) {
        return CategoryModel.fromJson(docSnapshot.data()!);
      } else {
        throw NotFoundException();
      }
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<List<CategoryModel>> getCategoryByName(String name) async {
    try {
      final querySnapshot = await _firestore
          .collection('categories')
          .where('CategoryName', isEqualTo:name)


      // Assuming `name` is a field
          .get();
      return querySnapshot.docs
          .map((doc) => CategoryModel.fromJson(doc.data()))
          .toList();
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updateCategory(CategoryModel category) async {
    try {
      await _firestore
          .collection('categories')
          .doc(category.CategoryId) // Assuming `id` is a property of `CategoryModel`
          .update(category.toJson());
      return unit;
    } catch (error) {
      throw ServerException();
    }
  }

    @override
    Future<Unit> UpdateNumberOfActivities(String id) async{
      try {
        final docSnapshot = await _firestore.collection('categories').doc(id).get();
        if (docSnapshot.exists) {

          int currentNumberOfActivities = docSnapshot.data()?['numberOfActivities'] ?? 0;

          // Increment the number of activities by 1
          await _firestore.collection('categories').doc(id).update({
            'numberOfActivities': currentNumberOfActivities + 1,
          });

          return unit;
        } else {
          throw NotFoundException();
        }
      } catch (error) {
        throw ServerException();

    }
  }}
