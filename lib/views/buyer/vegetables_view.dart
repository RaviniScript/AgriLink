import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';

import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:agri_link/services/product_service.dart';
import 'package:agri_link/models/product_model.dart';

class VegetablesView extends StatefulWidget {
  const VegetablesView({Key? key}) : super(key: key);

  @override
  State<VegetablesView> createState() => _VegetablesViewState();
}

class _VegetablesViewState extends State<VegetablesView> {
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _products = [];
  bool _isLoading = true;

  // Local asset images mapping
  final Map<String, String> _productImages = {
    'pumpkin': 'assets/images/vegetables/pumpkin-season-australia.webp',
    'carrot': 'assets/images/vegetables/carrot.webp',
    'broccoli': 'assets/images/vegetables/broccoli.jpg',
    'capsicum': 'assets/images/vegetables/capsicum.jpg',
    'cabbage': 'assets/images/vegetables/cabbage.webp',
    'leeks': 'assets/images/vegetables/leeks.webp',
    'ladies finger': 'assets/images/vegetables/ladies.png',
    'bitter gourd': 'assets/images/vegetables/bitter gourd.webp',
  };

  String _getProductImage(String productName) {
    final key = productName.toLowerCase();
    return _productImages[key] ?? 'assets/images/vegetables/carrot.webp';
  }

  List<String> _getUniqueProductNames(List<ProductModel> products) {
    final names = <String>{};
    for (var p in products) {
      names.add(p.name.toLowerCase());
    }
    return names.toList();
  }

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
                          itemCount: _getUniqueProductNames(_products).length,
                          itemBuilder: (context, index) {
                            final uniqueNames = _getUniqueProductNames(_products);
                            final productName = uniqueNames[index];
                            final imagePath = _getProductImage(productName);
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.productFarmers,
                                  arguments: {'productName': productName},
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          imagePath,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                                      child: Text(
                                        productName[0].toUpperCase() + productName.substring(1),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
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
// (trailing corrupted code removed)
