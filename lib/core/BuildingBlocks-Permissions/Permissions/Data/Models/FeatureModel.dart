import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/Entities/Feature.dart';

class FeatureModel extends Feature{
  FeatureModel({required super.featureId, required super.description, required super.featureName, required super.updatedAt, required super.createdAt});
  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'featureId': featureId,
      'description': description,
      'featureName': featureName,
      'updatedAt': updatedAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // From JSON/Map
  factory FeatureModel.fromMap(Map<String, dynamic> map) {
    try {
      // Helper function to parse dates from either String or Timestamp
      DateTime _parseDate(dynamic date) {
        if (date is String) {
          return DateTime.parse(date);
        } else if (date is Timestamp) {
          return date.toDate();
        }
        else if (date ==null){
         return DateTime.now();
        }
        return DateTime.now();
      }

      return FeatureModel(
        featureId: map['featureId'] as String? ?? '', // Handle null with default
        description: map['description'] as String? ?? '', // Handle null with default
        featureName: map['featureName'] as String? ?? '', // Handle null with default
        updatedAt: _parseDate(map['updatedAt']),
        createdAt: _parseDate(map['createdAt']),
      );
    } catch (e) {
      throw FormatException('Failed to parse FeatureModel: $e');
    }
  }

  // From Entity (assuming Feature is the parent class)
  factory FeatureModel.fromEntity(Feature feature) {
    return FeatureModel(
      featureId: feature.featureId,
      description: feature.description,
      featureName: feature.featureName,
      updatedAt: feature.updatedAt,
      createdAt: feature.createdAt,
    );
  }

}