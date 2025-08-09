class Task {
  final String originalKey;
  final String practiceName;
  final List<Map<String, String>> details;
  final bool isSolved;
  final int level;

  Task({
    required this.originalKey,
    required this.practiceName,
    required this.details,
    this.isSolved = false,
    required this.level,
  });

  Task copyWith({
    String? originalKey,
    String? practiceName,
    List<Map<String, String>>? details,
    bool? isSolved,
    int? level,
  }) {
    return Task(
      originalKey: originalKey ?? this.originalKey,
      practiceName: practiceName ?? this.practiceName,
      details: details ?? this.details,
      isSolved: isSolved ?? this.isSolved,
      level: level ?? this.level,
    );
  }

  factory Task.fromJson(
      Map<String, dynamic> json, String practiceName, String originalKey) {
    return Task(
      originalKey: originalKey,
      practiceName: practiceName,
      details: List<Map<String, String>>.from(
        json["details"].map((item) => Map<String, String>.from(item)),
      ),
      isSolved: json["isSolved"] as bool? ?? false,
      level: json["level"] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        "details": details,
        "isSolved": isSolved,
        "level": level,
      };
}
