// 내 친구 불러오기 모델
import 'dart:convert';

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
  final String imageUrl;
  bool friend;

  UserSearch({
    required this.id,
    required this.loginId,
    required this.username,
    required this.email,
    required this.tellNumber,
    required this.imageUrl,
    required this.friend,
  });

  factory UserSearch.fromJson(Map<String, dynamic> json) {
    return UserSearch(
      id: json['id'],
      loginId: json['loginId'],
      username: json['username'],
      email: json['email'],
      tellNumber: json['tellNumber'],
        imageUrl: json['imageUrl'],
      friend: json['friend'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loginId': loginId,
      'username': username,
      'email': email,
      'tellNumber': tellNumber,
      'imageUrl': imageUrl,
      'friend': friend,
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
  final String imageUrl;
  final int postNum;
  final int followingNum;
  final int followerNum;
  final bool friend;

  UserInfo({
    required this.id,
    required this.loginId,
    required this.username,
    required this.email,
    required this.tellNumber,
    required this.imageUrl,
    required this.postNum,
    required this.followingNum,
    required this.followerNum,
    required this.friend
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      loginId: json['loginId'],
      username: json['username'],
      email: json['email'],
      tellNumber: json['tellNumber'],
        imageUrl: json['imageUrl'],
      postNum: json['postNum'],
      followingNum: json['followingNum'],
      followerNum: json['followerNum'],
      friend: json['friend']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'loginId': loginId,
      'username': username,
      'email': email,
      'tellNumber': tellNumber,
      'imageUrl': imageUrl,
      'postNum': postNum,
      'followingNum': followingNum,
      'followerNum': followerNum,
      'friend': friend
    };
  }
}
class ApiResponse {
  final bool success;
  final String message;
  final UserInfo data;

  ApiResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'],
      message: json['message'],
      data: UserInfo.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.toJson(),
    };
  }
}
class ApiListResponse {
  final bool success;
  final String message;
  final List<UserInfo> data;

  ApiListResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ApiListResponse.fromJson(Map<String, dynamic> json) {
    var dataList = json['data'] as List;
    List<UserInfo> userInfoList = dataList.map((i) => UserInfo.fromJson(i)).toList();

    return ApiListResponse(
      success: json['success'],
      message: json['message'],
      data: userInfoList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((userInfo) => userInfo.toJson()).toList(),
    };
  }
}