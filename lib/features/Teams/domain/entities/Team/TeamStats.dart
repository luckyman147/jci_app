class TeamStats {
  final int numberOfMembers;
  final int numberOfTasksTotal;
  final int numberOfTasksCompleted;

  const TeamStats({
    this.numberOfMembers = 0,
    this.numberOfTasksTotal = 0,
    this.numberOfTasksCompleted = 0,
  });

  TeamStats copyWith({
    int? numberOfMembers,
    int? numberOfTasksTotal,
    int? numberOfTasksCompleted,
  }) {
    return TeamStats(
      numberOfMembers: numberOfMembers ?? this.numberOfMembers,
      numberOfTasksTotal: numberOfTasksTotal ?? this.numberOfTasksTotal,
      numberOfTasksCompleted: numberOfTasksCompleted ?? this.numberOfTasksCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numberOfMembers': numberOfMembers,
      'numberOfTasksTotal': numberOfTasksTotal,
      'numberOfTasksCompleted': numberOfTasksCompleted,
    };
  }

  factory TeamStats.fromJson(Map<String, dynamic> json) {
    return TeamStats(
      numberOfMembers: json['numberOfMembers'] ?? 0,
      numberOfTasksTotal: json['numberOfTasksTotal'] ?? 0,
      numberOfTasksCompleted: json['numberOfTasksCompleted'] ?? 0,
    );
  }
}
