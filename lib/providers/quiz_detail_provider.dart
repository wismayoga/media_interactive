import 'package:flutter/foundation.dart';
import 'package:media_interactive/core/api/api_service.dart';
import 'package:media_interactive/core/api/endpoints.dart';
import 'package:media_interactive/models/quiz_detail_model.dart';

class QuizDetailProvider extends ChangeNotifier {
  QuizDetailModel? quiz;
  bool isLoading = false;

  Map<int, String> answers = {};

  Future<void> fetchDetail(int id) async {
    isLoading = true;
    notifyListeners();

    final res = await ApiService.get(Endpoints.quizDetail(id));
    quiz = QuizDetailModel.fromJson(res);

    isLoading = false;
    notifyListeners();
  }

  void setAnswer(int questionId, String answer) {
    answers[questionId] = answer;
    notifyListeners();
  }

  Future<double> submit(int quizId) async {
    final res = await ApiService.post(
      Endpoints.quizSubmit(quizId),
      {
        "answers": answers,
      },
    );

    return double.parse(res['nilai'].toString());
  }
}