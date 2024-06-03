class User {
  final String? loginId;
  final String? username;
  final String? password;
  final String? email;
  final String? tellNumber;
  User(
      {required this.loginId,
      required this.username,
      required this.password,
      required this.email,
      required this.tellNumber,
     });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      loginId: json['loginId'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      tellNumber: json['tellNumber'],
    );
  }

  // 일반 유저 로그인
  User.withDefaultUserLogin(
      {required String loginId,
        required String password,})
      : this(loginId: loginId, username: null, password: password, email: null, tellNumber: null);

  // 일반 유저 회원가입
  User.withUserRegister({required String loginId,
    required String username,
    required String password,
    required String email,
    required String tellNumber,})
      : this(loginId: loginId, username: username, password: password, email: email, tellNumber: tellNumber);

  Map<String, dynamic> toDefaultLoginJson() {
    return {
      'loginId': loginId,
      'password': password,
    };
  }

  Map<String, dynamic> toDefaultRegisterJson() {
    return {
      'loginId': loginId,
      'username': username,
      'password': password,
      'email': email,
      'tellNumber': tellNumber,
    };
  }
}
