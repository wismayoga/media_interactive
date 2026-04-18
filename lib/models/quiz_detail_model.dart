import 'package:media_interactive/models/quiz_model.dart';

class QuizDetailModel {
  final int id;
  final String title;
  final String description;
  final List<QuizModel> questions;

  QuizDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
  });

  factory QuizDetailModel.fromJson(Map<String, dynamic> json) {
    return QuizDetailModel(
      id: json['quiz']['id'],
      title: json['quiz']['title'],
      description: json['quiz']['description'] ?? '',
      questions: (json['quiz']['questions'] as List)
          .map((e) => QuizModel.fromJson(e))
          .toList(),
    );
  }
}