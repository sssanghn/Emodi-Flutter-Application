import 'package:flutter/material.dart';
import 'package:emodi/Auth/explanation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 초기화 보장
  await Future.delayed(const Duration(seconds: 1)); // 1초 지연
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ExplanationPage(),
    );
  }
}