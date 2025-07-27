class OnlineSettings {
  final bool isOnline;
  final String googleMeetLink;

  const OnlineSettings({
    required this.isOnline,
    required this.googleMeetLink,
  });
  OnlineSettings copyWith({
    bool? isOnline,
    String? googleMeetLink,
  }) {
    return OnlineSettings(
      isOnline: isOnline ?? this.isOnline,
      googleMeetLink: googleMeetLink ?? this.googleMeetLink,
    );
  }
  factory OnlineSettings.fromJson(Map<String, dynamic> json) {
    return OnlineSettings(
      isOnline: json['isOnline'] ?? false,
      googleMeetLink: json['googleMeetLink'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isOnline': isOnline,
      'googleMeetLink': googleMeetLink,
    };
  }
}
