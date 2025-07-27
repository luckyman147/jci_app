class ActivityBasics {
  final String id;
  final String name;
  final String description;
  final DateTime activityBeginDate;
  final DateTime activityEndDate;
  final String activityAdress;
  final List<String> coverImages;

  ActivityBasics({
    required this.id,
    required this.name,
    required this.description,
    required this.activityBeginDate,
    required this.activityEndDate,
    required this.activityAdress,
    required this.coverImages,
  });

  /// Copy with
  ActivityBasics copyWith({
    String? id,
    String? name,
    String? description,
    DateTime? activityBeginDate,
    DateTime? activityEndDate,
    String? activityAdress,
    List<String>? coverImages,
  }) {
    return ActivityBasics(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      activityBeginDate: activityBeginDate ?? this.activityBeginDate,
      activityEndDate: activityEndDate ?? this.activityEndDate,
      activityAdress: activityAdress ?? this.activityAdress,
      coverImages: coverImages ?? this.coverImages,
    );
  }

  /// From JSON
  factory ActivityBasics.fromJson(Map<String, dynamic> json) {
    return ActivityBasics(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      activityBeginDate: DateTime.parse(json['activityBeginDate'] ?? json['ActivityBeginDate'] ?? DateTime.now().toIso8601String()),
      activityEndDate: DateTime.parse(json['activityEndDate'] ?? json['ActivityEndDate'] ?? DateTime.now().toIso8601String()),
      activityAdress: json['activityAdress'] ?? json['ActivityAdress'] ?? '',
      coverImages: List<String>.from(json['coverImages'] ?? json['CoverImages'] ?? []),
    );
  }

  /// To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'activityBeginDate': activityBeginDate.toIso8601String(),
      'activityEndDate': activityEndDate.toIso8601String(),
      'activityAdress': activityAdress,
      'coverImages': coverImages,
    };
  }
}
