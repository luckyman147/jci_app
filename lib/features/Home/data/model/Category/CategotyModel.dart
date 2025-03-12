import 'package:jci_app/features/Home/domain/entities/Category.dart';

class CategoryModel extends Category{
  CategoryModel({required super.CategoryName, required super.CategoryId, required super.Priority, required super.NumberOfActivities, required super.ActivityIds});

  factory CategoryModel.fromJson(Map<String, dynamic> json){
    return CategoryModel(
      CategoryName: json['CategoryName'],
      CategoryId: json['CategoryId'],
      Priority: json['Priority'],
      NumberOfActivities: json['NumberOfActivities'],
      ActivityIds: (json['ActivityIds'] as List<dynamic> ).map((e) => e.toString()).toList()
    );
  }
  /// to json
///
  Map<String, dynamic> toJson(){
    return {
      "ActivityIds": ActivityIds,
      "CategoryName": CategoryName,
      "CategoryId": CategoryId,
      "Priority": Priority,
      "NumberOfActivities": NumberOfActivities
    };
  }
  //from entity
  Category toEntity(){
    return Category(
        ActivityIds: ActivityIds,
      CategoryName: CategoryName,
      CategoryId: CategoryId,
      Priority: Priority,
      NumberOfActivities: NumberOfActivities
    );
  }
  //from entitya
  static CategoryModel fromEntity(Category category){
    return CategoryModel(
      ActivityIds: category.ActivityIds,
      CategoryName: category.CategoryName,
      CategoryId: category.CategoryId,
      Priority: category.Priority,
      NumberOfActivities: category.NumberOfActivities
    );
  }


}