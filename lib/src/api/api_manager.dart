import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiManager {
  final String baseUrl;

  ApiManager(this.baseUrl);

  Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
    return response;
  }

  Future<http.Response> get(String endpoint, Map<String, String> params) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
    final response = await http.get(uri);
    return response;
  }

  Future<http.Response> getUserData(String endpoint,
      [Map<String, String>? params]) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(queryParameters: params);
    final response = await http.get(uri);
    return response;
  }
}
