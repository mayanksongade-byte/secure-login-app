import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> resetPassword() async {

    if (emailController.text.trim().isEmpty) {
      showError("Please enter email");
      return;
    }

    setState(() => isLoading = true);

    try {

      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: emailController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Reset link sent 📧"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {

      if (e.code == 'user-not-found') {
        showError("No user found with this email");
      } else if (e.code == 'invalid-email') {
        showError("Invalid email format");
      } else {
        showError(e.message ?? "Error sending email");
      }

    } finally {

      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,

      style: const TextStyle(
        color: Colors.white,
      ),

      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),

        hintText: hint,

        hintStyle: const TextStyle(
          color: Colors.white54,
        ),

        filled: true,

        fillColor: Colors.white.withOpacity(0.10),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),

          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.15),
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),

          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.15),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),

          borderSide: const BorderSide(
            color: Colors.cyanAccent,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,

      child: Container(
        width: double.infinity,
        height: 55,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          gradient: const LinearGradient(
            colors: [
              Color(0xff22D3EE),
              Color(0xff8B5CF6),
              Color(0xffEC4899),
            ],
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.purpleAccent.withOpacity(0.30),
              blurRadius: 25,
              spreadRadius: 2,
            ),
          ],
        ),

        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(
            color: Colors.white,
          )
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
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

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(

              padding: const EdgeInsets.all(22),

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(28),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),

                  color: Colors.white.withOpacity(0.10),

                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                  ),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.25),
                      blurRadius: 35,
                      spreadRadius: 3,
                    ),
                  ],
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [

                    Image.asset(
                      "assets/Splash_screen.png",
                      width: 120,
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      "Forgot Password 🔐",

                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Enter your email to reset password",

                      textAlign: TextAlign.center,

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 35),

                    buildTextField(
                      hint: "Email",
                      icon: Icons.email,
                      controller: emailController,
                    ),

                    const SizedBox(height: 28),

                    buildButton(
                      "Send Reset Link",
                      resetPassword,
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