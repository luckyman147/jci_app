class CheckList{
  final String id;
  final  String name;


  final  bool isCompleted;

  CheckList({required this.name,
    required this.id,

   required this.isCompleted});
  CheckList copyWith({
    String? id,
    String? name,
    bool? isCompleted,
  }) {
    return CheckList(
      id: id ?? this.id,
      name: name ?? this.name,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isCompleted': isCompleted,
    };
  }
  factory CheckList.fromJson(Map<String, dynamic> json) {
    return CheckList(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
    );
  }


}