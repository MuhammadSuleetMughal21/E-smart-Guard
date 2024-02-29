import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supervisor/Logging/login.dart';
import 'package:supervisor/controller/loginController.dart';

// ignore: must_be_immutable
class SignUpState extends GetView<LoginController> {
  SignUpState({super.key});
  LoginController controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        actions: [
          IconButton(onPressed: (){
            Get.offAll(LoginPageState());
          }, icon: const Icon(Icons.arrow_back),
          alignment: Alignment.topLeft,)
        ],
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/eSmart.png',
                width: 250,
                height: 190,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 360,
                child: TextField(
                  controller: controller.firstNameController,
                  decoration: const InputDecoration(
                    hintText: 'First Name',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(height: 15, width: 5),
              SizedBox(
                width: 365,
                child: TextField(
                  controller: controller.lastNameController,
                  decoration: const InputDecoration(
                    hintText: 'Last Name',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(height: 15, width: 5),
              SizedBox(
                width: 365,
                child: TextField(
                  controller: controller.emailController,
                  decoration: const InputDecoration(
                    hintText: 'E-mail',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(height: 15, width: 5),
              SizedBox(
                width: 365,
                child: TextField(
                  controller: controller.passwordController,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(height: 15, width: 5),
              SizedBox(
                width: 365,
                child: TextField(
                  controller: controller.phoneNumberController,
                  decoration: const InputDecoration(
                    hintText: 'Phone Number',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(height: 15, width: 5),
              SizedBox(
                width: 365,
                child: TextField(
                  controller: controller.roleController,
                  decoration: const InputDecoration(
                    hintText: 'Role',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  if (controller.firstNameController.text.isNotEmpty &&
                      controller.lastNameController.text.isNotEmpty &&
                      controller.passwordController.text.isNotEmpty &&
                      controller.emailController.text.isNotEmpty &&
                      controller.phoneNumberController.text.isNotEmpty &&
                      controller.roleController.text.isNotEmpty) {
                    controller.signUp();
                  } else {
                    print('the values are null');
                  }
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 250,
              )
            ],
          ),
        ),
      ),
    );
  }
}
