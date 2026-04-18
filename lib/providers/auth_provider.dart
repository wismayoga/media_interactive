import 'package:flutter/material.dart';
import '../core/api/api_service.dart';
import '../core/api/endpoints.dart';
import '../core/utils/token_storage.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? user;
  bool isLoading = false;

  bool get isLoggedIn => user != null;

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await ApiService.post(Endpoints.login, {
        "email": email,
        "password": password,
      });

      await TokenStorage.saveToken(res['token']);
      user = UserModel.fromJson(res['user']);
    } catch (e) {
      debugPrint("❌ LOGIN ERROR: $e");
      rethrow;
    } finally {
      // ✅ WAJIB: selalu stop loading
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMe() async {
    try {
      final res = await ApiService.get(Endpoints.me);

      user = UserModel.fromJson(res);

      notifyListeners();
    } catch (e) {
      debugPrint("FETCH ME ERROR: $e");
    }
  }

  Future<void> logout() async {
    isLoading = true;
    notifyListeners();

    try {
      await ApiService.post("/auth/logout", {});
      await TokenStorage.clear();
      user = null;
    } catch (e) {
      debugPrint("❌ LOGOUT ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
