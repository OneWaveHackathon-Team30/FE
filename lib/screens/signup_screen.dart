import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], //
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF212121)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '회원가입',
          style: TextStyle(
            color: Color(0xFF212121),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0), //
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더 텍스트
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(text: '새로운 시작을 위해\n'),
                    TextSpan(
                      text: '정보를 입력',
                      style: TextStyle(color: Color(0xFF7C4DFF)),
                    ),
                    TextSpan(text: '해주세요'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '간편하게 가입하고 모든 서비스를 이용해보세요.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // 이메일 입력 필드
              _buildLabel('이메일'),
              CareerTextField(
                controller: _emailController,
                hintText: 'example@domain.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // 비밀번호 입력 필드
              _buildLabel('비밀번호'),
              CareerTextField(
                controller: _passwordController,
                hintText: '8~16자 영문, 숫자 조합',
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
              const SizedBox(height: 20),

              // 비밀번호 확인 필드
              _buildLabel('비밀번호 확인'),
              CareerTextField(
                controller: _confirmPasswordController,
                hintText: '비밀번호를 한번 더 입력해주세요',
                obscureText: !_isConfirmPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: Colors.grey[400],
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                ),
              ),
              const SizedBox(height: 20),

              // 닉네임 입력 필드
              _buildLabel('닉네임'),
              CareerTextField(
                controller: _nicknameController,
                hintText: '사용하실 닉네임을 입력해주세요',
              ),
              const SizedBox(height: 24),

              // 이용약관 동의 (기존 로직 유지)
              _buildTermsCheckbox(),
              const SizedBox(height: 32),

              // 가입 완료하기 버튼
              CareerButton(
                text: '가입 완료하기',
                onPressed: _agreeToTerms
                    ? () async {
                  try {
                    // 1. Firebase 계정 생성
                    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );

                    // 2. 백엔드 서버 연동 (서버가 아직 준비되지 않았다면 이 부분을 주석 처리하세요)
                    // try {
                    //   final apiService = ApiService();
                    //   await apiService.loginWithNickname(_nicknameController.text.trim());
                    // } catch (serverError) {
                    //   print('서버 저장 실패: $serverError');
                    //   // 서버 저장에 실패해도 가입은 됐으므로 진행하거나 사용자에게 알림
                    // }

                    // 3. 성공 알림 및 화면 전환
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('회원가입이 완료되었습니다!')),
                    );
                    Navigator.pop(context); // 로그인 화면으로 돌아가기

                  } catch (e) {
                    // 에러 발생 시 로그 출력 및 사용자 알림
                    print('회원가입 실패 원인: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('가입 실패: ${e.toString()}')),
                    );
                  }
                }
                    : null,
              ),
              const SizedBox(height: 24),

              // 로그인 링크
              _buildLoginLink(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // 반복되는 라벨 위젯
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF212121)),
      ),
    );
  }

  // 이용약관 체크박스 위젯
  Widget _buildTermsCheckbox() {
    return InkWell(
      onTap: () => setState(() => _agreeToTerms = !_agreeToTerms),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: _agreeToTerms ? const Color(0xFF7C4DFF) : Colors.white,
                border: Border.all(
                  color: _agreeToTerms ? const Color(0xFF7C4DFF) : Colors.grey[300]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: _agreeToTerms ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  children: const [
                    TextSpan(text: '이용약관', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF212121), decoration: TextDecoration.underline)),
                    TextSpan(text: ' 및 '),
                    TextSpan(text: '개인정보 처리방침', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF212121), decoration: TextDecoration.underline)),
                    TextSpan(text: '에 모두 동의합니다.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 하단 로그인 링크 위젯
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('이미 계정이 있으신가요?  ', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Text(
            '로그인',
            style: TextStyle(fontSize: 14, color: Color(0xFF7C4DFF), fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}