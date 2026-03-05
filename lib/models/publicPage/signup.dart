

import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final usernameController = TextEditingController();
  final password = TextEditingController();
  final password2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Signup'
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Enter username",
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue,width: 2),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: password,
                  decoration: InputDecoration(
                      hintText: "Enter password",
                      labelText: 'password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue,width: 2),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15)
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: password2,
                  decoration: InputDecoration(
                      hintText: "Re-enter password",
                      labelText: 'password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.lightBlueAccent,width: 2),
                          borderRadius: BorderRadius.circular(12)
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15)
                  ),

                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200,50),
                ),
                  onPressed: (){},
                  child: Text(
                    'submit'
                  )

              )
            ],
          ),
        ),
      ),
    );
  }

  void signUp()async{

  }
}
