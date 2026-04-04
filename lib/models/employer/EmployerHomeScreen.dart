import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_hire/models/employer/CreateJobPage.dart';
import 'JobsPage.dart';

class EmployerHome extends StatefulWidget {
  const EmployerHome({super.key});

  @override
  State<EmployerHome> createState() => _EmployerHomeState();
}

class _EmployerHomeState extends State<EmployerHome> {

  int currIndex = 0; //  keep state here

  @override
  Widget build(BuildContext context) {

    List<Widget> pages = [
      CreateJobPage(
        onJobCreated: () {
          setState(() {
            currIndex = 1; //  switch to Jobs tab
          });
        },
      ),
      jobsPage(),
    ];

    return Scaffold(
      body: pages[currIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currIndex,
        onTap: (index) {
          setState(() {
            currIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(Iconsax.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            activeIcon: Icon(Iconsax.briefcase),
            label: 'Jobs',
          ),
        ],
      ),
    );
  }
}