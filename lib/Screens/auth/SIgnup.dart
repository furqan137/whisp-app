import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Login.dart';
import 'emailauthentication.dart';
import 'security_question_2fa.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final usersRef = FirebaseFirestore.instance.collection('users');

  bool _isLoading = false;
  String? _error;

  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _fadeCtrl =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ------------------------- GENERATE USERNAME --------------------------
  String _generateUsername() {
    const letters = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    final r = Random();

    final part1 = List.generate(
      4 + r.nextInt(3),
      (_) => letters[r.nextInt(letters.length)],
    ).join();

    final part2 = List.generate(
      3 + r.nextInt(3),
      (_) => numbers[r.nextInt(numbers.length)],
    ).join();

    return "${part1}_$part2";
  }

  Future<bool> _checkUsername(String u) async {
    final q = await usersRef.where("username", isEqualTo: u).limit(1).get();
    return q.docs.isNotEmpty;
  }

  // ------------------------- VALIDATION + SIGNUP ------------------------
  Future<void> _signup() async {
    FocusScope.of(context).unfocus();

    final username = _usernameController.text.trim();
    final fullname = _nameController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmPasswordController.text.trim();

    setState(() => _error = null);

    if (username.isEmpty || fullname.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() => _error = "Please fill all fields");
      return;
    }

    if (password.length < 6) {
      setState(() => _error = "Password must be at least 6 characters");
      return;
    }

    if (password != confirm) {
      setState(() => _error = "Passwords do not match");
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check username
      if (await _checkUsername(username)) {
        setState(() {
          _isLoading = false;
          _error = "⚠️ Username already taken!";
        });
        return;
      }

      if (!mounted) return;

      // Step 2 → Security Question
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SecurityQuestion2FA(
            uid: "", // signup mode
            isForPasswordReset: false,
            isForLoginVerify: false,
            onComplete: (qa) {
              // Move to Email Verification Page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => EmailAuthenticationPage(
                    username: username,
                    password: password,
                    name: fullname,
                    deviceToken: null,
                    securityQuestion: qa['question'],
                    securityAnswer: qa['answer'],
                  ),
                ),
              );
            },
          ),
        ),
      );
    } catch (e) {
      setState(() => _error = "Signup failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ------------------------- FIELD WIDGET -------------------------
  Widget _field(TextEditingController c, String hint,
      {bool isPassword = false, Widget? suffix}) {
    const gradient = LinearGradient(
      colors: [Color(0xFF6D5DF6), Color(0xFF3C8CE7)],
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: gradient),
      child: Container(
        margin: const EdgeInsets.all(2.3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFF101526),
        ),
        child: TextField(
          controller: c,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            suffixIcon: suffix,
          ),
        ),
      ),
    );
  }

  // ------------------------ UI BUILD -------------------------
  @override
  Widget build(BuildContext context) {
    const gradient = LinearGradient(
      colors: [Color(0xFF6D5DF6), Color(0xFF3C8CE7)],
    );

    return Scaffold(
      backgroundColor: const Color(0xFF101526),
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Montserrat",
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 30),

                // username
                _field(
                  _usernameController,
                  "Username",
                  suffix: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: () async {
                      String u = _generateUsername();
                      while (await _checkUsername(u)) {
                        u = _generateUsername();
                      }
                      setState(() => _usernameController.text = u);
                    },
                  ),
                ),

                // full name
                _field(_nameController, "Full Name"),

                // password
                _field(_passwordController, "Password", isPassword: true),

                // confirm password
                _field(_confirmPasswordController, "Confirm Password",
                    isPassword: true),

                const SizedBox(height: 10),

                if (_error != null)
                  Text(
                    _error!,
                    style: const TextStyle(color: Colors.redAccent),
                    textAlign: TextAlign.center,
                  ),

                const SizedBox(height: 18),

                // signup button
                SizedBox(
                  height: 48,
                  width: 250,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: gradient,
                    ),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Continue",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                const Divider(color: Colors.white12),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: ShaderMask(
                    shaderCallback: (bounds) => gradient.createShader(bounds),
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
