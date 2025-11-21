import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';

/// Application-wide text styles
class AppTextStyles {
  static TextStyle get h1 => GoogleFonts.poppins(
    fontWeight: FontWeight.w800,
    fontSize: 32,
    color: Colors.black87,
  );
  
  static TextStyle get h3 => GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: Colors.black87,
  );

  static TextStyle get bodyMedium => GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: Colors.black87,
  );

  static TextStyle get button => GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    color: Colors.white,
  );

  static TextStyle get displayLarge => GoogleFonts.lilitaOne(
    fontWeight: FontWeight.w400,
    fontSize: 60,
    color: AppThemes.primaryGreen,
  );
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppThemes.backgroundCream,
      body: Stack(
        children: [
          // Background Image for the bottom half of the screen
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: size.height * 0.45,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/splash/splash_bg.png'),
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Main Content Column (Logo, Text, Buttons)
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: SizedBox(
                  height: size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.15),

                      // AgriLink Logo/Title
                      Text(
                        'AgriLink',
                        style: AppTextStyles.h1.copyWith(
                          color: AppThemes.primaryGreen,
                          fontSize: 48,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Welcome Subtitle
                      Text(
                        'Welcome to AgriLink!',
                        style: AppTextStyles.h3.copyWith(
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: size.height * 0.08),

                      // 1. Create an Account Button (Light Gray)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.register);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE0E0E0),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Create an account',
                            style: AppTextStyles.button.copyWith(color: Colors.black87),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Already connected? Text
                      Text(
                        'Already connected?',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 2. Sign In Button (Green)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(AppRoutes.login);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemes.primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                          ),
                          child: Text(
                            'Sign In',
                            style: AppTextStyles.button.copyWith(color: Colors.white),
                          ),
                        ),
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}