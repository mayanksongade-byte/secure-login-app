import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

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
      duration: const Duration(milliseconds: 1800),
    );

    rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 9),
    )..repeat();

    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: introController, curve: Curves.easeIn),
    );

    scale = Tween<double>(begin: 0.65, end: 1).animate(
      CurvedAnimation(parent: introController, curve: Curves.easeOutBack),
    );

    pulse = Tween<double>(begin: 0.95, end: 1.05).animate(
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
    required double top,
    required double left,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withOpacity(0.55),
              color.withOpacity(0.01),
            ],
          ),
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
              Color(0xff172554),
              Color(0xff581C87),
              Color(0xffBE185D),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            glowCircle(
              size: 360,
              color: Colors.cyanAccent,
              top: -130,
              left: -120,
            ),
            glowCircle(
              size: 300,
              color: Colors.pinkAccent,
              top: 560,
              left: 210,
            ),
            glowCircle(
              size: 190,
              color: Colors.purpleAccent,
              top: 210,
              left: 300,
            ),

            Center(
              child: FadeTransition(
                opacity: fade,
                child: ScaleTransition(
                  scale: scale,
                  child: GlassmorphicContainer(
                    width: 340,
                    height: 520,
                    borderRadius: 35,
                    blur: 20,
                    alignment: Alignment.center,
                    border: 1.5,
                    linearGradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.18),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.45),
                        Colors.white.withOpacity(0.08),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ScaleTransition(
                              scale: pulse,
                              child: Container(
                                width: 250,
                                height: 250,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.cyanAccent.withOpacity(0.35),
                                      blurRadius: 45,
                                      spreadRadius: 8,
                                    ),
                                    BoxShadow(
                                      color: Colors.pinkAccent.withOpacity(0.28),
                                      blurRadius: 55,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            RotationTransition(
                              turns: rotateController,
                              child: Container(
                                width: 255,
                                height: 255,
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
                                ),
                              ),
                            ),

                            Container(
                              width: 218,
                              height: 218,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xff020617),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.18),
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Image.asset(
                                  "assets/Splash_screen.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 32),

                        ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [
                                Colors.white,
                                Color(0xffC4B5FD),
                                Color(0xff67E8F9),
                              ],
                            ).createShader(bounds);
                          },
                          child: AnimatedTextKit(
                            repeatForever: true,
                            animatedTexts: [
                              TyperAnimatedText(
                                "Secure Login",
                                speed: const Duration(milliseconds: 110),
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Firebase Auth • Fast • Safe",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.8,
                          ),
                        ),

                        const SizedBox(height: 35),

                        GlassmorphicContainer(
                          width: 230,
                          height: 50,
                          borderRadius: 30,
                          blur: 12,
                          alignment: Alignment.center,
                          border: 1,
                          linearGradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.14),
                              Colors.white.withOpacity(0.04),
                            ],
                          ),
                          borderGradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.35),
                              Colors.white.withOpacity(0.08),
                            ],
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 17,
                                height: 17,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.4,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                "Getting things ready...",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const Positioned(
              bottom: 24,
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