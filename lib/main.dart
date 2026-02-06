import 'package:flutter/material.dart';
import 'package:onewave_fe/screens/start_screen.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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