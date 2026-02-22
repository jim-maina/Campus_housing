// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:campus_housing/screens/area_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;
  String? _selectedRole;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (_formKey.currentState!.validate() && _selectedRole != null) {
      setState(() => _isLoading = true);

      try {
        final auth = context.read<AuthProvider>();
        bool success = false;

        if (_selectedRole == 'student') {
          success = await auth.signupStudent(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            phone: _phoneController.text.trim(),
          );
        } else {
          success = await auth.signupLandlord(
            email: _emailController.text.trim(),
            password: _passwordController.text,
            phone: _phoneController.text.trim(),
          );
        }

        if (success && mounted) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => AreasPage()));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  /// GLASS ROLE CARD
  Widget _roleCard(String title, IconData icon, String value) {
    final isSelected = _selectedRole == value;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = value),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.deepPurple.withOpacity(0.6)
                  : Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/picture 1.png'), // your asset path
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// DARK OVERLAY
          Container(color: Colors.black.withOpacity(0.3)),

          /// CONTENT
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// GLASS FORM
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              /// EMAIL
                              TextFormField(
                                controller: _emailController,
                                style: const TextStyle(color: Colors.white),
                                decoration: _glassInput("Email", Icons.email),
                                validator: (v) =>
                                    v!.isEmpty ? "Email required" : null,
                              ),
                              const SizedBox(height: 16),

                              /// PASSWORD
                              TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                style: const TextStyle(color: Colors.white),
                                decoration: _glassInput("Password", Icons.lock),
                                validator: (v) =>
                                    v!.length < 6 ? "Min 6 characters" : null,
                              ),
                              const SizedBox(height: 16),

                              /// PHONE
                              TextFormField(
                                controller: _phoneController,
                                style: const TextStyle(color: Colors.white),
                                decoration: _glassInput("Phone", Icons.phone),
                                validator: (v) =>
                                    v!.isEmpty ? "Phone required" : null,
                              ),
                              const SizedBox(height: 20),

                              /// BUTTON
                              ElevatedButton(
                                onPressed: _isLoading ? null : _handleSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(
                                    0.25,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 40,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text("Create Account"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// ROLE CARDS
                  Row(
                    children: [
                      Expanded(
                        child: _roleCard("Landlord", Icons.home, "landlord"),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _roleCard("Student", Icons.school, "student"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// LOGIN LINK
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                    ),
                    child: const Text(
                      "Already have an account? Login",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// GLASS INPUT DECORATION
  InputDecoration _glassInput(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.white),
      filled: true,
      fillColor: Colors.white.withOpacity(0.15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
