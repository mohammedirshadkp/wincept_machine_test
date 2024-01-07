import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../thread/screen/thread.dart';

final loginRepositoryProvider = Provider((ref) => LoginRepository());

class LoginRepository {
  Future<void> login(
      String username, String password, BuildContext context) async {
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
}
