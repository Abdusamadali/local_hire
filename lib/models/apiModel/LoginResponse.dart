
import 'dart:ffi';

class LoginResponse {
  final String token;
  final String role;
  final int  id;

  LoginResponse({
    required this.token,
    required this.role,
    required this.id,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json["token"],
      role: json["role"],
      id: json["id"],
    );
  }
}