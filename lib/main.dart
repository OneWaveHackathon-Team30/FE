import 'package:flutter/material.dart';
import 'screens/start_screen.dart';

void main() {
  runApp(const OneWaveApp());
}

class OneWaveApp extends StatelessWidget {
  const OneWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Wave',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Pretendard', // 프로젝트에 폰트가 설정되어 있다면 적용
        useMaterial3: true,
      ),
      home: const StartScreen(),
    );
  }
}