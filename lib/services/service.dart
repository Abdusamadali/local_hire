
import 'dart:ffi';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:local_hire/provider/authProvider.dart';
import 'package:provider/provider.dart';

class Apitest extends StatefulWidget {
  const Apitest({super.key});

  @override
  State<Apitest> createState() => _ApitestState();
}

class _ApitestState extends State<Apitest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('api test'),

      ),
      body: Container(
        color: Colors.grey,

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: (){
            getApi();
      }),
      
    );
  }
  void getApi()async{
    Dio dio = Dio();
    final authProvider = context.read<AuthProvider>();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (option,handler){
            return handler.next(option);
        },
        onResponse: (option,handler){

    }
      )
    );
    
    var future = await dio.get('http://10.0.2.2:8081/localHire/employer');
    print(future.data);
  }
}
