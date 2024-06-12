class User {
  final int? id;
  final String? loginId;
  final String? username;
  final String? password;
  final String? email;
  final String? tellNumber;
  final String? imageUrl;
  final int? postNum;
  final int? followingNum;
  final int? followerNum;
  final bool? friend;
  User(
      {required this.id,
        required this.loginId,
      required this.username,
      required this.password,
      required this.email,
      required this.tellNumber,
        required this.imageUrl,
        required this.postNum,
        required this.followingNum,
        required this.followerNum,
        required this.friend,
     });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      loginId: json['loginId'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      tellNumber: json['tellNumber'],
      imageUrl: json['imageUrl'],
        postNum: json['postNum'],
      followingNum: json['followingNum'],
      followerNum: json['followerNum'],
      friend: json['friend'],
    );
  }

  // 일반 유저 로그인
  User.withDefaultUserLogin(
      {required String loginId,
        required String password,})
      : this(id: null, loginId: loginId, username: null, password: password, email: null, tellNumber: null,
      imageUrl: null, postNum: null, followingNum: null, followerNum: null, friend: null);

  // 일반 유저 회원가입
  User.withUserRegister({required String loginId,
    required String username,
    required String password,
    required String email,
    required String tellNumber,})
      : this(id: null, loginId: loginId, username: username, password: password, email: email, tellNumber: tellNumber,
      imageUrl: null, postNum: null, followingNum: null, followerNum: null, friend: null);

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


