import 'package:flutter/material.dart';
import '../core/api/api_service.dart';
import '../core/api/endpoints.dart';
import '../models/materi_model.dart';

class MateriProvider extends ChangeNotifier {
  List<MateriModel> materi = [];
  bool isLoading = false;

  Future<void> fetchMateri() async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await ApiService.get(Endpoints.materi);

      materi = (res['data'] as List)
          .map((e) => MateriModel.fromJson(e))
          .where((m) => m.type?.toLowerCase() == "materi") // 🔥 FILTER
          .toList();

      // 🔥 TARUH DI SINI
      for (var m in materi) {
        debugPrint("MATERI: ${m.title} | TYPE: ${m.type}");
      }
    } catch (e) {
      debugPrint("ERROR: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
