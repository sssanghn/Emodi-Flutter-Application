import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:emodi/Auth/jwt_token_model.dart';

class LocalDataStorage {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // 엑세스 토큰 저장
  Future<void> saveAccessToken(JwtToken token) async {
    await _secureStorage.write(key: 'accessToken', value: token.accessToken.toString());
  }
  // 리프래시 토큰 저장
  Future<void> saveAllToken(JwtToken token) async {
    await _secureStorage.write(key: 'refreshToken', value: token.refreshToken.toString());
    await _secureStorage.write(key: 'accessToken', value: token.accessToken.toString());
  }

  // 저장된 엑세스 토큰 불러오기
  Future<JwtToken> loadAccessToken() async {
    String? jwtToken = await _secureStorage.read(key: 'accessToken');
    if (jwtToken != null) {
      return JwtToken(accessToken: jwtToken, refreshToken: null);
    } else {
      throw Exception('Failed to load access token');
    }
  }
  // 저장된 리프레쉬 토큰 불러오기
  Future<JwtToken> loadRefreshToken() async {
    String? jwtToken = await _secureStorage.read(key: 'refreshToken');
    if (jwtToken != null) {
      return JwtToken(accessToken: jwtToken, refreshToken: null);
    } else {
      throw Exception('Failed to load access token');
    }
  }
  // 저장된 토큰 모두 삭제
  Future<void> deleteToken() async {
    await _secureStorage.delete(key: 'accessToken');
    await _secureStorage.delete(key: 'refreshToken');
  }
}
