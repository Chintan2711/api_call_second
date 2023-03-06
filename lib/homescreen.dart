import 'dart:convert';

import 'package:api_call_second/modal/api_post_modal.dart';
import 'package:api_call_second/modal/character_modal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  List< PostMOdal> postList = [];
  CharecterMOdal? charecterMOdal;
  @override
  void initState() {
    // TODO: implement initState
    getPostsAPI();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: getPostsAPI(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.done || snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return ListView.separated(
                        itemCount: snapshot.data!.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 15),
                        itemBuilder: (context, index) => ListTile(
                          tileColor: Colors.green,
                          title: Text(snapshot.data![index].title!),
                          subtitle: Text(snapshot.data![index].body!),
                        ),
                      );
                    } else {
                      return const Center(child: Text("No Data Found"));
                    }
                  } else {
                    return Text("Connection State: ${snapshot.connectionState}");
                  }
                }),
          ),
         ElevatedButton(
             onPressed: (){
           setPostsAPI();
         },
          child: const Text("Send Data"),
         ),
       ],
     ),
    );
  }
  Future<List<PostMOdal>> getPostsAPI() async {
    Client client = http.Client();
    try {
      Response response = await client.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
      if (response.statusCode == 200) {
        return (jsonDecode(response.body) as List?)!.map((dynamic e) => PostMOdal.fromJson(e)).toList();
        // characterModal = CharacterModal.fromJson(jsonDecode(response.body));
        // debugPrint("characterModal -------------->>> ${characterModal!.toJson()}");
      } else {
        debugPrint("Status Code -------------->>> ${response.statusCode}");
      }
    } finally {
      client.close();
    }
    return [];
  }
  setPostsAPI() async {
    Client client = http.Client();
    try {
      Response response = await client.post(
        Uri.parse("https://jsonplaceholder.typicode.com/posts"),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "userId": 11,
          "it": 101,
          "title": "chintu ukani",
          "body": "Skill Qode",
        }),
      );
      if (response.statusCode == 201) {
        debugPrint("Response -------------->>> ${jsonDecode(response.body)}");
        setState(() {});
      } else {
        debugPrint("Status Code -------------->>> ${response.statusCode}");
      }
    } finally {
      client.close();
    }
  }

  putPostsAPI() async {
    Client client = http.Client();
    try {
      Response response = await client.put(
        Uri.parse("https://jsonplaceholder.typicode.com/posts/1"),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "userId": 11,
          "it": 101,
          "title": "chintu ukani",
          "body": "Skill Qode",
        }),
      );
      debugPrint("Status Code -------------->>> ${response.statusCode}");
      if (response.statusCode == 200) {
        debugPrint("Response -------------->>> ${jsonDecode(response.body)}");
        setState(() {});
      } else {
        debugPrint("Status Code -------------->>> ${response.statusCode}");
      }
    } finally {
      client.close();
    }
  }

  deletePostsAPI() async {
    Client client = http.Client();
    try {
      Response response = await client.delete(Uri.parse("https://jsonplaceholder.typicode.com/posts/1"));
      debugPrint("Status Code -------------->>> ${response.statusCode}");
      if (response.statusCode == 200) {
        debugPrint("Response -------------->>> ${jsonDecode(response.body)}");
      } else {
        debugPrint("Status Code -------------->>> ${response.statusCode}");
      }
    } finally {
      client.close();
    }
  }
}