import 'package:flutter/material.dart';
import 'package:agri_link/routes/app_routes.dart';

// Import views used by the app
import 'package:agri_link/views/common/splash_view.dart';
// hide AppRoutes from onboarding_view to avoid duplicate AppRoutes symbol
import 'package:agri_link/views/common/onboarding_view.dart' hide AppRoutes;
import 'package:agri_link/views/auth/welcome_view.dart' show WelcomeView;
import 'package:agri_link/views/auth/register_view.dart';
import 'package:agri_link/views/auth/login_view.dart';
import 'package:agri_link/views/auth/role_selection_view.dart';
import 'package:agri_link/views/farmer/farmer_home_view.dart';
import 'package:agri_link/views/buyer/buyer_home_view.dart';
import 'package:agri_link/views/delivery/delivery_home_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name ?? '';
    switch (name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      // *** THIS IS THE CORRECT ROUTE MAPPING ***
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeView());
      // *****************************************
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case AppRoutes.roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionView());
      case AppRoutes.homeSelector:
        return MaterialPageRoute(builder: (_) => const Scaffold(body: Center(child: Text('Home selector (not implemented)'))));
      case AppRoutes.farmerHome:
        return MaterialPageRoute(builder: (_) => const FarmerHomeView());
      case AppRoutes.buyerHome:
        return MaterialPageRoute(builder: (_) => const BuyerHomeView());
      case AppRoutes.deliveryHome:
        return MaterialPageRoute(builder: (_) => const DeliveryHomeView());
      default:
        debugPrint('No route defined for $name');
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(child: Text('No route defined for $name')),
          ),
        );
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    final name = settings.name ?? 'unknown';
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Unknown route')),
        body: Center(child: Text('Unknown route: $name')),
      ),
    );
  }
}