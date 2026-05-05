import 'package:flutter/material.dart';
import '../core/api/api_service.dart';
import '../core/api/endpoints.dart';

class DashboardProvider extends ChangeNotifier {
  Map<String, dynamic>? data;
  bool isLoading = false;

  Future<void> fetchDashboard() async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await ApiService.get(Endpoints.dashboard);
      data = res;
    } catch (e) {
      rethrow;
    }

    isLoading = false;
    notifyListeners();
  }
}