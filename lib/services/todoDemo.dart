

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/apiModel/postsSocials.dart';

class todo extends StatefulWidget {
  const todo({super.key});

  @override
  State<todo> createState() => _todoState();
}

class _todoState extends State<todo> {
  List<Post> postList =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text('todo demo'),
    ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(

                  itemCount: postList.length,
                  itemBuilder: (context,index){
                      return Card(
                        color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('id: ${postList[index].id}'),
                              Text('title: ${postList[index].title}'),
                              Text('body: ${postList[index].body}'),
                            ],
                          ),
                        ),
                      );
              }),
            ),
            ElevatedButton(onPressed: (){
              getTodos();
            },
                child: Text('get data'))
          ],
        ),
      ),
    );
  }

    void getTodos() async {
      try {
        final dio = Dio(
          BaseOptions(validateStatus: (status) => true),
        );

        final response = await dio.get('https://dummyjson.com/posts');

        if(response.statusCode==200){
         final List<Post> loadedList = (response.data['posts'] as List)
             .map((e)=>Post.fromJson(e))
             .toList();

         setState(() {
           postList = loadedList;
         });
        }


        print("Status code: ${response.statusCode}");
        // print('-------------------------------------------------------------------');
        print(response.data);
      } catch (e) {
        print(e);
      }

  }
}
