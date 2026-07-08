import 'package:flutter/material.dart';
import '../main.dart';

class AuraFitSplashScreen extends StatefulWidget {
  const AuraFitSplashScreen({super.key});

  @override
  State<AuraFitSplashScreen> createState() => _AuraFitSplashScreenState();
}

class _AuraFitSplashScreenState extends State<AuraFitSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() { // Fixed the typo here!
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    // Routes automatically over to the Main Homepage after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const FitnessHomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF090D16),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background ambient engine glow matching layout spec
          Positioned(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2DD4BF).withOpacity(0.06),
              ),
            ),
          ),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2DD4BF).withOpacity(0.05),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF2DD4BF).withOpacity(0.2), width: 2),
                  ),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    size: 64,
                    color: Color(0xFF2DD4BF),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'AuraFit Neo',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Future of Motion Tracking',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}