import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/scenario.dart';
import '../models/comment.dart';

class ApiService {
  static const String baseUrl = 'https://be-393047322674.asia-northeast3.run.app/api';
  static int? currentUserId;

  Future<Map<String, String>> _getHeaders() async {
    return {'Content-Type': 'application/json'};
  }

  // 인증 관련
  Future<Map<String, dynamic>> register(String email, String password, String nickname) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: await _getHeaders(),
      body: jsonEncode({'email': email, 'password': password, 'nickname': nickname}),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(utf8.decode(response.bodyBytes));
    }
    throw Exception('회원가입 실패: ${response.statusCode}');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: await _getHeaders(),
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      currentUserId = data['id']; // 서버에서 받은 userId 저장
      return data;
    }
    throw Exception('로그인 실패: ${response.statusCode}');
  }
  // 시나리오 및 답변 관련
  Future<List<Scenario>> getScenarios() async {
    final response = await http.get(Uri.parse('$baseUrl/scenarios'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((json) => Scenario.fromJson(json)).toList();
    }
    throw Exception('목록 조회 실패');
  }

  Future<Scenario> getScenarioById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/scenarios/$id'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      return Scenario.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    throw Exception('상세 조회 실패');
  }

  Future<List<Submission>> getSubmissions(int scenarioId) async {
    final response = await http.get(Uri.parse('$baseUrl/scenarios/$scenarioId/submissions'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((json) => Submission.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> createSubmission(int scenarioId, String content) async {
    print('제출 시도 - 유저 ID: $currentUserId');

    if (currentUserId == null) {
      throw Exception('로그인 정보가 없습니다. 다시 로그인해주세요.');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/scenarios/$scenarioId/submissions'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'content': content,
        'userAccountId': currentUserId, // 서버에서 요구하는 키값이 맞는지 확인
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  // 댓글 관련
  Future<List<Comment>> getComments(int submissionId) async {
    final response = await http.get(Uri.parse('$baseUrl/submissions/$submissionId/comments'), headers: await _getHeaders());
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(utf8.decode(response.bodyBytes));
      return body.map((json) => Comment.fromJson(json)).toList();
    }
    return [];
  }

  Future<bool> createComment(int submissionId, String content) async {
    if (currentUserId == null) return false;

    // 방식 A: 서버가 Body에 userId를 원하는 경우 (가장 흔함)
    final response = await http.post(
      Uri.parse('$baseUrl/submissions/$submissionId/comments'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'content': content,
        'userId': currentUserId, // 쿼리가 아닌 Body에 포함
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }
}