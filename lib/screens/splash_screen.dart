import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import LandingScreen for routeName

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName =
      '/splash'; // ✅ Define routeName
  @override
  State<SplashScreen> createState() => _SplashScreenState(); // ✅ Corrected way to create state
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer; // ✅ Fixed null safety issue

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 3000), () {
      Navigator.of(
        context,
      ).pushReplacementNamed(HomeScreen.routeName);
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // ✅ Prevents memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(
          context,
        ).size.width; // Get screen width

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFEFFDFE),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/images/logo-full.png", // ✅ Tree Logo
                width:
                    screenWidth *
                    0.95, // ✅ 95% of screen width
              ),
            ],
          ),
        ),
      ),
    );
  }
}
