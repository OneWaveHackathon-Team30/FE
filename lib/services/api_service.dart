import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/scenario.dart';
import '../models/comment.dart';

class ApiService {
  static const String baseUrl = 'https://be-393047322674.asia-northeast3.run.app/api';

  // 인증 토큰 로직 제거
  Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
    };
  }

  // syncAccountWithBackend 메서드 제거 (로그인이 없으므로 불필요)

  Future<List<Scenario>> getScenarios() async {
    final response = await http.get(
      Uri.parse('$baseUrl/scenarios'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((json) => Scenario.fromJson(json)).toList();
    } else {
      throw Exception('시나리오 목록을 불러오지 못했습니다.');
    }
  }

  Future<Scenario> getScenarioById(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/scenarios/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return Scenario.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      throw Exception('상세 정보를 불러오지 못했습니다.');
    }
  }

  Future<List<Submission>> getSubmissions(int scenarioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/scenarios/$scenarioId/submissions'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((json) => Submission.fromJson(json)).toList();
    } else {
      throw Exception('답변 목록을 불러오지 못했습니다.');
    }
  }

  Future<bool> createSubmission(int scenarioId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/scenarios/$scenarioId/submissions'),
      headers: await _getHeaders(),
      body: jsonEncode({'content': content}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<void> adoptSubmission(int scenarioId, int submissionId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/scenarios/$scenarioId/submissions/$submissionId/adopt'),
      headers: await _getHeaders(),
    );
    if (response.statusCode != 200) throw Exception('채택에 실패했습니다.');
  }

  Future<List<Comment>> getComments(int submissionId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/submissions/$submissionId/comments'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('댓글을 불러오지 못했습니다.');
    }
  }

  Future<bool> createComment(int submissionId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/submissions/$submissionId/comments'),
      headers: await _getHeaders(),
      body: jsonEncode({'content': content}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}