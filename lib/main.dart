import 'package:flutter/material.dart';
import 'screens/start_screen.dart';
// import 'package:google_fonts/google_fonts.dart';

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
        useMaterial3: true,
        fontFamily: 'Pretendard',
      ),
      home: const StartScreen(),
    );
  }
}