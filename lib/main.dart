import 'package:flutter/material.dart';
import 'package:local_hire/provider/authProvider.dart';
import 'package:local_hire/sevices/ApiServices.dart';
import 'package:local_hire/sevices/service.dart';
import 'package:local_hire/sevices/todoDemo.dart';
import 'package:provider/provider.dart';

import 'models/employee/home.dart';
import 'models/employee/profile.dart';
import 'models/publicPage/login.dart';
import 'models/publicPage/signup.dart';
import 'models/utils/AuthWrapper.dart';

void main() {
  runApp(
    MultiProvider(providers: [
        ChangeNotifierProvider(create: (_)=>AuthProvider()..loadAuth()),
      ProxyProvider<AuthProvider,ApiService>(
        update:  (_, authProvider, __) => ApiService(authProvider),
      )
    ],
    child: MyApp(),)

  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:AuthWrapper(),
      theme: ThemeData(
        primaryColor: Colors.blue,
            brightness: Brightness.light
      ),
    );
  }
}
