import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/app_models.dart';

class SaydoneApi {
  SaydoneApi({http.Client? client, this.baseUrl = 'http://10.0.2.2:8000/api/v1'}) : _client = client ?? http.Client();
  final http.Client _client;
  final String baseUrl;
  String? token;

  Map<String, String> get headers => {'Accept': 'application/json', 'Content-Type': 'application/json', if (token != null) 'Authorization': 'Bearer $token'};

  Future<SayDoneUser> login(String email, String password) async {
    final response = await _client.post(Uri.parse('$baseUrl/auth/login'), headers: headers, body: jsonEncode({'email': email, 'password': password}));
    _check(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    token = json['token'] as String;
    return SayDoneUser.fromJson(json['user'] as Map<String, dynamic>);
  }

  Future<SayDoneUser> register(String name, String email, String password) async {
    final response = await _client.post(Uri.parse('$baseUrl/auth/register'), headers: headers, body: jsonEncode({'name': name, 'email': email, 'password': password, 'password_confirmation': password}));
    _check(response);
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    token = json['token'] as String;
    return SayDoneUser.fromJson(json['user'] as Map<String, dynamic>);
  }

  Future<List<SayDoneTask>> tasks() async {
    final response = await _client.get(Uri.parse('$baseUrl/tasks'), headers: headers);
    _check(response);
    final data = (jsonDecode(response.body) as Map<String, dynamic>)['data'] as List<dynamic>? ?? [];
    return data.map((item) => SayDoneTask.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<SayDoneTask> createTask({required String title, String? transcription}) async {
    final response = await _client.post(Uri.parse('$baseUrl/tasks'), headers: headers, body: jsonEncode({'title': title, 'transcription': transcription}));
    _check(response);
    return SayDoneTask.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> updateTask(int id, {required String status}) async {
    final response = await _client.patch(Uri.parse('$baseUrl/tasks/$id'), headers: headers, body: jsonEncode({'status': status}));
    _check(response);
  }

  void _check(http.Response response) { if (response.statusCode < 200 || response.statusCode >= 300) throw SaydoneApiException('API error ${response.statusCode}: ${response.body}'); }
}

class SaydoneApiException implements Exception {
  const SaydoneApiException(this.message);
  final String message;
  @override
  String toString() => message;
}
