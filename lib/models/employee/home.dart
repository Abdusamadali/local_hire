
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart' ;
import 'package:local_hire/models/employee/profile.dart';

import 'MyJob.dart';
import 'job_page.dart';

class EmployeeHome extends StatefulWidget {
  const EmployeeHome({super.key});

  @override
  State<EmployeeHome> createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {

  final _pages =[
    EmployeeJobsPage(),
    Myjob(),
    MyProfile()
  ];

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
          onTap: (currIndex) {
            setState(() {
              index = currIndex;
            });
          },
        fixedColor: Colors.black87,
          items: [
            BottomNavigationBarItem(icon: Icon(Iconsax.home),label: 'home',activeIcon: Icon(Iconsax.home1)),
            BottomNavigationBarItem(icon: Icon(Iconsax.save_21),label: 'jobs',activeIcon: Icon(Iconsax.save_add4)),
            BottomNavigationBarItem(icon: Icon(Icons.person),label: 'profile',activeIcon: Icon(Iconsax.personalcard)),
          ]
      ),
    );
  }
}
