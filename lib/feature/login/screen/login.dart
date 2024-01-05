import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wincept/feature/thread/screen/thread.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;
                login(username, password, context);
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

login(String username, String password, BuildContext context) async {
  var headers = {
    'Content-Type': 'application/json',
    'User-Agent': 'insomnia/8.5.0',
    'Authorization': 'Token 44f91df7464f18117c3b52d77cb054bbdf34ee0b'
  };

  var url = 'https://stuverse.shop/api/login/';
  var body = json.encode({"username": username, "password": password});

  try {
    var response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ThreadPage(),
          ));
    } else {
      print('Login failed with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error during login: $e');
  }
}
