class AttemptModel {
  final int id;
  final int quizId;
  final String quizTitle;
  final double score;
  final String createdAt;

  AttemptModel({
    required this.id,
    required this.quizId,
    required this.quizTitle,
    required this.score,
    required this.createdAt,
  });

  factory AttemptModel.fromJson(Map<String, dynamic> json) {
    return AttemptModel(
      id: json['id'],
      quizId: json['quiz_id'],
      quizTitle: json['quiz']['title'],
      score: double.tryParse(json['score'].toString()) ?? 0,
      createdAt: json['created_at'],
    );
  }
}