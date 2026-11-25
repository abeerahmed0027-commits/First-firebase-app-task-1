import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task1/services/auth.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _isHovered = false;
  bool _isPressed = false;
  String? _errorMessage;

  void _attemptSignUp() async {
    setState(() => _errorMessage = null);

    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().length < 6) {
      setState(() {
        _errorMessage =
        'Please enter a valid email and a password of at least 6 characters.';
      });
      return;
    }

    setState(() => _isLoading = true);

    await _authService.signup(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (FirebaseAuth.instance.currentUser == null) {
      setState(() {
        _errorMessage =
        'This email is already registered or invalid. Please edit it and try again.';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Color(0xFF16A34A),
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _resetErrorAndFocus() {
    setState(() {
      _errorMessage = null;
    });
    _emailFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF2563EB);
    const darkNavy = Color(0xFF0F172A);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Sign Up Page',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: darkNavy,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(28.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 38,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: darkNavy,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Fill in your details to register a new account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) {
                      if (_errorMessage != null) {
                        setState(() => _errorMessage = null);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(Icons.email_outlined),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        const BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    onChanged: (_) {
                      if (_errorMessage != null) {
                        setState(() => _errorMessage = null);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Password (min 6 characters)',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF1F5F9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                        const BorderSide(color: primaryColor, width: 2),
                      ),
                    ),
                  ),

                  // كارت رسالة الخطأ + زرار Try Again
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _errorMessage == null
                        ? const SizedBox.shrink()
                        : Container(
                      key: const ValueKey('signup_error_box'),
                      margin: const EdgeInsets.only(top: 18),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFFFECACA),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                color: Color(0xFFDC2626),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Sign Up Failed',
                                style: TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF991B1B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(
                              fontSize: 12.5,
                              height: 1.4,
                              color: Color(0xFFB91C1C),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: _resetErrorAndFocus,
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFDC2626),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: const Icon(
                                Icons.refresh_rounded,
                                size: 16,
                              ),
                              label: const Text(
                                'Try Again',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  MouseRegion(
                    onEnter: (_) => setState(() => _isHovered = true),
                    onExit: (_) => setState(() => _isHovered = false),
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTapDown: (_) => setState(() => _isPressed = true),
                      onTapUp: (_) => setState(() => _isPressed = false),
                      onTapCancel: () => setState(() => _isPressed = false),
                      child: AnimatedScale(
                        scale: _isPressed ? 0.95 : (_isHovered ? 1.03 : 1.0),
                        duration: const Duration(milliseconds: 160),
                        curve: Curves.easeOut,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 160),
                          width: double.infinity,
                          height: 52,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(
                                  alpha: _isHovered ? 0.45 : 0.25,
                                ),
                                blurRadius: _isHovered ? 18 : 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _attemptSignUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isHovered
                                  ? const Color(0xFF1D4ED8)
                                  : primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : const Text(
                              'Create Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // السطر اللي تحت للرجوع لصفحة Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account?',
                        style: TextStyle(color: Color(0xFF64748B)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}