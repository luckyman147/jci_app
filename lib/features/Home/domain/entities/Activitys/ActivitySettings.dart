class ActivitySettings {
  final int activityPoints;
  final List<String> categoryIds;
  final bool isPaid;
  final int price;
  final bool isPublic;

  const ActivitySettings({
    required this.activityPoints,
    required this.categoryIds,
    required this.isPaid,
    required this.price,
    required this.isPublic,
  });
  ActivitySettings copyWith({
    int? activityPoints,
    List<String>? categoryIds,
    bool? isPaid,
    int? price,
    bool? isPublic,
  }) {
    return ActivitySettings(
      activityPoints: activityPoints ?? this.activityPoints,
      categoryIds: categoryIds ?? this.categoryIds,
      isPaid: isPaid ?? this.isPaid,
      price: price ?? this.price,
      isPublic: isPublic ?? this.isPublic,
    );
  }
  factory ActivitySettings.fromJson(Map<String, dynamic> json) {
    return ActivitySettings(
      activityPoints: json['activityPoints'] ?? 0,
      categoryIds: List<String>.from(json['categoryIds'] ?? []),
      isPaid: json['isPaid'] ?? false,
      price: json['price'] ?? 0,
      isPublic: json['isPublic'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activityPoints': activityPoints,
      'categoryIds': categoryIds,
      'isPaid': isPaid,
      'price': price,
      'isPublic': isPublic,
    };
  }

}
