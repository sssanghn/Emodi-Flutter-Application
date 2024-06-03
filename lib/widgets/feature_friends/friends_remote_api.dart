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
}
