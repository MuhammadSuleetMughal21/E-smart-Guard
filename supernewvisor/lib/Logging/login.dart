import 'package:flutter/material.dart';
// import 'package:supervisor/Logging/register.dart';
import 'package:get/get.dart';
import 'package:supervisor/Logging/register.dart';
import 'package:supervisor/controller/loginController.dart';


class LoginPageState extends GetView<LoginController> {
    final LoginController loginController = Get.put(LoginController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 45,
            ),
            Image.asset(
              'assets/images/eSmart.png',
              width: 250,
              height: 250,
              // alignment: Alignment.topCenter,
            ),
            // const SizedBox(height: 20),
            TextField(
              controller: controller.emailController,
              decoration: const InputDecoration(
                hintText: 'E-mail',
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 10, width: 5),
            TextField(
              controller: controller.passwordController,
              decoration: const InputDecoration(
                hintText: 'password',
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)),
                hintStyle: TextStyle(
                  color: Colors.white,
                ),
                prefixIcon: Icon(Icons.lock, color: Colors.white),
              ),
              obscureText: true,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (controller.passwordController.text.isNotEmpty &&
                    controller.emailController.text.isNotEmpty) {
                  loginController.login();
                } else {
                  print('the values are null');
                }
              },
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                 Get.offAll(() => SignUpState());
              },
              child: const Text(
                'Register',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
