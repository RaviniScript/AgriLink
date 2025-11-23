import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:agri_link/services/product_service.dart';
import 'package:agri_link/models/product_model.dart';

class BestSellingView extends StatefulWidget {
  const BestSellingView({Key? key}) : super(key: key);

  @override
  State<BestSellingView> createState() => _BestSellingViewState();
}

class _BestSellingViewState extends State<BestSellingView> {
  final ProductService _productService = ProductService();
  List<ProductModel> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBestSellingProducts();
  }

  Future<void> _loadBestSellingProducts() async {
    setState(() => _isLoading = true);
    try {
      final products = await _productService.getBestSellingProducts(limit: 50);
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading best selling products: $e');
      setState(() => _isLoading = false);
    }
  }

  // Get unique product names with their first product as representative
  Map<String, ProductModel> _getUniqueProducts() {
    Map<String, ProductModel> uniqueProducts = {};
    for (var product in _products) {
      final productName = product.name.toLowerCase();
      if (!uniqueProducts.containsKey(productName)) {
        uniqueProducts[productName] = product;
      }
    }
    return uniqueProducts;
  }

  @override
  Widget build(BuildContext context) {
    final uniqueProducts = _getUniqueProducts();
    
    return Scaffold(
      backgroundColor: AppThemes.backgroundCream,
      appBar: AppBar(
        backgroundColor: AppThemes.backgroundCream,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppThemes.primaryGreen, size: 20),
              onPressed: () => Navigator.of(context).pop(),
            ),
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
            child: const Text(
              'Best Selling Products',
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
                : uniqueProducts.isEmpty
                    ? const Center(child: Text('No products available'))
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.95,
                          ),
                          itemCount: uniqueProducts.length,
                          itemBuilder: (context, index) {
                            final productName = uniqueProducts.keys.elementAt(index);
                            final product = uniqueProducts[productName]!;
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.productFarmers,
                                  arguments: {
                                    'productName': product.name,
                                    'category': product.category,
                                  },
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        product.imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (c, e, s) => Container(
                                          color: Colors.grey[200],
                                          child: const Center(child: Icon(Icons.image, size: 48)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: AppThemes.primaryGreen,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      product.name,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
