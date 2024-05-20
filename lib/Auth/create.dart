import 'package:flutter/material.dart';
import 'package:emodi/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:emodi/Auth/explanation.dart';
import 'package:emodi/Auth/login.dart';
import 'package:emodi/Auth/create_detail.dart';

class CreatePage extends StatefulWidget {

  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  var _emailInputText = TextEditingController();
  var _passInputText = TextEditingController();
  var _confirmPassInputText = TextEditingController(); // 추가
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _confirmPassInputText.addListener(_confirmPasswordTextChanged);
  }

  void dispose() {
    _emailInputText.dispose();
    _passInputText.dispose();
    _confirmPassInputText.removeListener(_confirmPasswordTextChanged);
    _confirmPassInputText.dispose();
    super.dispose();
  }

  void _confirmPasswordTextChanged() {
    setState(() {});
  }

  @override
  bool _isLoading = false;
  bool _loginFailed = false;

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageTransition(
                child: ExplanationPage(),
                type: PageTransitionType.leftToRightWithFade,
                duration: Duration(milliseconds: 300),
              ),
            );
          },
        ),
        title: Row(
          children: [
            const SizedBox(width: 80),
            Text(
              '회원가입',
              style: TextStyle(
                color: Colors.black,
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              TextField(
                controller: _emailInputText,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: ' Email',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Constants.primaryColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // 비밀번호 텍스트 필드
              TextField(
                controller: _passInputText,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: ' Password',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Constants.primaryColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // 비밀번호 확인 텍스트 필드
              TextField(
                controller: _confirmPassInputText,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: ' Confirm Password',
                  filled: true, // 수정된 부분
                  fillColor: _passInputText.text != _confirmPassInputText.text ? Colors.red.withOpacity(0.1) : Colors.white, // 수정된 부분
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _passInputText.text != _confirmPassInputText.text ? Colors.red : Colors.grey.withOpacity(0.3),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: _passInputText.text != _confirmPassInputText.text ? Colors.red : Constants.primaryColor,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Constants.primaryColor,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: LoginPage(),
                      type: PageTransitionType.rightToLeftWithFade,
                      duration: Duration(milliseconds: 300),
                    ),
                  );
                },
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      '이미 계정이 있으신가요?',
                      style: TextStyle(
                        color: Constants.primaryColor,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              InkWell(
                onTap: () async {
                  if (_emailInputText.text.isEmpty || _passInputText.text.isEmpty || _confirmPassInputText.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '이메일과 비밀번호를 입력해주세요.',
                        ),
                        backgroundColor: Constants.primaryColor,
                        duration: Duration(seconds: 1),
                      ),
                    );
                    return;
                  }
                  if (_passInputText.text != _confirmPassInputText.text) { // 추가: 비밀번호 일치 여부 확인
                    setState(() {}); // 추가: 테두리 색을 변경하기 위해 setState 호출
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '비밀번호가 일치하지 않습니다.',
                        ),
                        backgroundColor: Constants.primaryColor,
                        duration: Duration(seconds: 1),
                      ),
                    );
                    return;
                  }
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: CreateDetailPage(password: _passInputText.text, email: _emailInputText.text),
                      type: PageTransitionType.rightToLeftWithFade,
                      duration: Duration(milliseconds: 300),
                    ),
                  );
                },
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Center(
                    child: Text(
                      '다음',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}