import 'package:flutter/material.dart';

import 'package:agri_link/views/farmer/farmer_home_view.dart';
import 'package:agri_link/views/farmer/farmer_accounts_view.dart';
import 'package:agri_link/views/farmer/farmer_profile_view.dart';
import 'package:agri_link/views/farmer/farmer_settings_view.dart';
import 'package:agri_link/views/farmer/my_crops_view.dart';
import 'package:agri_link/views/farmer/add_crops_view.dart';
import 'package:agri_link/views/farmer/update_crops_view.dart';
import 'package:agri_link/views/farmer/view_orders_view.dart';
import 'package:agri_link/views/farmer/stock_history_view.dart';

class AppRoutes {
  // General
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String homeSelector = '/homeSelector';

  // Auth
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String password = '/password';
  static const String register = '/register';
  static const String roleSelection = '/roleSelection';
  
  // Farmer Routes
  static const String farmerHome = '/farmer-home';
  static const String farmerAccounts = '/farmer-accounts';
  static const String farmerProfile = '/farmer-profile';
  static const String farmerSettings = '/farmer-settings';
  static const String myCrops = '/my-crops';
  static const String addCrops = '/add-crops';
  static const String updateCrops = '/update-crops';
  static const String viewOrders = '/view-orders';
  static const String orderDetails = '/order-details';
  static const String stockHistory = '/stock-history';

  static Map<String, WidgetBuilder> routes = {
    farmerHome: (context) => const FarmerHomeView(),
    farmerAccounts: (context) => const FarmerAccountsView(),
    farmerProfile: (context) => const FarmerProfileView(),
    farmerSettings: (context) => const FarmerSettingsView(),
    myCrops: (context) => const MyCropsView(),
    addCrops: (context) => const AddCropsView(),
    updateCrops: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      return UpdateCropsView(cropData: args ?? {});
    },
    viewOrders: (context) => const ViewOrdersView(),
    stockHistory: (context) => const StockHistoryView(),
  };
  
  // Buyer Routes
  static const String buyerHome = '/buyerHome';
  static const String fruits = '/fruits';
  static const String fruitsList = '/fruitsList';
  static const String fruitDetails = '/fruitDetails';
  static const String vegetables = '/vegetables';
  static const String vegetablesList = '/vegetablesList';
  static const String vegetableDetails = '/vegetableDetails';
  static const String cart = '/cart';
  static const String buyerOrders = '/buyerOrders';

  // Delivery
  static const String deliveryHome = '/deliveryHome';
  static const String deliveryOrderList = '/deliveryOrderList';
  static const String deliveryMap = '/deliveryMap';
}
