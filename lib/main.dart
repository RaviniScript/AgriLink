import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/route_generator.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:agri_link/viewmodels/crop_viewmodel.dart';
import 'package:agri_link/viewmodels/user_viewmodel.dart';
import 'package:agri_link/viewmodels/payment_card_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Only initialize Firebase on mobile platforms (not web for now)
  if (!kIsWeb) {
    debugPrint('🔵 Initializing Firebase...');
    await Firebase.initializeApp();
    debugPrint('✅ Firebase initialized successfully!');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CropViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentCardViewModel()),
      ],
      child: MaterialApp(
        title: 'AgriLink App',
        theme: AppThemes.lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}

