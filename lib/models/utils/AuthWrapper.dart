
import 'package:flutter/material.dart';
import 'package:local_hire/models/employee/home.dart';
import 'package:local_hire/models/employer/EmployerHomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:local_hire/provider/authProvider.dart';

import '../publicPage/RoleBasedHome.dart';
import '../publicPage/login.dart';


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    if (authProvider.isLoggedIn) {
      return const RoleBasedHome();
    } else {
      return const Login();
    }
  }
}