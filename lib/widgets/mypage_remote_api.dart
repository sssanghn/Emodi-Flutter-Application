import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:emodi/Auth/jwt_token_model.dart';
import 'package:emodi/widgets/mypage_model.dart';

class myPageRemoteApi {
  late http.Client httpClient;

  myPageRemoteApi() {
    httpClient = http.Client();
  }

  // 유저 정보 Get
  Future<UserInfo> myInfoGet(JwtToken jwtToken, int memberId) async {
    var uri = Uri.https('emo-di.com', '/$memberId/info');

    final http.Response response = await httpClient.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '${jwtToken.accessToken}',
      },
    );

    if (response.statusCode == 200) {
      try {
        print(response.body);
        final Map<String, dynamic> json = jsonDecode(response.body);
        UserInfo data = ApiResponse.fromJson(json).data;
        return data;

      } catch (e) {
        throw FormatException('Failed to parse response');
      }
    } else {
      throw Exception('Failed to load user info');
    }
  }
}
