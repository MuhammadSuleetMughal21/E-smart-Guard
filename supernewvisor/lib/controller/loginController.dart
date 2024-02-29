import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:supervisor/sup_home.dart';
import 'package:http/http.dart' as http;
import "dart:convert";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final roleController = TextEditingController();

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

      if (role == 'Supervisor') {
        Get.offAll(() =>  SupHomeScreen());
      } else {
        Get.snackbar('Error', 'You are not supervisor');
      }
    } else {
      print('Signup failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

   Future<void> signUp() async {
    final url = Uri.parse("http://192.168.198.240:8000/api/signup");
    final response = await http.post(
        headers: {"Content-Type": "application/json"},
        url,
        body: jsonEncode({
          "first_name": firstNameController.text,
          'last_name': lastNameController.text,
          "email": emailController.text,
          'password': passwordController.text,
          'phone_number': phoneNumberController.text,
          'role': roleController.text,
        }));

    if (response.statusCode == 200) {
      print('Signup successful');
      
       Get.offAll(() =>  SupHomeScreen());
      
    } else {
      // Handle errors here, e.g., show an error message.

      print('Signup failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
  

}
