import 'package:emodi/Auth/auth_repository.dart';
import 'package:emodi/Auth/jwt_token_model.dart';

class AuthManager {
  final AuthRepository _authRepository;

  AuthManager(this._authRepository);

  get currentUserName => null;

  //access token 오류시 refresh 토큰으로 retry 하는 함수
  Future<JwtToken> authorizeRefreshToken() async {
    try {
      final JwtToken refreshToken = await _authRepository.loadRefreshToken();
      final newAccessToken = await _authRepository.getAccessToken(refreshToken);
      _authRepository.saveAccessToken(newAccessToken);
      return newAccessToken;
    } catch (error) {
      throw error;
    }
  }
  Future<JwtToken> loadAccessToken() async {
      return await _authRepository.loadAccessToken();
  }
  void removeToken() async {
    return await _authRepository.deleteToken();
  }
}
