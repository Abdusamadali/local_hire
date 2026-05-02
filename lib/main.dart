import 'package:flutter/material.dart';
import 'package:local_hire/provider/authProvider.dart';
import 'package:local_hire/services/ApiServices.dart';
import 'package:provider/provider.dart';

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
