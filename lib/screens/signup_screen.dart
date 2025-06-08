import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';

import 'home_screen.dart'; // Import HomeScreen for routeName
import 'splash_screen.dart'; // Import SplashScreen for routeName
import '../const/colors.dart'; // Import AppColor

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String routeName =
      '/signup'; // Define routeName

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? errorMessage;
  bool isLoading = false;

  Future<void> _signUp() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      if (mounted) {
        // Use pushReplacementNamed with HomeScreen.routeName
        Navigator.of(
          context,
        ).pushReplacementNamed(SplashScreen.routeName);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFEFFDFE),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(
              context,
            ).pop(); // Navigates back to LoginScreen
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColor.primary,
        ), // Consistent icon color
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Heading
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "Ready to ResQ?",
                style: theme.textTheme.headlineMedium,
              ),
            ),
            // Center(
            //   child:
            // ),

            // Form (scrollable)
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/animation/drone.json',
                        width: 300,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 12.0,
                          ),
                          child: Text(
                            errorMessage!,
                            style: theme
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontStyle:
                                      FontStyle.italic,
                                  color: Colors.red,
                                ),
                          ),
                        ),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                            onPressed: _signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(
                                    255,
                                    236,
                                    88,
                                    88,
                                  ),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 14,
                                  ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                      30,
                                    ),
                                side: BorderSide(
                                  color:
                                      Colors.red.shade900,
                                  width: 2,
                                ),
                              ),
                              textStyle: theme
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                            ),
                            child: const Text(
                              "Lets Save Lives!",
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer Quote
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(
                "“Next to creating a life, the finest thing a man can do is save one.”",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
