import 'dart:convert';
import 'package:emodi/Auth/user_model.dart';
import 'package:http/http.dart' as http;
import 'jwt_token_model.dart';

class AuthRemoteApi {
  late http.Client httpClient;

  AuthRemoteApi() {
    httpClient = http.Client();
  }

  // 로그인 POST
  Future<JwtToken> postDefaultLogin(User user) async {
    var uri = Uri.https('emo-di.com', 'api/login');
    String jsonData = jsonEncode(user.toDefaultLoginJson());
    final http.Response response = await httpClient.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return JwtToken.fromJson(data);
    } else {
      //로그인 실패 -> 로그인 정보 없음 or 비밀번호 오류
      Map<String, dynamic> data = jsonDecode(response.body);
      throw data['error'];
    }
  }

  // 회원가입 Post
  Future<bool> postDefaultRegister(User user) async {
    var uri = Uri.https('emo-di.com', 'api/signup');
    String jsonData = jsonEncode(user.toDefaultRegisterJson());
    final http.Response response = await httpClient.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonData,
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      if (data['success']) {
        return true;
      } else {
        throw data['message'];
      }
    } else {
      Map<String, dynamic> data = jsonDecode(response.body);
      throw data['error'];
    }
  }

  // 리프레시 토큰 POST
  Future<JwtToken> getAccessToken(JwtToken jwtToken) async {
    var uri = Uri.https('emo-di.com', 'api/auth/refresh');
    final http.Response response = await httpClient.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': '${jwtToken.refreshToken}'
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return JwtToken.fromJson(data);
    } else {
      throw Exception();
    }
  }
}
