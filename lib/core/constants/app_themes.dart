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
