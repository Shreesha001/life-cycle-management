import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'email-already-in-use':
            message = 'The email address is already in use.';
            break;
          case 'invalid-email':
            message = 'Invalid email format.';
            break;
          case 'weak-password':
            message = 'The password is too weak.';
            break;
          default:
            message = 'An error occurred. Please try again.';
        }
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/bottom_wave.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.04,
                        vertical: screenHeight * 0.015,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/signin');
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                color: const Color(0xFF464f84),
                                fontSize: screenWidth * 0.04,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                color: const Color(0xFF464f84),
                                fontSize: screenWidth * 0.04,
                                decoration: TextDecoration.underline,
                                decorationThickness: 2,
                                decorationColor: const Color(0xFF464f84),
                                decorationStyle: TextDecorationStyle.solid,

                                // Adding padding between text and underline
                                // underlinePadding: 2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.08),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CREATE AN ACCOUNT',
                            style: TextStyle(
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF464f84),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Text(
                            'Join us Today',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: const Color(0xFF464f84),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.06),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.email,
                                    color: Color(0xFFffb74d),
                                  ),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                  ).hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Color(0xFFffb74d),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFFffb74d),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                                  ),
                                  hintText: 'Password',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.03),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                obscureText: _obscureConfirmPassword,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Color(0xFFffb74d),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: const Color(0xFFffb74d),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscureConfirmPassword =
                                            !_obscureConfirmPassword;
                                      });
                                    },
                                  ),
                                  hintText: 'Confirm Password',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: screenWidth * 0.04,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.05),
                            _isLoading
                                ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF464f84),
                                  ),
                                )
                                : ElevatedButton(
                                  onPressed: _signup,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF464f84),
                                    minimumSize: Size(
                                      double.infinity,
                                      screenHeight * 0.07,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                  ),
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signin');
                      },
                      child: Text(
                        'Already have an account? Sign In',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: const Color(0xFF464f84),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
