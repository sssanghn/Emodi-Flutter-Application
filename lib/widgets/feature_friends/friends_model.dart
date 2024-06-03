// 내 친구 불러오기 모델
class Friend {
  final int memberId;
  final int friendId;

  Friend({
    required this.memberId,
    required this.friendId,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      memberId: json['memberId'],
      friendId: json['friendId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'memberId': memberId,
      'friendId': friendId,
    };
  }
}

// 유저 검색 모델
class UserSearch {
  final int id;
  final String loginId;
  final String username;
  final String email;
  final String tellNumber;

  UserSearch({
    required this.id,
    required this.loginId,
    required this.username,
    required this.email,
    required this.tellNumber,
  });

  factory UserSearch.fromJson(Map<String, dynamic> json) {
    return UserSearch(
      id: json['id'],
      loginId: json['loginId'],
      username: json['username'],
      email: json['email'],
      tellNumber: json['tellNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loginId': loginId,
      'username': username,
      'email': email,
      'tellNumber': tellNumber,
    };
  }
}

// 유저 정보 모델
class UserInfo {
  final int id;
  final String loginId;
  final String username;
  final String email;
  final String tellNumber;

  UserInfo({
    required this.id,
    required this.loginId,
    required this.username,
    required this.email,
    required this.tellNumber,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      loginId: json['loginId'],
      username: json['username'],
      email: json['email'],
      tellNumber: json['tellNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loginId': loginId,
      'username': username,
      'email': email,
      'tellNumber': tellNumber,
    };
  }
}