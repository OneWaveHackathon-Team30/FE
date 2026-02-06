import 'package:flutter/material.dart';
import '../widgets/common_widgets.dart';
import '../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CareerTextField(controller: _emailController, hintText: '이메일'),
            const SizedBox(height: 16),
            CareerTextField(controller: _passwordController, hintText: '비밀번호', obscureText: true),
            const SizedBox(height: 16),
            CareerTextField(controller: _nicknameController, hintText: '닉네임'),
            const SizedBox(height: 32),
            CareerButton(
              text: _isLoading ? '처리 중...' : '가입 완료하기',
              onPressed: _isLoading ? null : () async {
                setState(() => _isLoading = true);
                try {
                  await ApiService().register(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                    _nicknameController.text.trim(),
                  );
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('회원가입 성공!')));
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                } finally {
                  setState(() => _isLoading = false);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}