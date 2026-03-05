

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../provider/authProvider.dart';
import '../employee/home.dart';
import '../employer/EmployerHomeScreen.dart';

class RoleBasedHome extends StatelessWidget{
  const RoleBasedHome({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.role == "EMPLOYER") {
      return EmployerHome();
    } else {
      return EmployeeHome();
    }
  }

}