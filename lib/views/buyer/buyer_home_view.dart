import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:agri_link/widgets/buyer_bottom_nav.dart';
import 'package:agri_link/services/product_service.dart';
import 'package:agri_link/services/farmer_service.dart';
import 'package:agri_link/services/cart_service.dart';
import 'package:agri_link/services/favorites_service.dart';
import 'package:agri_link/models/product_model.dart';
import 'package:agri_link/models/farmer_model.dart';

class BuyerHomeView extends StatefulWidget {
  const BuyerHomeView({Key? key}) : super(key: key);

  @override
  State<BuyerHomeView> createState() => _BuyerHomeViewState();
}

class _BuyerHomeViewState extends State<BuyerHomeView> {
  int _currentNavIndex = 0;
  int _carouselIndex = 0;
  final PageController _carouselController = PageController();
  Timer? _carouselTimer;
  
  final ProductService _productService = ProductService();
  final FarmerService _farmerService = FarmerService();
  final CartService _cartService = CartService();
  final FavoritesService _favoritesService = FavoritesService();
  
  List<ProductModel> _bestSellingProducts = [];
  bool _isLoadingProducts = true;
  Set<String> _favoriteProductIds = {};

  @override
  void initState() {
    super.initState();
    _startCarouselAutoPlay();
    _loadBestSellingProducts();
    _loadFavorites();
  }

  void _loadFavorites() async {
    try {
      final favoriteIds = await _favoritesService.getFavoriteProductIds('buyer_001');
      setState(() {
        _favoriteProductIds = favoriteIds;
      });
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  Future<void> _toggleFavorite(String productId) async {
    try {
      final isFavorited = await _favoritesService.toggleFavorite('buyer_001', productId);
      setState(() {
        if (isFavorited) {
          _favoriteProductIds.add(productId);
        } else {
          _favoriteProductIds.remove(productId);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFavorited ? 'Added to favorites' : 'Removed from favorites'),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _loadBestSellingProducts() async {
    setState(() => _isLoadingProducts = true);
    try {
      final products = await _productService.getBestSellingProducts(limit: 10);
      setState(() {
        _bestSellingProducts = products;
        _isLoadingProducts = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() => _isLoadingProducts = false);
    }
  }

  void _startCarouselAutoPlay() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_carouselIndex < 2) {
        _carouselIndex++;
      } else {
        _carouselIndex = 0;
      }
      _carouselController.animateToPage(
        _carouselIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    });
  }

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });

    // Handle navigation based on bottom nav index
    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        // Navigate to Farmers list
        Navigator.pushNamed(context, AppRoutes.farmersList);
        break;
      case 2:
        // Navigate to Profile
        Navigator.pushNamed(context, AppRoutes.buyerProfile);
        break;
      case 3:
        // Navigate to Cart
        Navigator.pushNamed(context, AppRoutes.cart);
        break;
    }
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.backgroundCream,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Green header with Hello Ruwan
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF558300),
                  const Color(0xFFFFFFFF),
                ],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hello\nRuwan!',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontSize: 32,
                                color: Colors.white,
                                height: 1.2,
                              ),
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.receipt_long, color: AppThemes.primaryGreen, size: 24),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.orderHistory,
                                    arguments: {'buyerPhone': '1234567890'},
                                  );
                                },
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                                tooltip: 'Order History',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.notifications_outlined, color: AppThemes.primaryGreen, size: 24),
                                onPressed: () {},
                                padding: const EdgeInsets.all(8),
                                constraints: const BoxConstraints(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Search bar
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.searchResults,
                              arguments: {'query': value.trim()},
                            );
                          }
                        },
                        decoration: InputDecoration(
                          hintText: 'Find Your Needs',
                          suffixIcon: Icon(Icons.search, color: Colors.grey[600]),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  
                  // Carousel
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: PageView(
                              controller: _carouselController,
                              onPageChanged: (index) {
                                setState(() {
                                  _carouselIndex = index;
                                });
                              },
                              children: [
                                Image.asset(
                                  'assets/images/buyer/carousel/carousel_1.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    color: Colors.grey[300],
                                    child: const Center(child: Text('Carousel 1')),
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/buyer/carousel/carousel_2.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    color: Colors.grey[300],
                                    child: const Center(child: Text('Carousel 2')),
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/buyer/carousel/carousel_3.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) => Container(
                                    color: Colors.grey[300],
                                    child: const Center(child: Text('Carousel 3')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Text overlay - only show on first carousel image
                          if (_carouselIndex == 0)
                            Positioned(
                              top: 16,
                              left: 16,
                              right: 100,
                              child: Text(
                                'Bringing\nnature\'s best\nto your\ndoorstep',
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  height: 1.3,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          // Carousel dots indicator
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 4),
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _carouselIndex == index
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.4),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),              const SizedBox(height: 20),

              // Categories section title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Categories',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),

              const SizedBox(height: 12),

              // Categories row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.vegetables),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      'assets/images/buyer/vegetables.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Vegetables', style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pushNamed(AppRoutes.fruits),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      'assets/images/buyer/fruits.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text('Fruits', style: Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Best Selling Products header with "View More"
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Best Selling Products',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to full products catalog
                        Navigator.of(context).pushNamed(AppRoutes.vegetables);
                      },
                      child: Text(
                        'View All',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppThemes.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Best selling products horizontal scroll
              _isLoadingProducts
                  ? const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _bestSellingProducts.isEmpty
                      ? const SizedBox(
                          height: 220,
                          child: Center(
                            child: Text('No products available'),
                          ),
                        )
                      : SizedBox(
                          height: 220,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            itemCount: _bestSellingProducts.length,
                            itemBuilder: (context, index) {
                              final product = _bestSellingProducts[index];
                              return Padding(
                                padding: EdgeInsets.only(
                                  right: index < _bestSellingProducts.length - 1 ? 12 : 0,
                                ),
                                child: _buildBestCard(product),
                              );
                            },
                          ),
                        ),

              const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BuyerBottomNav(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildBestCard(ProductModel product) {
    return SizedBox(
      width: 160,
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.productDetail,
            arguments: {'product': product},
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      product.imageUrl.isNotEmpty
                          ? Image.network(
                              product.imageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                          errorBuilder: (c, e, s) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image, size: 48, color: Colors.grey),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        )
                          : Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, size: 48, color: Colors.grey),
                            ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () => _toggleFavorite(product.id),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              _favoriteProductIds.contains(product.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _favoriteProductIds.contains(product.id)
                                  ? Colors.red
                                  : Colors.grey[600],
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Rs ${product.price.toStringAsFixed(2)}/${product.unit}',
                        style: TextStyle(
                          color: AppThemes.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 32,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _cartService.addToCart(product);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${product.name} added to cart'),
                                duration: const Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'VIEW CART',
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.pushNamed(context, AppRoutes.cart);
                                  },
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart, size: 16),
                          label: const Text('Add', style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppThemes.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
