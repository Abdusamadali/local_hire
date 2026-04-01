

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

  List<Widget> pages = [CreateJobPage(),jobsPage()];
  int currIndex = 0;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: pages[currIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currIndex,
        onTap:(index){
         setState(() {
           currIndex = index;
         });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),label: 'home',activeIcon: Icon(Iconsax.home)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.multiple_stop_sharp),label: 'Jobs',activeIcon: Icon(Iconsax.home)
          ),
        ],
      ),
    );
  }
}

