import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:agri_link/services/product_service.dart';
import 'package:agri_link/services/farmer_service.dart';
import 'package:agri_link/services/cart_service.dart';
import 'package:agri_link/models/product_model.dart';
import 'package:agri_link/models/farmer_model.dart';

class SearchResultsView extends StatefulWidget {
  final String query;

  const SearchResultsView({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();
  
  List<ProductModel> _products = [];
  bool _isLoading = true;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _currentQuery = widget.query;
    _searchController.text = widget.query;
    _performSearch();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    if (_currentQuery.trim().isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final products = await _productService.searchProducts(_currentQuery);
      
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error searching: $e');
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

  void _onSearchSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      setState(() {
        _currentQuery = value.trim();
      });
      _performSearch();
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
            autofocus: false,
            onSubmitted: _onSearchSubmitted,
            decoration: InputDecoration(
              hintText: 'Search products or farmers...',
              suffixIcon: IconButton(
                icon: Icon(Icons.search, color: Colors.grey[600]),
                onPressed: () => _onSearchSubmitted(_searchController.text),
              ),
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
              'Search Results for "$_currentQuery"',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No results found for "$_currentQuery"',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.95,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _getUniqueProducts().length,
                        itemBuilder: (context, index) {
                          final uniqueProducts = _getUniqueProducts();
                          final productName = uniqueProducts.keys.elementAt(index);
                          final product = uniqueProducts[productName]!;
                          return _buildProductCard(product);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () {
        // Navigate to product farmers view to show all farmers selling this product
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
              child: product.imageUrl.isNotEmpty
                  ? Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
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
  }
}
