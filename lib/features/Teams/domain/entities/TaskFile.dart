class TaskFile {

  final String url;

  final String extension;
factory TaskFile.empty() {
    return TaskFile(
      url: '',
      extension: '',
    );
  }
  factory TaskFile.fromParameters({
    required String url,
    required String extension,
  }) {
    return TaskFile(
      url: url,
      extension: extension,
    );
  }
  TaskFile({
    required this.url,
    required this.extension,
  });
  TaskFile copyWith({
    String? url,
    String? extension,
  }) {
    return TaskFile(
      url: url ?? this.url,
      extension: extension ?? this.extension,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'extension': extension,
    };
  }
  factory TaskFile.fromJson(Map<String, dynamic> json) {
    return TaskFile(
      url: json['url'] as String,
      extension: json['extension'] as String,
    );}


  }