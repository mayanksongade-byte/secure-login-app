import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

bool isValidEmail(String email) {
  return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
}

String getFirebaseErrorMessage(String code) {
  switch (code) {
    case 'invalid-email':
      return "Invalid email format";
    case 'user-not-found':
      return "No account found with this email";
    case 'wrong-password':
      return "Incorrect password";
    case 'invalid-credential':
      return "Email or password is incorrect";
    case 'email-already-in-use':
      return "This email is already registered";
    case 'weak-password':
      return "Password is too weak";
    case 'network-request-failed':
      return "No internet connection";
    default:
      return "Something went wrong";
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff030712),
            Color(0xff1E1B4B),
            Color(0xff6D28D9),
            Color(0xffDB2777),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: child,
    );
  }
}

class AnimatedBorderBox extends StatefulWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final bool animate;

  const AnimatedBorderBox({
    super.key,
    required this.child,
    required this.borderRadius,
    required this.padding,
    this.animate = true,
  });

  @override
  State<AnimatedBorderBox> createState() => _AnimatedBorderBoxState();
}

class _AnimatedBorderBoxState extends State<AnimatedBorderBox>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    if (widget.animate) controller.repeat();
  }

  @override
  void didUpdateWidget(covariant AnimatedBorderBox oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animate && !controller.isAnimating) {
      controller.repeat();
    } else if (!widget.animate && controller.isAnimating) {
      controller.stop();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: SweepGradient(
              transform: GradientRotation(controller.value * 2 * pi),
              colors: widget.animate
                  ? const [
                      Color(0xff22D3EE),
                      Color(0xff8B5CF6),
                      Color(0xffEC4899),
                      Color(0xff22D3EE),
                    ]
                  : [
                      Colors.white.withOpacity(0.18),
                      Colors.white.withOpacity(0.18),
                    ],
            ),
          ),
          child: Container(
            padding: widget.padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius - 2),
              color: const Color(0xff1E1B4B).withOpacity(0.82),
            ),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class AnimatedAuthTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final Function(String)? onChanged;

  const AnimatedAuthTextField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  State<AnimatedAuthTextField> createState() => _AnimatedAuthTextFieldState();
}

class _AnimatedAuthTextFieldState extends State<AnimatedAuthTextField> {
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBorderBox(
      borderRadius: 22,
      padding: EdgeInsets.zero,
      animate: focusNode.hasFocus,
      child: TextFormField(
        focusNode: focusNode,
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: widget.obscureText,
        style: const TextStyle(color: Colors.white),
        validator: widget.validator,
        decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon,
            color: focusNode.hasFocus ? Colors.cyanAccent : Colors.white70,
          ),
          suffixIcon: widget.suffixIcon,
          hintText: widget.hint,
          hintStyle: const TextStyle(color: Colors.white54),
          filled: true,
          fillColor: Colors.transparent,
          errorStyle: const TextStyle(color: Colors.yellowAccent),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

Widget authTextField({
  required String hint,
  required IconData icon,
  required TextEditingController controller,
  required String? Function(String?) validator,
  bool obscureText = false,
  Widget? suffixIcon,
  Function(String)? onChanged,
}) {
  return AnimatedAuthTextField(
    hint: hint,
    icon: icon,
    controller: controller,
    validator: validator,
    obscureText: obscureText,
    suffixIcon: suffixIcon,
    onChanged: onChanged,
  );
}

Widget glowButton({
  required String text,
  required bool isLoading,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: isLoading ? null : onTap,
    child: Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xff22D3EE), Color(0xff8B5CF6), Color(0xffEC4899)],
        ),
      ),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    ),
  );
}

Widget authCard({required Widget child}) {
  return AnimatedBorderBox(
    borderRadius: 34,
    padding: const EdgeInsets.all(25),
    animate: true,
    child: child,
  );
}

// ---------------- LOGIN PAGE ----------------

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isPasswordHidden = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void showSnack(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              HomePage(email: FirebaseAuth.instance.currentUser!.email ?? ""),
        ),
      );
    } on FirebaseAuthException catch (e) {
      showSnack(getFirebaseErrorMessage(e.code), Colors.red);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AppBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: authCard(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/Splash_screen.png",
                      width: 120,
                      height: 120,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Login to continue securely",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const SizedBox(height: 35),
                    authTextField(
                      hint: "Email",
                      icon: Icons.email,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email is required";
                        }
                        if (!isValidEmail(value.trim())) {
                          return "Please enter valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    authTextField(
                      hint: "Password",
                      icon: Icons.lock,
                      controller: passwordController,
                      obscureText: isPasswordHidden,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.cyanAccent),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    glowButton(
                      text: "Login",
                      isLoading: isLoading,
                      onTap: login,
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white70),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignupPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Signup",
                            style: TextStyle(
                              color: Colors.cyanAccent,
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
      ),
    );
  }
}

// ---------------- SIGNUP PAGE ----------------

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isPasswordHidden = true;
  bool isLoading = false;
  String passwordStrength = "";
  Color strengthColor = Colors.red;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showSnack(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  void checkPasswordStrength(String password) {
    setState(() {
      if (password.isEmpty) {
        passwordStrength = "";
      } else if (password.length < 6) {
        passwordStrength = "Weak";
        strengthColor = Colors.red;
      } else if (password.length < 10) {
        passwordStrength = "Medium";
        strengthColor = Colors.orange;
      } else {
        passwordStrength = "Strong";
        strengthColor = Colors.green;
      }
    });
  }

  Future<void> signup() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.user!.uid)
          .set({
            "email": emailController.text.trim(),
            "createdAt": FieldValue.serverTimestamp(),
          });

      if (!mounted) return;

      showSnack("Account created successfully 🎉", Colors.green);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              HomePage(email: FirebaseAuth.instance.currentUser!.email ?? ""),
        ),
      );
    } on FirebaseAuthException catch (e) {
      showSnack(getFirebaseErrorMessage(e.code), Colors.red);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AppBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: authCard(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "assets/Splash_screen.png",
                      width: 110,
                      height: 110,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Join the secure experience",
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const SizedBox(height: 35),
                    authTextField(
                      hint: "Email",
                      icon: Icons.email,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email is required";
                        }
                        if (!isValidEmail(value.trim())) {
                          return "Please enter valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    if (passwordStrength.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Password Strength: $passwordStrength",
                            style: TextStyle(
                              color: strengthColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    authTextField(
                      hint: "Password",
                      icon: Icons.lock,
                      controller: passwordController,
                      onChanged: checkPasswordStrength,
                      obscureText: isPasswordHidden,
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.white70,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 6) {
                          return "Password must be at least 6 characters";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    authTextField(
                      hint: "Confirm Password",
                      icon: Icons.lock_outline,
                      controller: confirmPasswordController,
                      obscureText: isPasswordHidden,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Confirm password is required";
                        }
                        if (value.trim() != passwordController.text.trim()) {
                          return "Password does not match";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    glowButton(
                      text: "Signup",
                      isLoading: isLoading,
                      onTap: signup,
                    ),
                    const SizedBox(height: 18),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Already have an account? Login",
                        style: TextStyle(color: Colors.cyanAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- FORGOT PASSWORD PAGE ----------------

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void showSnack(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      if (!mounted) return;

      showSnack("Reset link sent 📧", Colors.green);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      showSnack(getFirebaseErrorMessage(e.code), Colors.red);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AppBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: authCard(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.lock_reset,
                      size: 85,
                      color: Colors.cyanAccent,
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Enter your email to reset your password",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const SizedBox(height: 35),
                    authTextField(
                      hint: "Email",
                      icon: Icons.email,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email is required";
                        }
                        if (!isValidEmail(value.trim())) {
                          return "Please enter valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    glowButton(
                      text: "Send Reset Link",
                      isLoading: isLoading,
                      onTap: resetPassword,
                    ),
                    const SizedBox(height: 18),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Back to Login",
                        style: TextStyle(color: Colors.cyanAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- HOME PAGE ----------------

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;

  Future<void> logout() async {
    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Logout failed: $e")));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      "Home",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Spacer(),
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : IconButton(
                            onPressed: logout,
                            icon: const Icon(Icons.logout, color: Colors.white),
                          ),
                  ],
                ),
                const Spacer(),
                AnimatedBorderBox(
                  borderRadius: 35,
                  padding: EdgeInsets.zero,
                  animate: true,
                  child: SizedBox(
                    width: double.infinity,
                    height: 360,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/Splash_screen.png",
                          width: 135,
                          height: 135,
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          "Welcome 🎉",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Text(
                            widget.email,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                const Text(
                  "Powered by Firebase 🔥",
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
