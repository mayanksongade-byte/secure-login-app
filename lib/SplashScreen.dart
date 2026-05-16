import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController introController;
  late AnimationController rotateController;
  late AnimationController pulseController;

  late Animation<double> fade;
  late Animation<double> scale;
  late Animation<double> pulse;

  @override
  void initState() {
    super.initState();

    introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);

    fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: introController, curve: Curves.easeIn),
    );

    scale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: introController, curve: Curves.easeOutBack),
    );

    pulse = Tween<double>(begin: 0.96, end: 1.06).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );

    introController.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => user == null
              ? const LoginPage()
              : HomePage(email: user.email ?? ""),
        ),
      );
    });
  }

  @override
  void dispose() {
    introController.dispose();
    rotateController.dispose();
    pulseController.dispose();
    super.dispose();
  }

  Widget glowCircle({
    required double size,
    required Color color,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.55),
            color.withOpacity(0.02),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff020617),
              Color(0xff111827),
              Color(0xff312E81),
              Color(0xff7C3AED),
              Color(0xffDB2777),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: -120,
              child: glowCircle(size: 360, color: Colors.cyanAccent),
            ),
            Positioned(
              bottom: -130,
              right: -110,
              child: glowCircle(size: 390, color: Colors.pinkAccent),
            ),
            Positioned(
              top: 210,
              right: -90,
              child: glowCircle(size: 230, color: Colors.purpleAccent),
            ),

            Center(
              child: FadeTransition(
                opacity: fade,
                child: ScaleTransition(
                  scale: scale,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: pulse,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            RotationTransition(
                              turns: rotateController,
                              child: Container(
                                width: 310,
                                height: 310,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: SweepGradient(
                                    transform: const GradientRotation(pi / 4),
                                    colors: [
                                      Colors.cyanAccent.withOpacity(0.95),
                                      Colors.purpleAccent.withOpacity(0.95),
                                      Colors.pinkAccent.withOpacity(0.95),
                                      Colors.cyanAccent.withOpacity(0.95),
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyanAccent.withOpacity(0.22),
                                      blurRadius: 40,
                                      spreadRadius: 5,
                                    ),
                                    BoxShadow(
                                      color:
                                      Colors.purpleAccent.withOpacity(0.30),
                                      blurRadius: 55,
                                      spreadRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Container(
                              width: 255,
                              height: 255,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withOpacity(0.12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.28),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.35),
                                    blurRadius: 35,
                                    offset: const Offset(0, 18),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                "assets/Splash_screen.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 42),

                      const Text(
                        "Secure Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Modern Firebase Authentication",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.7,
                        ),
                      ),

                      const SizedBox(height: 45),

                      Container(
                        width: 240,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(seconds: 3),
                          builder: (context, value, child) {
                            return FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: value,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xff22D3EE),
                                      Color(0xffA855F7),
                                      Color(0xffEC4899),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 18),

                      const Text(
                        "Securing your session...",
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const Positioned(
              bottom: 28,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Powered by Firebase 🔥",
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}