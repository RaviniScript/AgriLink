import 'package:flutter/material.dart';
// Using bundled fonts (Poppins + LilitaOne) declared in pubspec.yaml

class AppThemes {
	AppThemes._();

	static const Color primaryGreen = Color(0xFF609400);
	static const Color backgroundCream = Color(0xFFFFFDE8);

	static final ThemeData lightTheme = ThemeData(
		primaryColor: primaryGreen,
		scaffoldBackgroundColor: backgroundCream,
		colorScheme: ColorScheme.fromSeed(seedColor: primaryGreen),
		// Use bundled Poppins as the default app font. Logo uses LilitaOne.
		fontFamily: 'Poppins',
		textTheme: TextTheme(
			// Logo / large display (Lilita One)
			displayLarge: const TextStyle(fontFamily: 'LilitaOne', fontSize: 48, color: primaryGreen),
			// Headings / titles (tuned to match Figma: larger, tighter line-height)
			headlineSmall: const TextStyle(
				fontSize: 26,
				fontWeight: FontWeight.w600,
				color: Colors.black87,
				letterSpacing: 0.2,
				height: 1.12,
			),
			// Body
			bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black87, height: 1.25),
			bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black54, height: 1.3),
		),
		elevatedButtonTheme: ElevatedButtonThemeData(
			style: ElevatedButton.styleFrom(
				backgroundColor: primaryGreen,
				foregroundColor: Colors.white,
				shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
			),
		),
	);
}

// Backward-compatible color constants used across the app
class AppColors {
	AppColors._();

	static const Color primary = Color(0xFF609400);
	static const Color primaryLight = Color(0xFF8BBF3A);
	static const Color primaryDark = Color(0xFF3F6B00);
	static const Color success = Color(0xFF2E7D32);
	static const Color info = Color(0xFF0288D1);
	static const Color textSecondary = Color(0xFF6B6B6B);
	static const Color error = Color(0xFFB00020);
}

// Simple text style tokens used by older files
class AppTextStyles {
	AppTextStyles._();

	static const TextStyle h2 = TextStyle(fontSize: 30, fontWeight: FontWeight.w700, fontFamily: 'Poppins');
	static const TextStyle h3 = TextStyle(fontSize: 24, fontWeight: FontWeight.w600, fontFamily: 'Poppins');
	static const TextStyle bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Poppins');
	static const TextStyle bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: 'Poppins');
	static const TextStyle button = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Poppins');
}
