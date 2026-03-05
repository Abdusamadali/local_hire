


import 'package:flutter/material.dart';

class Myjob extends StatefulWidget {
  const Myjob({super.key});

  @override
  State<Myjob> createState() => _MyjobState();
}

class _MyjobState extends State<Myjob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my jobs'),
      ),
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverPadding(padding: EdgeInsetsGeometry.all(8)),
            SliverList.builder(
                itemCount: 10,
                itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15)
                  ),
                ),
              );
            })
          ],
        )
      ),
    );;
  }
}
