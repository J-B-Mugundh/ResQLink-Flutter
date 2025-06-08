import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import flutter_dotenv
import './const/colors.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'firebase_options.dart';
import 'screens/report_screen.dart';
import 'screens/request_supplies_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load .env file
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions
            .currentPlatform, // Add this options parameter
  );
  runApp(const MyApp()); // Add const here
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResQLink First Responder App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Montserrat",
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.main,
            shape: const StadiumBorder(),
            elevation: 0,
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColor.main,
          ),
        ),

        textTheme: TextTheme(
          headlineSmall: TextStyle(
            color: AppColor.primary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: AppColor.secondary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          titleLarge: TextStyle(
            color: AppColor.primary,
            fontWeight: FontWeight.normal,
            fontSize: 25,
          ),
          headlineMedium: TextStyle(
            color: AppColor.primary,
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(color: AppColor.primary),
        ),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/signup': (context) => SignUpScreen(),
        '/notifications':
            (context) => NotificationsScreen(),
        '/profile': (context) => ProfileScreen(),
        '/splash': (context) => SplashScreen(),
        '/report-incident':
            (context) => const ReportScreen(),
        '/request-supplies':
            (context) => const RequestSuppliesScreen(),
      },
    );
  }
}
