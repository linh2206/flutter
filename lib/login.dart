import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:trellocards/detail_page.dart';
import 'package:trellocards/home_page.dart';
import 'package:http/http.dart' as http;

class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final LocalStorage storage = new LocalStorage('test');
  Future<String> _login(_email, _password) async {
    var url = Uri.parse('http://171.244.203.21:2222/api/v1/auth/login');
    var response =
        await http.post(url, body: {'email': _email, 'password': _password});
    Map<String, dynamic> body = jsonDecode(response.body);
    if (body['status'] == "success") {
      // Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
      storage.setItem('token', body['token']);
      _me(body['token']);
    }
    return response.body;
  }

  Future<String> _me(_token) async {
    final token = _token;
    var url = Uri.parse('http://171.244.203.21:2222/api/v1/auth/me');
    Map<String, String> headers = {
      HttpHeaders.contentTypeHeader: "application/json", // or whatever
      HttpHeaders.authorizationHeader: "Bearer $token",
    };
    var response = await http.post(url, headers: headers);
    // print(response.body);
    Map<String, dynamic> body = jsonDecode(response.body);
    if (body['status'] == "success") {
      Navigator.push(context, MaterialPageRoute(builder: (_) => HomePage()));
      storage.setItem('user', body['user']);
    }
    return response.body;
  }

  @override
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.network(
                        "http://171.244.203.21:8888/storage/icons/flutter.png")),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
                controller: _email,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
                controller: _password,
              ),
            ),
            FlatButton(
              onPressed: () {
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(
                    color: Color.fromARGB(255, 32, 145, 238), fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () {
                  _login(_email.text.trim(), _password.text.trim());
                  // Navigator.push(
                  //     context, MaterialPageRoute(builder: (_) => HomePage()));
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}
