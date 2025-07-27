class ParticipationStatus {
  final List<String> participants;
  final bool isPart;
  bool tempPart;

  ParticipationStatus({
    required this.participants,
    required this.isPart,
    this.tempPart = false,
  });

  ParticipationStatus copyWith({
    List<String>? participants,
    bool? isPart,
    bool? tempPart,
  }) {
    return ParticipationStatus(
      participants: participants ?? this.participants,
      isPart: isPart ?? this.isPart,
      tempPart: tempPart ?? this.tempPart,
    );
  }

  factory ParticipationStatus.fromJson(Map<String, dynamic> json) {
    return ParticipationStatus(
      participants: List<String>.from(json['participants'] ?? []),
      isPart: json['isPart'] ?? false,
      tempPart: json['tempPart'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'isPart': isPart,
      'tempPart': tempPart,
    };
  }
}
