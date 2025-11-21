import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:agri_link/services/product_service.dart';
import 'package:agri_link/services/cart_service.dart';
import 'package:agri_link/models/product_model.dart';

class VegetablesView extends StatefulWidget {
  const VegetablesView({Key? key}) : super(key: key);

  @override
  State<VegetablesView> createState() => _VegetablesViewState();
}

class _VegetablesViewState extends State<VegetablesView> {
  final ProductService _productService = ProductService();
  final CartService _cartService = CartService();
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVegetables();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadVegetables() async {
    setState(() => _isLoading = true);
    try {
      final products = await _productService.getProductsByCategory('vegetables');
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading vegetables: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.backgroundCream,
      appBar: AppBar(
        backgroundColor: AppThemes.backgroundCream,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/back_icon.png',
            width: 24,
            height: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(25),
          ),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Find Your Needs',
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: Colors.grey[600]),
                onPressed: () {
                  final query = _searchController.text.trim();
                  if (query.isNotEmpty) {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.searchResults,
                      arguments: {'query': query},
                    );
                  }
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                Navigator.pushNamed(
                  context,
                  AppRoutes.searchResults,
                  arguments: {'query': value.trim()},
                );
              }
            },
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppThemes.backgroundCream,
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.1),
                  width: 3,
                ),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Vegetables',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? const Center(child: Text('No vegetables available'))
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            return _buildProductCard(_products[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            AppRoutes.productDetail,
            arguments: {'product': product},
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
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
                        errorBuilder: (c, e, s) => Container(
                          color: Colors.grey[200],
                          child: const Center(child: Icon(Icons.image, size: 48)),
                        ),
                      )
                    : Container(
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.image, size: 48)),
                      ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppThemes.primaryGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    product.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rs ${product.price.toStringAsFixed(2)}/${product.unit}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 28,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _cartService.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart'),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'VIEW',
                              textColor: Colors.white,
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.cart);
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 14),
                      label: const Text('Add', style: TextStyle(fontSize: 11)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppThemes.primaryGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
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
    );
  }
}
