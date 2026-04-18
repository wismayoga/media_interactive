import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_storage.dart';

class ApiService {
  static const String baseUrl = "http://rakitanku.xyz/api";

  static String get baseDomain {
    return baseUrl.replaceAll("/api", "");
  }

  static Future<Map<String, String>> _headers() async {
    final token = await TokenStorage.getToken();

    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      if (token != null) "Authorization": "Bearer $token",
    };
  }

  static Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
    );

    return _handleResponse(response);
  }

  static Future<dynamic> post(String endpoint, dynamic data) async {
    final response = await http.post(
      Uri.parse("$baseUrl$endpoint"),
      headers: await _headers(),
      body: jsonEncode(data),
    );

    return _handleResponse(response);
  }

  static dynamic _handleResponse(http.Response response) {
    print("=== API RESPONSE ===");
    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");

    final body = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      throw Exception(body['message'] ?? "API Error");
    }
  }
}
