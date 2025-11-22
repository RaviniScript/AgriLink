import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:agri_link/services/product_service.dart';
import 'package:agri_link/services/farmer_service.dart';
import 'package:agri_link/models/product_model.dart';
import 'package:agri_link/models/farmer_model.dart';

class ProductFarmersView extends StatefulWidget {
  final String productName;
  final String category;

  const ProductFarmersView({
    Key? key,
    required this.productName,
    required this.category,
  }) : super(key: key);

  @override
  State<ProductFarmersView> createState() => _ProductFarmersViewState();
}

class _ProductFarmersViewState extends State<ProductFarmersView> {
  final ProductService _productService = ProductService();
  final FarmerService _farmerService = FarmerService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Map<String, dynamic>> _farmersWithProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFarmersSellingProduct();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFarmersSellingProduct() async {
    setState(() => _isLoading = true);
    try {
      print('🔍 Loading farmers selling ${widget.productName}...');
      
      // Get all products with this name in this category
      final allProducts = await _productService.getProductsByCategory(widget.category);
      final matchingProducts = allProducts
          .where((p) => p.name.toLowerCase() == widget.productName.toLowerCase())
          .toList();
      
      print('📦 Found ${matchingProducts.length} products matching ${widget.productName}');
      
      // Group products by farmer
      final farmerProductsMap = <String, List<ProductModel>>{};
      for (var product in matchingProducts) {
        if (!farmerProductsMap.containsKey(product.farmerId)) {
          farmerProductsMap[product.farmerId] = [];
        }
        farmerProductsMap[product.farmerId]!.add(product);
      }
      
      // Fetch farmer details for each farmer
      final farmersWithProducts = <Map<String, dynamic>>[];
      for (var entry in farmerProductsMap.entries) {
        final farmerId = entry.key;
        final products = entry.value;
        
        try {
          final farmer = await _farmerService.getFarmerById(farmerId);
          if (farmer != null) {
            farmersWithProducts.add({
              'farmer': farmer,
              'products': products,
            });
            print('👨‍🌾 Added farmer: ${farmer.name} with ${products.length} products');
          }
        } catch (e) {
          print('⚠️ Could not fetch farmer $farmerId: $e');
        }
      }
      
      setState(() {
        _farmersWithProducts = farmersWithProducts;
        _isLoading = false;
      });
      
      print('✅ Loaded ${_farmersWithProducts.length} farmers');
    } catch (e) {
      print('❌ Error loading farmers: $e');
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Farmers selling this product',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _farmersWithProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.agriculture, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No farmers selling ${widget.productName}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _farmersWithProducts.length,
                        itemBuilder: (context, index) {
                          final data = _farmersWithProducts[index];
                          final farmer = data['farmer'] as Farmer;
                          final products = data['products'] as List<ProductModel>;
                          return _buildFarmerCard(farmer, products);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmerCard(Farmer farmer, List<ProductModel> products) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to farmer's product detail view
          Navigator.pushNamed(
            context,
            AppRoutes.farmerProducts,
            arguments: {
              'farmer': farmer,
              'products': products,
              'productName': widget.productName,
            },
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Farmer profile image
              CircleAvatar(
                radius: 32,
                backgroundColor: AppThemes.primaryGreen.withOpacity(0.1),
                backgroundImage: farmer.profileImageUrl.isNotEmpty
                    ? NetworkImage(farmer.profileImageUrl)
                    : null,
                child: farmer.profileImageUrl.isEmpty
                    ? Icon(
                        Icons.person,
                        size: 32,
                        color: AppThemes.primaryGreen,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              // Farmer details - only name and location
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      farmer.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      farmer.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 20,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
