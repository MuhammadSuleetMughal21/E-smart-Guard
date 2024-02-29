import 'package:flutter/material.dart';
import 'package:supervisor/Logging/login.dart';
import 'package:get/get.dart';
import 'package:supervisor/controller/guardListController.dart';
import 'package:supervisor/splash.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 59, 130, 176),
);

void main() => runApp(const LoginPageApp());

class LoginPageApp extends StatelessWidget {
  const LoginPageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
  Get.put(GuardListController());
}),
      
      theme: ThemeData().copyWith(
        useMaterial3: true,
        colorScheme: kColorScheme,
        appBarTheme: const AppBarTheme().copyWith(
          foregroundColor: kColorScheme.onPrimary,
          backgroundColor: kColorScheme.onPrimaryContainer,
        ),
        cardTheme: const CardTheme().copyWith(
          color: kColorScheme.secondaryContainer,
          margin: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              backgroundColor: kColorScheme.primaryContainer,
              foregroundColor: kColorScheme.onPrimaryContainer),
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 3, 83, 101),
        textTheme: ThemeData().textTheme.copyWith(
              titleLarge: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: kColorScheme.onSecondaryContainer,
              ),
            ),
      ),
      home: const Splash(),
    );
  }
}
