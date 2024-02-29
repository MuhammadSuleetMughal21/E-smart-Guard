import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:guard/guard_app/home.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:guard/information.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    final url = Uri.parse("http://192.168.198.240:8000/api/signin");
    final response = await http.post(
      headers: {"Content-Type": "application/json"},
      url,
      body: jsonEncode({
        "email": emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      String role = responseData['user']['role'];

      String token = responseData['token'];
      final storage = FlutterSecureStorage();
      await storage.write(key: 'token', value: token);

      String userId = responseData['user']['_id'];
      final storages = FlutterSecureStorage();
      await storages.write(key: 'userId', value: userId);

      if (role == 'Guard') {
        Get.offAll(() =>  home());
      } else {
        Get.snackbar('Error', 'You are not supervisor');
      }
    } else {
      print('Signup failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

  void logOut() async {
    String? userId = await StorageUtil.getUserId();
    String? token = await StorageUtil.getToken();
    final url = Uri.parse("http://192.168.198.240:8000/api/logout/$userId");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json",
      "Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      print(responseData);
    } else {
      print('Signup failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
