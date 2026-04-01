import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthProvider extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;
  String? _role;

  String? get token => _token;
  String? get role => _role;

  bool get isLoggedIn => _token != null;

  bool get isEmployer => _role == "EMPLOYER";
  bool get isEmployee => _role == "EMPLOYEE";

  // Load token and role when app starts
  Future<void> loadAuth() async {
    final token = await _storage.read(key: "token");
    final role = await _storage.read(key: "role");

    if(token != null) {

      try{
        bool isExpired = JwtDecoder.isExpired(token);

        if (isExpired) {
          _token = null;
          _role = null;
          await _storage.delete(key: "token");
          await _storage.delete(key: "role");
        } else {
          _token = token;
          _role = role;
        }
      }catch(e){
        _token = null;
        _role = null;
        await _storage.delete(key: "token");
        await _storage.delete(key: "role");
      }
    }

    notifyListeners();
  }

  // Save token and role after login
  Future<void> setAuth(String token, String role) async {
    _token = token;
    _role = role;

    await _storage.write(key: "token", value: token);
    await _storage.write(key: "role", value: role);

    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    _token = null;
    _role = null;

    await _storage.delete(key: "token");
    await _storage.delete(key: "role");

    notifyListeners();
  }
}