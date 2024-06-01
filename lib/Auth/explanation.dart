import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emodi/constants.dart';
import 'package:emodi/Auth/create.dart';
import 'package:page_transition/page_transition.dart';
import 'package:emodi/Auth/login.dart';
import 'package:http/http.dart' as http;
import '../root_page.dart';
import 'package:emodi/Auth/create.dart';

class ExplanationPage extends StatefulWidget {
  const ExplanationPage({Key? key}) : super(key: key);

  @override
  State<ExplanationPage> createState() => _ExplanationPageState();
}

class _ExplanationPageState extends State<ExplanationPage> {
  int currentPage = 0; // 현재 페이지 인덱스를 추적하는 변수

  List<String> pageTexts = [
    'What\'s your Emotion?',
    '페이지 2 문구',
    '페이지 3 문구',
    '페이지 4 문구',
  ];

  late bool isInstalled;
  @override
  // 초기화
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Emo',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.0,
                    color: Constants.primaryColor,
                    fontSize: 30,
                  ),
                ),
                Text(
                  'Di',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1.0,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Container(
                  height: 300,
                  child: PageView(
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index; // 현재 페이지 업데이트
                      });
                    },
                    children: [
                      Image.asset('assets/app_icon.png'),
                      Image.asset('assets/app_icon.png'),
                      Image.asset('assets/app_icon.png'),
                      Image.asset('assets/app_icon.png')
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  pageTexts[currentPage], // 현재 페이지에 해당하는 텍스트 표시
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 25,
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 4; i++)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: i == currentPage
                              ? Constants.primaryColor
                              : Colors.grey,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatePage()),
                );
              },
              child: Container(
                width: 250,
                decoration: BoxDecoration(
                  color: Constants.primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Center(
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '이미 계정이 있으신가요?',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: LoginPage(),
                            type: PageTransitionType.bottomToTop,
                            duration: Duration(milliseconds: 300)));
                  },
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      color: Constants.primaryColor,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'OR',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    child: Image.asset('assets/kakao.png', height: 40),
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    child: Image.asset('assets/naver.png', height: 40),
                  ),
                ),
                const SizedBox(width: 40),
                GestureDetector(
                  onTap: () {

                  },
                  child: Container(
                    child: Image.asset('assets/google.png', height: 40),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
} 