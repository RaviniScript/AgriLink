import 'package:flutter/material.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:agri_link/views/common/splash_view.dart';
import 'package:agri_link/views/common/onboarding_view.dart';
import 'package:agri_link/views/common/home_selector_view.dart';
import 'package:agri_link/views/buyer/buyer_home_view.dart';
import 'package:agri_link/views/buyer/fruits_view.dart';
import 'package:agri_link/views/buyer/vegetables_view.dart';
import 'package:agri_link/views/buyer/farmers_list_view.dart';
import 'package:agri_link/views/buyer/farmer_profile_view.dart';
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

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case AppRoutes.homeSelector:
        return MaterialPageRoute(builder: (_) => const HomeSelectorView());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const Placeholder()); // TODO: Replace with LoginView
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const Placeholder()); // TODO: Replace with RegisterView
      case AppRoutes.farmerHome:
        return MaterialPageRoute(builder: (_) => const Placeholder()); // TODO: Replace with FarmerHomeView
      case AppRoutes.buyerHome:
        return MaterialPageRoute(builder: (_) => const BuyerHomeView());
      case AppRoutes.fruits:
        return MaterialPageRoute(builder: (_) => const FruitsView());
      case AppRoutes.vegetables:
        return MaterialPageRoute(builder: (_) => const VegetablesView());
      case AppRoutes.farmersList:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => FarmersListView(
            productName: args?['productName'],
          ),
        );
      case AppRoutes.farmerProfile:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => FarmerProfileView(
            farmerId: args['farmerId'] ?? '',
            farmerName: args['farmerName'] ?? 'Farmer',
            location: args['location'] ?? 'Location',
            phone: args['phone'] ?? 'Phone',
            image: args['image'] ?? '',
          ),
        );
      case AppRoutes.placeOrder:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => PlaceOrderView(
            farmerName: args['farmerName'] ?? 'Farmer',
            selectedProducts: args['selectedProducts'] ?? [],
            notes: args['notes'],
          ),
        );
      case AppRoutes.orderConfirmation:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OrderConfirmationView(
            orderId: args['orderId'] ?? '',
            total: args['total'] ?? 0.0,
          ),
        );
      case AppRoutes.cart:
        return MaterialPageRoute(builder: (_) => const CartView());
      case AppRoutes.searchResults:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => SearchResultsView(query: args['query'] ?? ''),
        );
      case AppRoutes.productDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => ProductDetailView(product: args['product']),
        );
      case AppRoutes.checkout:
        return MaterialPageRoute(builder: (_) => const CheckoutView());
      case AppRoutes.orderHistory:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => OrderHistoryView(
            buyerPhone: args['buyerPhone'] ?? '',
          ),
        );
      case AppRoutes.buyerProfile:
        return MaterialPageRoute(builder: (_) => const BuyerProfileView());
      case AppRoutes.favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesView());
      case AppRoutes.trackOrder:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => TrackOrderView(
            orderId: args['orderId'] ?? '0000',
            farmerName: args['farmerName'] ?? 'Farmer',
            driverName: args['driverName'] ?? 'Driver',
            driverPhone: args['driverPhone'] ?? 'N/A',
            driverImage: args['driverImage'] ?? '',
            currentStatus: args['currentStatus'] ?? 'placed',
            statusHistory: args['statusHistory'] ?? [],
          ),
        );
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
