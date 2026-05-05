import 'package:flutter/material.dart';
import '../core/api/api_service.dart';

class QuizProvider extends ChangeNotifier {
  List quizList = [];
  List questions = [];
  bool isLoading = false;

  Future<void> fetchQuiz(String type) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await ApiService.get("/siswa/quiz");

      quizList = (res as List).where((q) => q['type'] == type).toList();
    } catch (e) {
      debugPrint("ERROR: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> fetchSoal(int quizId) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await ApiService.get("/siswa/quiz/$quizId");

      questions = res['quiz']['questions'];
    } catch (e) {
      debugPrint("ERROR: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<dynamic> submitJawaban(int quizId, Map<int, String> jawaban) async {
    try {
      // 🔥 CONVERT KEY KE STRING
      final fixedJawaban = jawaban.map(
        (key, value) => MapEntry(key.toString(), value),
      );

      final res = await ApiService.post("/siswa/quiz/$quizId/submit", {
        "answers": fixedJawaban,
      });

      return res;
    } catch (e) {
      rethrow;
    }
  }
}
