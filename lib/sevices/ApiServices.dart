import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_hire/models/apiModel/LoginResponse.dart';
import 'package:local_hire/models/apiModel/api_job_post_dto.dart';
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

  Future<void>deleteJob()async{

  }

  Future<Response>getJobApplication(int id)async{

    return  await _dio.get("http://10.0.2.2:8081/localHire/employer/jobs/$id/applications");
    
  }

  Future<Response> getJobsEmployer() async {
    return await _dio.get("http://10.0.2.2:8081/localHire/employer");
  }


  Future<void> createJob(RequestJobPostDto job)async {
   final res = await _dio.post(
        "http://10.0.2.2:8081/localHire/employer",
      data: job.toJson()
    );
   print(res.data);
  }

  Future<void>updateJob(RequestJobPostDto job,int id)async {
    final res =  await _dio.put(
        "http://10.0.2.2:8081/localHire/employer/$id",
        data: job.toJson()
    );
    print(res);
  }
  
  Future<void>closeJob(int id)async{
   final res =  await _dio.delete("http://10.0.2.2:8081/localHire/employer/$id/close");
   print(res.data);
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

  Future<Response>getJobEmployee()async{
    Response future =await  _dio.get("http://10.0.2.2:8081/localHire/employee");
    return future;
  }

  Future<Response> applyJob(int id) async {
      Response res = await _dio.post("http://10.0.2.2:8081/localHire/employee/jobs/$id");
     return res;
  }
  
  
}
