

import 'package:flutter/material.dart';
import 'package:local_hire/provider/authProvider.dart';
import 'package:local_hire/sevices/ApiServices.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController =TextEditingController();
  final password = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body:Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      hintText: "Enter username",
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue,width: 2),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: password,
                  decoration: InputDecoration(
                      hintText: "Enter password",
                      labelText: 'password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue,width: 2),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200,50),
                    ),
                    onPressed: ()async{
                      final api = context.read<ApiService>();
                      final authProvider = context.read<AuthProvider>();
                      final body = await api.login(usernameController.text, password.text);
                      final token = body?.token;
                      final role = body?.role;
                      if(token !=null){
                        await authProvider.setAuth(token,role!);
                        print('token loaded--------------------------$token-----------------');
                      }else{
                        print('token not loaded---------------------------------------');
                      }
                      final response =await api.getEmployees();
                      print(response.data);
                    },
                    child: Text(
                        'Login'
                    )
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
