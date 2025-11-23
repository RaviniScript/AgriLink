import 'package:flutter/material.dart';
import 'package:agri_link/routes/app_routes.dart';

// Import views used by the app
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
import 'package:agri_link/views/buyer/best_selling_view.dart';
import 'package:agri_link/views/delivery/delivery_home_view.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final name = settings.name ?? '';
    switch (name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeView());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case AppRoutes.roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionView());
      case AppRoutes.homeSelector:
        return MaterialPageRoute(builder: (_) => const HomeSelectorView());
      case AppRoutes.farmerHome:
        return MaterialPageRoute(builder: (_) => const FarmerHomeView());
      case AppRoutes.buyerHome:
        return MaterialPageRoute(builder: (_) => const BuyerHomeView());
      case AppRoutes.fruits:
        return MaterialPageRoute(builder: (_) => const FruitsView());
      case AppRoutes.vegetables:
        return MaterialPageRoute(builder: (_) => const VegetablesView());
      case AppRoutes.farmersList:
        final farmerArgs = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => FarmersListView(
            productName: farmerArgs?['productName'],
          ),
        );
      case AppRoutes.farmerAllProducts:
        final farmerArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FarmerAllProductsView(
            farmer: farmerArgs['farmer'],
          ),
        );
      case AppRoutes.farmerProfile:
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
      case AppRoutes.buyerProfile:
        return MaterialPageRoute(builder: (_) => const BuyerProfileView());
      case AppRoutes.searchResults:
        final searchArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SearchResultsView(query: searchArgs['query']),
        );
      case AppRoutes.productDetail:
        final productArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ProductDetailView(product: productArgs['product']),
        );
      case AppRoutes.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutView());
      case AppRoutes.orderHistory:
        final orderArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OrderHistoryView(
            buyerPhone: orderArgs['buyerPhone'] ?? '',
          ),
        );
      case AppRoutes.favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesView());
      case AppRoutes.bestSelling:
        return MaterialPageRoute(builder: (_) => const BestSellingView());
      case AppRoutes.productFarmers:
        final productFarmersArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ProductFarmersView(
            productName: productFarmersArgs['productName'],
            category: productFarmersArgs['category'],
          ),
        );
      case AppRoutes.farmerProducts:
        final farmerProductsArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FarmerProductsView(
            farmer: farmerProductsArgs['farmer'],
            products: farmerProductsArgs['products'],
            productName: farmerProductsArgs['productName'],
          ),
        );
      case AppRoutes.trackOrder:
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
      case AppRoutes.orderConfirmation:
        final confirmArgs = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OrderConfirmationView(
            orderId: confirmArgs['orderId'],
            total: confirmArgs['total'],
          ),
        );
      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartView());
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