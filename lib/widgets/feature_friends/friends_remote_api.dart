import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:emodi/Auth/jwt_token_model.dart';
import 'package:emodi/widgets/feature_friends/friends_model.dart';

class FriendsRemoteApi {
  late http.Client httpClient;

  FriendsRemoteApi() {
    httpClient = http.Client();
  }

  // 친구 검색 GET
  Future<List<UserSearch>> friendSearchGet(JwtToken jwtToken, String loginId) async {
    var uri = Uri.https('emo-di.com', 'member/search', {'loginId': loginId});

    final http.Response response = await httpClient.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '${jwtToken.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> usersJson = data['data'];
      return usersJson.map((json) => UserSearch.fromJson(json)).toList();
    } else {
      Map<String, dynamic> data = jsonDecode(response.body);
      throw Exception(data['error']);
    }
  }
  // 유저 정보 Get
  Future<UserInfo> friendInfoGet(JwtToken jwtToken, int memberId) async {
    var uri = Uri.https('emo-di.com', '/$memberId/info');

    final http.Response response = await httpClient.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '${jwtToken.accessToken}',
      },
    );
    print(response);
    if (response.statusCode == 200) {
      try {
        print(response.body);
        final Map<String, dynamic> json = jsonDecode(response.body);
        UserInfo data = ApiResponse.fromJson(json).data;
        print(data);
        return data;

      } catch (e) {
        throw FormatException('Failed to parse response');
      }
    } else {
      throw Exception('Failed to load user info');
    }
  }
  // 친구 추가 POST
  Future<void> followingPost(JwtToken jwtToken, int memberId, int friendId) async {
    var uri = Uri.https('emo-di.com', '/friends/$memberId/add/$friendId');

    final http.Response response = await httpClient.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '${jwtToken.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      try {
      } catch (e) {
        throw FormatException('Failed to parse response');
      }
    } else {
      final Map<String, dynamic> json = jsonDecode(response.body);
      String data = ApiResponse.fromJson(json).message;
      print(data);
      throw Exception('Failed to load user info');
    }
  }
  // 친구 제거 DELETE
  Future<void> followingDelete(JwtToken jwtToken, int memberId, int friendId) async {
    var uri = Uri.https('emo-di.com', '/friends/$memberId/remove/$friendId');

    final http.Response response = await httpClient.delete(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '${jwtToken.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      try {
      } catch (e) {
        throw FormatException('Failed to parse response');
      }
    } else {
      final Map<String, dynamic> json = jsonDecode(response.body);
      String data = ApiResponse.fromJson(json).message;
      print(data);
      throw Exception('Failed to load user info');
    }
  }
  // 내 친구 GET
  Future<List<UserInfo>> myFriendGet(JwtToken jwtToken, int memberId) async {
    var uri = Uri.https('emo-di.com', '/friends/${memberId}');

    final http.Response response = await httpClient.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '${jwtToken.accessToken}',
      },
    );
    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> json = jsonDecode(response.body);
        List<UserInfo> data = ApiListResponse.fromJson(json).data;
        return data;

      } catch (e) {
        throw FormatException('Failed to parse response');
      }
    } else {
      throw Exception('Failed to load user info');
    }
  }
}
