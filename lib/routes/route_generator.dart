import 'package:flutter/material.dart';
import 'package:agri_link/routes/app_routes.dart' as routes;
import 'package:agri_link/views/common/splash_view.dart';
import 'package:agri_link/views/common/onboarding_view.dart' hide AppRoutes;
import 'package:agri_link/views/common/home_selector_view.dart';
import 'package:agri_link/views/auth/welcome_view.dart' show WelcomeView;
import 'package:agri_link/views/auth/register_view.dart';
import 'package:agri_link/views/auth/login_view.dart';
import 'package:agri_link/views/auth/role_selection_view.dart';
import 'package:agri_link/views/farmer/farmer_home_view.dart';
import 'package:agri_link/views/buyer/buyer_home_view.dart';
import 'package:agri_link/views/buyer/fruits_view.dart';
import 'package:agri_link/views/buyer/vegetables_view.dart';
import 'package:agri_link/views/buyer/farmers_list_view.dart';
import 'package:agri_link/views/buyer/farmer_profile_view.dart';
import 'package:agri_link/views/buyer/farmer_all_products_view.dart';
import 'package:agri_link/views/buyer/product_farmers_view.dart';
import 'package:agri_link/views/buyer/farmer_products_view.dart';
import 'package:agri_link/views/buyer/buyer_profile_view.dart';
import 'package:agri_link/views/buyer/place_order_view.dart';
import 'package:agri_link/views/buyer/order_confirmation_view.dart';
import 'package:agri_link/views/buyer/cart_view.dart';
import 'package:agri_link/views/buyer/track_order_view.dart';
import 'package:agri_link/views/buyer/search_results_view.dart';
import 'package:agri_link/views/buyer/product_detail_view.dart';
import 'package:agri_link/views/buyer/checkout_view.dart';
import 'package:agri_link/views/buyer/order_history_view.dart';
import 'package:agri_link/views/buyer/favorites_view.dart';
import 'package:agri_link/views/delivery/delivery_home_view.dart';
import 'package:agri_link/views/delivery/delivery_profile_view.dart';
import 'package:agri_link/views/delivery/delivery_rides_view.dart';
import 'package:agri_link/views/delivery/delivery_settings_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name ?? '';
    switch (name) {
      case routes.AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case routes.AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case routes.AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeView());
      case routes.AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case routes.AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case routes.AppRoutes.roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionView());
      case routes.AppRoutes.homeSelector:
        return MaterialPageRoute(builder: (_) => const HomeSelectorView());
      case routes.AppRoutes.farmerHome:
        return MaterialPageRoute(builder: (_) => const FarmerHomeView());
      case routes.AppRoutes.buyerHome:
        return MaterialPageRoute(builder: (_) => const BuyerHomeView());
      case routes.AppRoutes.fruits:
        return MaterialPageRoute(builder: (_) => const FruitsView());
      case routes.AppRoutes.vegetables:
        return MaterialPageRoute(builder: (_) => const VegetablesView());
      case routes.AppRoutes.farmersList:
        final farmerArgs = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => FarmersListView(
            productName: farmerArgs?['productName'],
          ),
        );
      case routes.AppRoutes.farmerAllProducts:
        final farmerArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FarmerAllProductsView(
            farmer: farmerArgs['farmer'],
          ),
        );
      case routes.AppRoutes.farmerProfile:
        final farmerProfileArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FarmerProfileView(
            farmerId: farmerProfileArgs['farmerId'],
            farmerName: farmerProfileArgs['farmerName'],
            location: farmerProfileArgs['location'],
            phone: farmerProfileArgs['phone'],
            image: farmerProfileArgs['image'],
          ),
        );
      case routes.AppRoutes.buyerProfile:
        return MaterialPageRoute(builder: (_) => const BuyerProfileView());
      case routes.AppRoutes.searchResults:
        final searchArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SearchResultsView(query: searchArgs['query']),
        );
      case routes.AppRoutes.productDetail:
        final productArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ProductDetailView(product: productArgs['product']),
        );
      case routes.AppRoutes.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutView());
      case routes.AppRoutes.orderHistory:
        final orderArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OrderHistoryView(
            buyerPhone: orderArgs['buyerPhone'] ?? '',
          ),
        );
      case routes.AppRoutes.favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesView());
      case routes.AppRoutes.productFarmers:
        final productFarmersArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ProductFarmersView(
            productName: productFarmersArgs['productName'],
            category: productFarmersArgs['category'],
          ),
        );
      case routes.AppRoutes.farmerProducts:
        final farmerProductsArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FarmerProductsView(
            farmer: farmerProductsArgs['farmer'],
            products: farmerProductsArgs['products'],
            productName: farmerProductsArgs['productName'],
          ),
        );
      case routes.AppRoutes.trackOrder:
        final trackArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TrackOrderView(
            orderId: trackArgs['orderId'] ?? '0000',
            farmerName: trackArgs['farmerName'] ?? 'Farmer',
            driverName: trackArgs['driverName'] ?? 'Driver',
            driverPhone: trackArgs['driverPhone'] ?? '+94 71 234 5678',
            driverImage: trackArgs['driverImage'] ?? '',
            currentStatus: trackArgs['currentStatus'] ?? 'Processing',
            statusHistory: trackArgs['statusHistory'] ?? [],
          ),
        );
      case routes.AppRoutes.orderConfirmation:
        final confirmArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OrderConfirmationView(
            orderId: confirmArgs['orderId'],
            total: confirmArgs['total'],
          ),
        );
      case routes.AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartView());
      case routes.AppRoutes.deliveryHome:
        return MaterialPageRoute(builder: (_) => const DeliveryHomeView());
      case routes.AppRoutes.deliveryProfile:
        return MaterialPageRoute(builder: (_) => const DeliveryProfileView());
      case routes.AppRoutes.deliveryRides:
        return MaterialPageRoute(builder: (_) => const DeliveryRidesView());
      case routes.AppRoutes.deliverySettings:
        return MaterialPageRoute(builder: (_) => const DeliverySettingsView());
      default:
        debugPrint('No route defined for $name');
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('No route defined')),
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