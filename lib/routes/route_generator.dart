import 'package:flutter/material.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:agri_link/views/common/splash_view.dart';
import 'package:agri_link/views/common/onboarding_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case AppRoutes.homeSelector:
        return MaterialPageRoute(builder: (_) => const Placeholder()); // TODO: Replace with HomeSelectorView
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const Placeholder()); // TODO: Replace with LoginView
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const Placeholder()); // TODO: Replace with RegisterView
      case AppRoutes.farmerHome:
        return MaterialPageRoute(builder: (_) => const Placeholder()); // TODO: Replace with FarmerHomeView
      case AppRoutes.buyerHome:
        return MaterialPageRoute(builder: (_) => const Placeholder()); // TODO: Replace with BuyerHomeView
      case AppRoutes.deliveryHome:
        return MaterialPageRoute(builder: (_) => const Placeholder()); // TODO: Replace with DeliveryHomeView
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
            ),
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
