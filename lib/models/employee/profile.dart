
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:local_hire/sevices/ApiServices.dart';
import 'package:provider/provider.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  Widget build(BuildContext context) {
    final api = context.read<ApiService>();

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('profile')),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 10,),
                  Text("localHire",style:TextStyle(fontSize: 27),),
                  SizedBox(width: 120),
                  Row(
                    children: [
                      IconButton(onPressed: (){}, icon: Icon(Icons.bookmark)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.message)),
                      IconButton(onPressed: (){}, icon: Icon(Icons.notification_important_sharp))
                    ],
                  )
                ],
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Abdus Samad',
                      style: TextStyle(
                        fontSize: 30
                      ),
                    ),
                    // SizedBox(width: 100,),
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 30,
                      child: Text(
                          'AA',
                            style: TextStyle(fontSize: 30),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shadowColor: Colors.blue,
        
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('abdussamadali05@gmail.com'),
                        leading: Icon(Icons.mail),
                      ),
                      ListTile(
                        leading: Icon(Icons.call),
                        title: Text('7759030728'),
                      ),
                      ListTile(
                        leading: Icon(Icons.location_on_rounded),
                        title: Text('Jharkhand,816106'),
                      )
                    ],
                  ),
                ),
              ), //Contact card
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Resume',
                      style: TextStyle(
                        fontSize: 35
                      ),
                    ),
                  ],
                ),
              ), // resume
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height:90,
                  width: MediaQuery.of(context).size.width,
                  decoration:BoxDecoration(
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Card(
                      child:Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Resume.pdf',
                            style: TextStyle(fontSize: 40),
                          ),
                          IconButton(onPressed: (){},
                              icon: Icon(Icons.more_vert))
                        ],
                        ),
                      )),
                ),
              ), 
              SizedBox(height: 8,),
              Text(
                'Improve your job matches',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
              SizedBox(height: 8,),
              Divider(
                thickness:1.3,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Qualifications',
                        style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Highlight your skills and experience'
                        )
                      ],
                    ),
                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_rounded))
                  ],
                ),
              ),
              Divider(
                thickness:1.3,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Job preferences',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                            'Save specific details like minimum '
                        )
                      ],
                    ),
                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_rounded))
                  ],
                ),
              ),
              Divider(
                thickness:1.3,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ready to work',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Text(
                            'Enter Location where you want to work'
                        )
                      ],
                    ),
                    IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios_rounded))
                  ],
                ),
              ),
              Divider(
                thickness:1.3,
              ),
              Container(
                child: TextButton(
                  onPressed: () {
                    api.logOut();
                  }, child: Text('logout'),

                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
