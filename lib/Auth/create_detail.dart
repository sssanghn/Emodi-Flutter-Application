import 'package:flutter/material.dart';
import 'package:emodi/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:emodi/Auth/explanation.dart';
import 'package:emodi/Auth/login.dart';
import 'package:emodi/Auth/create.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CreateDetailPage extends StatefulWidget {
  final String password;
  final String email;

  const CreateDetailPage({Key? key, required this.password, required this.email}) : super(key: key);

  @override
  State<CreateDetailPage> createState() => _CreateDetailPageState();
}

class _CreateDetailPageState extends State<CreateDetailPage> {
  late String _password;
  late String _email;
  var _nicknameInputText = TextEditingController();
  var _nameInputText = TextEditingController();
  var _birthInputText = TextEditingController();
  var _phoneInputText = TextEditingController();
  var _phoneAuthText = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _password = widget.password;
    _email = widget.email;
  }

  void dispose() {
    _nicknameInputText.dispose();
    _nameInputText.dispose();
    _phoneInputText.dispose();
    _birthInputText.dispose();
    _phoneAuthText.dispose();
    super.dispose();
  }

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return Container(
          height: MediaQuery.of(context).copyWith().size.height / 3,
          child: CupertinoDatePicker(
            dateOrder: DatePickerDateOrder.ymd,
            mode: CupertinoDatePickerMode.date,
            initialDateTime: DateTime.now(),
            onDateTimeChanged: (DateTime newDateTime) {
              setState(() {
                _selectedDate = newDateTime;
                _birthInputText.text =
                    "${_selectedDate!.year}.${_selectedDate!.month}.${_selectedDate!.day}";
              });
            },
          ),
        );
      },
    );
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
                child: CreatePage(),
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
                  suffixIcon: InkWell(
                    onTap: () {
                      // 중복 확인 기능 추가
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          '중복 확인',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _nameInputText,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: ' 이름',
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
                onTap: () {
                  _showDatePicker(context);
                },
                readOnly: true,
                controller: _birthInputText,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: ' 생년월일',
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
                  suffixIcon: InkWell(
                    onTap: () {
                      // 중복 확인 기능 추가
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Constants.primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          '  인증  ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneAuthText,
                obscureText: false,
                decoration: InputDecoration(
                  hintText: ' 인증번호',
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
                      _nameInputText.text.isEmpty ||
                      _birthInputText.text.isEmpty ||
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
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                      child: LoginPage(),
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
