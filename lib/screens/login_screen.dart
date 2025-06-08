import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// import 'signup_screen.dart'; // Import SignUpScreen for routeName
// import 'home_screen.dart'; // Import HomeScreen for routeName
import 'splash_screen.dart';
import '../const/colors.dart'; // Import AppColor
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName =
      '/login'; // Define routeName

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? errorMessage;
  bool isLoading = false;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
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
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(
        0xFFEFFDFE,
      ), // very light pastel red
      appBar: AppBar(
        automaticallyImplyLeading:
            false, // To remove the default back button
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: AppColor.primary,
        ), // Consistent icon color
      ),
      resizeToAvoidBottomInset:
          false, // prevent screen shift on keyboard open
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                "Welcome Back",
                style: theme.textTheme.headlineMedium,
              ),
            ),

            // Login Form (scrollable in case screen is small)
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
                            onPressed: _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(
                                    255,
                                    236,
                                    88,
                                    88,
                                  ), // soft red
                              foregroundColor:
                                  Colors
                                      .white, // text color
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
                                  width: 3,
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
                            child: const Text("Login"),
                          ),
                      // TextButton(
                      //   onPressed: () {
                      //     // Use pushNamed with SignUpScreen.routeName
                      //     Navigator.of(context).pushNamed(
                      //       SignUpScreen.routeName,
                      //     );
                      //   },
                      //   child: const Text(
                      //     "Don't have an account? Sign Up",
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),

            // Quote at the bottom
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
