import 'package:flutter/material.dart';
import 'package:supervisor/Logging/login.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  navigate() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (BuildContext context) => LoginPageState()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary, // Set your desired background color
      body: Center(
        child: Image.asset(
            'assets/images/eSmart.png'), // Replace with the path to your app icon
      ),
    );
  }
}
