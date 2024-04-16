import 'package:jci_app/features/about_jci/Domain/entities/President.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PresidentModel extends President {



  factory PresidentModel.fromJson(Map<String, dynamic> json) =>
  PresidentModel(
    id: json['id']??json['_id'],
    name: json['name'],
    CoverImage: json['CoverImage'],
    year: json['year'],
  );

  PresidentModel({
required String id ,
    required String name,
    required String CoverImage,
    required String year,
  }) : super(
    id: id,
    name: name,
    CoverImage: CoverImage,
    year: year,
  );
  factory PresidentModel.fromEntity(President president) {
    return PresidentModel(
      name: president.name,
      CoverImage: president.CoverImage,
      year: president.year, id: president.id,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'CoverImage': CoverImage,
    'year': year,
  };
}


