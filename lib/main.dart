import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:merge_app/auth_screens/login_screen.dart';
import 'package:merge_app/auth_screens/signup_screen.dart';
import 'package:merge_app/auth_screens/onboarding_screen.dart';
import 'package:merge_app/features/my_diary/utils/colors.dart';
import 'package:merge_app/home_page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        primaryTextTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: GoogleFonts.poppins(),
        ),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: primaryColor,
          secondary: secondaryColor,
        ),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: secondaryColor),
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: secondaryColor,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      initialRoute: '/onboarding',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/auth': (context) => const AuthWrapper(),
        '/signup': (context) => const SignupScreen(),
        '/signin': (context) => const LoginScreen(),
        '/home':
            (context) =>
                HomeScreen(), // Updated to point to the correct HomeScreen
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  User? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? currentUser) async {
      if (currentUser != null) {
        await currentUser.reload();
        setState(() {
          user = FirebaseAuth.instance.currentUser;
          isLoading = false;
        });
      } else {
        setState(() {
          user = null;
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (user != null) {
      if (user!.emailVerified) {
        return HomeScreen(); // Updated to navigate to the correct HomeScreen
      } else {
        return const LoginScreen();
      }
    }

    return const LoginScreen();
  }
}
