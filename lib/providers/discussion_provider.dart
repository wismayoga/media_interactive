import 'package:flutter/material.dart';
import '../core/api/api_service.dart';

class DiscussionProvider extends ChangeNotifier {
  List<dynamic> messages = [];
  bool isLoading = false;

  Future<void> fetchMessages(int groupId) async {
    isLoading = true;
    notifyListeners();

    try {
      final res = await ApiService.get("/discussion-groups/$groupId/messages");

      final data = res['messages'] ?? [];

      messages = List.from(data).reversed.toList();

      debugPrint("TOTAL MSG: ${messages.length}");
    } catch (e) {
      debugPrint("ERROR: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> sendMessage(int groupId, String message) async {
    try {
      await ApiService.post("/discussion-groups/$groupId/messages", {
        "message": message,
      });

      await fetchMessages(groupId); // refresh
    } catch (e) {
      debugPrint("SEND ERROR: $e");
    }
  }
}
