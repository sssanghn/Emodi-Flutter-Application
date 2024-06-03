import 'package:flutter/material.dart';
import 'package:emodi/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:emodi/Auth/login.dart';
import 'package:emodi/Auth/create.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:emodi/Auth/auth_manager.dart';
import 'package:emodi/Auth/user_model.dart';
import 'package:emodi/Auth/auth_repository.dart';


class CreateDetailPage extends StatefulWidget {
  final String password;
  final String id;
  final AuthRepository authRepository;
  final AuthManager authManager;

  const CreateDetailPage({Key? key, required this.authRepository, required this.authManager, required this.password, required this.id}) : super(key: key);

  @override
  State<CreateDetailPage> createState() => _CreateDetailPageState();
}

class _CreateDetailPageState extends State<CreateDetailPage> {
  late String _password;
  late String _id;
  var _nicknameInputText = TextEditingController();
  var _emailInputText = TextEditingController();
  var _phoneInputText = TextEditingController();
  late AuthRepository _authRepository;
  late AuthManager _authManager;


  @override
  void initState() {
    super.initState();
    _authRepository = widget.authRepository;
    _authManager = widget.authManager;
    _password = widget.password;
    _id = widget.id;
  }

  void dispose() {
    _nicknameInputText.dispose();
    _emailInputText.dispose();
    _phoneInputText.dispose();
    super.dispose();
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
                child: CreatePage(authManager: _authManager, authRepository: _authRepository),
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
                controller: _nicknameInputText,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: ' 닉네임',
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
                controller: _emailInputText,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: ' 이메일',
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
                controller: _phoneInputText,
                onChanged: (value) {
                  // 입력된 문자열에서 숫자만 필터링하여 새로운 문자열을 만듭니다.
                  String digitsOnly = value.replaceAll(RegExp(r'\D'), '');

                  // '-'가 있는 휴대폰 번호 형식으로 변환합니다.
                  if (digitsOnly.length >= 3 && digitsOnly.length <= 6) {
                    // 010-xxxx 형식
                    _phoneInputText.text = '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3)}';
                  } else if (digitsOnly.length >= 7) {
                    // 010-xxxx-xxxx 형식
                    _phoneInputText.text = '${digitsOnly.substring(0, 3)}-${digitsOnly.substring(3, 7)}-${digitsOnly.substring(7)}';
                  }
                  // 커서의 위치를 문자열 끝으로 이동시킵니다.
                  _phoneInputText.selection = TextSelection.fromPosition(TextPosition(offset: _phoneInputText.text.length));
                },
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(13), // 전화번호 최대 길이 제한
                ],
                decoration: InputDecoration(
                  hintText: ' 휴대폰 번호',
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
              const SizedBox(height: 30),
              InkWell(
                onTap: () async {
                  if (_nicknameInputText.text.isEmpty ||
                      _emailInputText.text.isEmpty ||
                      _phoneInputText.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ' 모든 항목에 입력해주세요.',
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
                  User user = User.withUserRegister(
                    loginId: _id,
                    password: _password,
                    email: _emailInputText.text,
                    username: _nicknameInputText.text,
                    tellNumber: _phoneInputText.text,
                  );
                  try {
                    await _authRepository.postDefaultRegister(user);
                    // 회원가입 요청 완료 후 페이지 전환
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                        child: LoginPage(authRepository: _authRepository, authManager: _authManager),
                        type: PageTransitionType.rightToLeftWithFade,
                        duration: Duration(milliseconds: 300),
                      ),
                    );
                  } catch (error) {
                    if (error.toString() == 'USER_EMAIL_DUPLICATED') {
                      // 에러 처리 해주세용!
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
                            '회원가입',
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
