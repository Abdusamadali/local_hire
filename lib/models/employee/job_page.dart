


import 'package:flutter/material.dart';
import 'package:local_hire/models/utils/Jobs.dart';

class job_page extends StatefulWidget {
  const job_page({super.key});

  @override
  State<job_page> createState() => _job_pageState();
}

class _job_pageState extends State<job_page> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('jobs'),
      ),
      body: Container(
        height: MediaQuery.heightOf(context),
        width: MediaQuery.widthOf(context),

        child: CustomScrollView(
          slivers: [
            SliverPadding(padding: EdgeInsetsGeometry.all(8)),
            SliverToBoxAdapter(
              child:Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 120,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(-1,1 ),
                            blurRadius: 10,
                            spreadRadius: 1
                          )
                        ]
                      ),
                    ),
                  ),
                  Text('Jobs for you',
                  style: TextStyle(
                    fontSize: 20
                  ),
                  ),
                  Text('jobs based on your location')
                ],
              ),
            ),
            SliverPadding(padding: EdgeInsetsGeometry.all(8)),
            SliverList.builder(
                itemCount: 10,
                itemBuilder: (context,index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: (){
                    showBottomSheet(context: context, builder: (context){
                      return Container(

                        height: 600,
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15)
                          ),
                          boxShadow: [

                            BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 5
                            )
                          ]
                        ),
                      );
                    });
                  },
                  child: Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15)
                    ),
                  ),
                ),
              );
            })
          ],
        )
        ),
    );
  }
}
