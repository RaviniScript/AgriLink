class AppRoutes {
  static const String splash = '/';
  static const String welcome = '/welcome';  // Added for teammate's new welcome screen
  static const String onboarding = '/onboarding';
  static const String homeSelector = '/homeSelector';  // Will be replaced with new role selection UI
  
  // Auth Routes
  static const String login = '/login';
  static const String register = '/register';
  
  // Farmer Routes
  static const String farmerHome = '/farmerHome';
  static const String selectCategory = '/selectCategory';
  static const String addFruit = '/addFruit';
  static const String addVegetable = '/addVegetable';
  static const String manageFruitStock = '/manageFruitStock';
  static const String manageVegetableStock = '/manageVegetableStock';
  static const String farmerOrders = '/farmerOrders';
  
  // Buyer Routes
  static const String buyerHome = '/buyerHome';
  static const String fruits = '/fruits';
  static const String fruitsList = '/fruitsList';
  static const String fruitDetails = '/fruitDetails';
  static const String vegetables = '/vegetables';
  static const String vegetablesList = '/vegetablesList';
  static const String vegetableDetails = '/vegetableDetails';
  static const String farmersList = '/farmersList';
  static const String farmerProfile = '/farmerProfile';
  static const String buyerProfile = '/buyerProfile';
  static const String searchResults = '/searchResults';
  static const String productDetail = '/productDetail';
  static const String checkout = '/checkout';
  static const String placeOrder = '/placeOrder';
  static const String orderConfirmation = '/orderConfirmation';
  static const String orderHistory = '/orderHistory';
  static const String trackOrder = '/trackOrder';
  static const String cart = '/cart';
  static const String buyerOrders = '/buyerOrders';
  static const String favorites = '/favorites';
  
  // Delivery Routes
  static const String deliveryHome = '/deliveryHome';
  static const String deliveryOrderList = '/deliveryOrderList';
  static const String deliveryMap = '/deliveryMap';
}
