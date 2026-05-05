class QuizModel {
  final int id;
  final String title;
  final String description;
  final String? type;
  final bool isFinished;
  final double? score;
  final bool isLocked;

  QuizModel({
    required this.id,
    required this.title,
    required this.description,
    this.type,
    required this.isFinished,
    this.score,
    required this.isLocked,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      type: json['type'],
      isFinished: json['is_finished'] ?? false,
      score: json['score'] != null
          ? double.tryParse(json['score'].toString())
          : null,
      isLocked: json['is_locked'] ?? false,
    );
  }
}