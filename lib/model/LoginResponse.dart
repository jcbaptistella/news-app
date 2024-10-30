class LoginResponse {
  final String accessToken;
  final int expiresIn;

  LoginResponse({
    required this.accessToken,
    required this.expiresIn,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['accessToken'],
      expiresIn: json['expiresIn'],
    );
  }
}