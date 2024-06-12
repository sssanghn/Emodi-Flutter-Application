import 'package:emodi/Auth/auth_remote_api.dart';
import 'package:flutter/material.dart';
import 'package:emodi/Auth/forgot.dart';
import 'package:emodi/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:emodi/Auth/explanation.dart';
import 'package:emodi/root_page.dart';
import 'package:emodi/Auth/auth_manager.dart';
import 'package:emodi/Auth/user_model.dart';
import 'package:emodi/Auth/auth_repository.dart';
import 'package:emodi/Auth/jwt_token_model.dart';

class LoginPage extends StatefulWidget {
  final AuthRepository authRepository;
  final AuthManager authManager;

  const LoginPage(
      {Key? key, required this.authRepository, required this.authManager})
      : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _emailInputText = TextEditingController();
  var _passInputText = TextEditingController();
  bool _obscurePassword = true;
  late AuthRepository _authRepository;
  late AuthManager _authManager;

  void dispose() {
    _emailInputText.dispose();
    _passInputText.dispose();
    super.dispose();
  }

  @override
  // 초기화
  void initState() {
    super.initState();
    _authRepository = widget.authRepository;
    _authManager = widget.authManager;
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
                child: ExplanationPage(
                    authManager: _authManager, authRepository: _authRepository),
                type: PageTransitionType.leftToRight,
                duration: Duration(milliseconds: 300),
              ),
            );
          },
        ),
        title: Row(
          children: [
            const SizedBox(width: 90),
            Text(
              '로그인',
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
                  hintText: ' ID',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.3), // 변경할 색상 설정
                      width: 2.0, // 테두리 두께 설정
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Constants.primaryColor, // 변경할 색상 설정
                      width: 2.0, // 테두리 두께 설정
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passInputText,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: ' Password',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.3), // 변경할 색상 설정
                      width: 2.0, // 테두리 두께 설정
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Constants.primaryColor, // 변경할 색상 설정
                      width: 2.0, // 테두리 두께 설정
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        // 비밀번호를 숨기거나 보이게 토글
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
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
                          child: ForgotPage(
                              authManager: _authManager,
                              authRepository: _authRepository),
                          type: PageTransitionType.rightToLeftWithFade,
                          duration: Duration(milliseconds: 300)));
                },
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      '비밀번호를 잊으셨나요?',
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
                  if (_emailInputText.text.isEmpty ||
                      _passInputText.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ' 이메일과 비밀번호를 입력해주세요.',
                        ),
                        backgroundColor: Constants.primaryColor,
                        duration: Duration(seconds: 1),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    _isLoading = true; // 버튼을 눌렀을 때 대기 상태로 설정
                  });
                  User user = User.withDefaultUserLogin(
                      loginId: _emailInputText.text,
                      password: _passInputText.text,
                  );
                  try {
                    LoginResponse loginResponse =
                    await _authRepository.postDefaultLogin(user);
                    await _authRepository.saveAllToken(loginResponse.jwtToken);
                    // 로그인 요청 완료 후 페이지 전환
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        child: RootPage(authManager: _authManager, id: loginResponse.id),
                        type: PageTransitionType.rightToLeftWithFade,
                        duration: Duration(milliseconds: 300),
                      ),
                    );
                  } catch (error) {
                    if (error.toString() == "USER_TYPE_IS_NOT_VALIDATE") {
                      // 에러 처리 해주세용!
                      print("회원가입한 유저와 다른 유저타입");
                    } else if (error.toString() == "USER_LOGIN_PASSWORD_FAIL") {
                      // 에러 처리 해주세용!
                      print("비밀번호가 틀림");
                    } else if (error.toString() == "USER_EMAIL_NOT_FOUND") {
                      // 에러 처리 해주세용!
                      print("저장된 정보가 없습니다");
                    }
                    setState(() {
                      _isLoading = false; // 에러 발생 시 대기 상태 해제
                      _loginFailed = true; // 로그인 실패 상태로 설정
                    });
                    print('Error during registration: $error');
                  }
                },
                child: Container(
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Constants.primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Center(
                    child: _isLoading
                        ? SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            '로그인',
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
