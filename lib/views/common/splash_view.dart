import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      // Navigate to onboarding (will be implemented next)
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.backgroundCream,
      body: SafeArea(
        child: Stack(
          children: [
            // Full-screen background with bottom-left alignment and subtle overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppThemes.backgroundCream,
                  image: DecorationImage(
                    image: const AssetImage('assets/images/splash/splash_bg.png'),
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomLeft,
                    // subtle darkening so center text remains readable
                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.08), BlendMode.darken),
                  ),
                ),
                // fallback in case the asset is missing
                child: Image.asset(
                  'assets/images/splash/splash_bg.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomLeft,
                  // if the image can't be loaded, show plain background
                  errorBuilder: (context, error, stackTrace) => Container(color: AppThemes.backgroundCream),
                ),
              ),
            ),

            // Centered logo text (uses theme displayLarge which uses LilitaOne)
            Center(
              child: Text(
                'AgriLink',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
