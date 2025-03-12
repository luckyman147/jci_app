import 'dart:convert';

import 'package:jci_app/features/Home/data/model/Category/CategotyModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryStore{
  const  CategoryStore._();
  static const String _category = 'category';
  static const String _categories = 'categories';
  static const String _categoryTimestampKey = 'categoryTimestamp'; // Key for storing the timestamp
  static String _categoryByIdKey(String id) => 'Category$id';

static   Future<void> setCategory(CategoryModel category) async {
    final pref=await SharedPreferences.getInstance();
    final json = category.toJson();
    await pref.setString(_category, jsonEncode(json));

  }
  static Future<CategoryModel> getCategory() async {
    final pref=await SharedPreferences.getInstance();
    final category = pref.getString(_category);
    if(category!=null){
      return CategoryModel.fromJson(jsonDecode(category));
    }
    return CategoryModel(CategoryName: '', CategoryId: '', NumberOfActivities: 0, Priority: 0, ActivityIds: []);
  }
  static Future<void> removeCategory() async {
    final pref=await SharedPreferences.getInstance();
    await pref.remove(_category);
  }
  //get categories
  static Future<List<CategoryModel>> getCategories() async {
    final pref=await SharedPreferences.getInstance();
    final category = pref.getString(_categories);
//get time stamp
    final timestamp = pref.getInt(_categoryTimestampKey);
    if(timestamp!=null && DateTime.now().millisecondsSinceEpoch-timestamp<const Duration(minutes: 15).inMilliseconds){
      if(category!=null){
        List<dynamic>categoriesJson=jsonDecode(category);
        return categoriesJson.map((e) => CategoryModel.fromJson(e)).toList();
      }
        return [];
    }

    return [];
  }
  //set categories
  static Future<void> setCategories(List<CategoryModel> categories) async {
    final pref=await SharedPreferences.getInstance();
    //time stamp 15 minue
    await pref.setInt(_categoryTimestampKey, DateTime.now().millisecondsSinceEpoch);

    //convert to list of string
    final json = categories.map((e) => e.toJson()).toList();
    await pref.setString(_categories,jsonEncode(json) );
  }
}