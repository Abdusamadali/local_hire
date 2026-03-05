import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_hire/models/apiModel/LoginResponse.dart';
import 'package:local_hire/provider/authProvider.dart';

class ApiService {
  final Dio _dio = Dio();
  final storage = FlutterSecureStorage();
  final AuthProvider authProvider;
  ApiService(this.authProvider) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {

          // Skip token for login API
          if (options.path.contains("/localHire/auth/login")) {
            return handler.next(options);
          }

          final token = authProvider.token;

          if (token != null) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },

      ),
    );
  }

  Future<Response> getEmployees() async {
    return await _dio.get("http://10.0.2.2:8081/localHire/employer",);
  }

  Future<LoginResponse?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        "http://10.0.2.2:8081/localHire/auth/login",
        data: {
          "username": username,
          "password": password,
        },
      );
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        print("Status Code: ${e.response?.statusCode}");
        print("Response: ${e.response?.data}");
      }
      print("Login error: $e");
      return null;
    }
  }
  void logOut(){
    authProvider.logout();
  }
}
