import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:agri_link/services/product_service.dart';
import 'package:agri_link/models/product_model.dart';

class FruitsView extends StatefulWidget {
  const FruitsView({Key? key}) : super(key: key);

  @override
  State<FruitsView> createState() => _FruitsViewState();
}

class _FruitsViewState extends State<FruitsView> {
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _products = [];
  bool _isLoading = true;

  // Map fruit names to asset images
  final Map<String, String> _fruitImages = {
    'banana': 'assets/images/fruits/banana.jpg',
    'avocado': 'assets/images/fruits/avocado.jpg',
    'pineapple': 'assets/images/fruits/pineapple.jpg',
    'wood apple': 'assets/images/fruits/wood apple.webp',
    'mango': 'assets/images/fruits/mango.png',
    'papaya': 'assets/images/fruits/papaya.webp',
    'lime': 'assets/images/fruits/lime.webp',
    'durian': 'assets/images/fruits/durian.jpg',
    'watermelon': 'assets/images/fruits/watermelon.webp',
    'grapes': 'assets/images/fruits/grapes.webp',
  };

  String _getFruitImage(String name) {
    return _fruitImages[name.toLowerCase()] ?? 'assets/images/fruits/banana.jpg';
  }

  @override
  void initState() {
    super.initState();
    _loadFruits();
  }

  Future<void> _loadFruits() async {
    setState(() => _isLoading = true);
    final products = await _productService.getProductsByCategory('fruits');
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  List<String> _getUniqueFruitNames() {
    final names = <String>{};
    for (var p in _products) {
      names.add(p.name.toLowerCase());
    }
    return names.toList();
  }

  @override
  Widget build(BuildContext context) {
    final uniqueNames = _getUniqueFruitNames();
    return Scaffold(
      backgroundColor: AppThemes.backgroundCream,
      appBar: AppBar(
        backgroundColor: AppThemes.backgroundCream,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
              suffixIcon: Icon(Icons.search, color: Colors.grey[600]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
            child: Text(
              'Fruits',
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
                : uniqueNames.isEmpty
                    ? const Center(child: Text('No fruits available'))
                    : Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.95,
                          ),
                          itemCount: uniqueNames.length,
                          itemBuilder: (context, index) {
                            final fruitName = uniqueNames[index];
                            return GestureDetector(
                              onTap: () {
                                // Navigate to farmers selling this fruit
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.productFarmers,
                                  arguments: {
                                    'productName': _capitalize(fruitName),
                                    'category': 'fruits',
                                  },
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        _getFruitImage(fruitName),
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
                                      _capitalize(fruitName),
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

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
