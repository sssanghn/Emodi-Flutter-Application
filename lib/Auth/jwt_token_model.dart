class JwtToken {
  final String? accessToken;
  final String? refreshToken;

  JwtToken({
    required this.accessToken,
    required this.refreshToken,
  });

  factory JwtToken.fromJson(Map<String, dynamic> json) {
    return JwtToken(
      accessToken: json['data']['accessToken'],
      refreshToken: json['data']['refreshToken'],
    );
  }
}
