

import 'package:flutter/cupertino.dart';
import 'package:local_hire/models/publicPage/login.dart';
import 'package:local_hire/models/publicPage/signup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  void toggle(){
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin?LoginPage(onToggle: toggle):SignupPage(onToggle: toggle);
  }
}
