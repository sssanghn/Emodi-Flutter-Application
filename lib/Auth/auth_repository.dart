import 'package:emodi/Auth/jwt_token_model.dart';
import 'package:emodi/Auth/user_model.dart';
import '../DataSource/local_data_storage.dart';
import 'auth_remote_api.dart';

class AuthRepository {
  final LocalDataStorage _localDataStorage;
  final AuthRemoteApi _authRemoteApi;

  AuthRepository(this._localDataStorage, this._authRemoteApi);

  //인증을 위한 엑세스 토큰 로드
  Future<JwtToken> loadAccessToken() async {
    return await _localDataStorage.loadAccessToken();
  }

  //인증을 위한 리프레쉬 토큰 로드
  Future<JwtToken> loadRefreshToken() async {
    return await _localDataStorage.loadRefreshToken();
  }

  // 엑세스 토큰 저장
  Future<void> saveAccessToken(JwtToken jwtToken) async {
    _localDataStorage.saveAccessToken(jwtToken);
  }

  // 모든 토큰 저장
  Future<void> saveAllToken(JwtToken jwtToken) async {
    _localDataStorage.saveAllToken(jwtToken);
  }

  //로그아웃시 모든 토큰 삭제
  Future<void> deleteToken() async {
    await _localDataStorage.deleteToken();
  }

  //일반 로그인 실패시 Exeption
  Future<JwtToken> postDefaultLogin(User user) async {
    return await _authRemoteApi.postDefaultLogin(user);
  }

  //일반 회원가입 요청
  Future<bool> postDefaultRegister(User user) async {
    return await _authRemoteApi.postDefaultRegister(user);
  }

  Future<JwtToken> getAccessToken(JwtToken jwtToken) async {
    return await _authRemoteApi.getAccessToken(jwtToken);
  }
}
