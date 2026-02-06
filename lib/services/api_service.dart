import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080/api'; // 에뮬레이터 환경

  Future<void> loginWithNickname(String nickname) async {
    // 1. Firebase에서 최신 ID 토큰 가져오기
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('로그인된 사용자가 없습니다.');

    String? idToken = await user.getIdToken();

    // 2. URL 생성 (쿼리 파라미터 포함)
    // 결과 예시: http://10.0.2.2:8080/api/auth/login?nickname=사용자닉네임
    final url = Uri.parse('$baseUrl/auth/login').replace(
      queryParameters: {'nickname': nickname},
    );

    // 3. POST 요청 보내기
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $idToken', // 헤더에 토큰 포함
      },
    );

    if (response.statusCode == 200) {
      print('서버 연동 성공: ${response.body}');
    } else {
      print('서버 연동 실패: ${response.statusCode}');
      throw Exception('서버 로그인에 실패했습니다.');
    }
  }
}