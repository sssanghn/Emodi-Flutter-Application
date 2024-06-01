import 'package:flutter/material.dart';

class MyEmotionAnalysisPage extends StatefulWidget {
  const MyEmotionAnalysisPage({super.key});

  @override
  State<MyEmotionAnalysisPage> createState() => _MyEmotionAnalysisPageState();
}

class _MyEmotionAnalysisPageState extends State<MyEmotionAnalysisPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
              context
            );
          },
            icon: Icon(Icons.arrow_back)
        ),
        title: Text(
          '감정 분석',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
