import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:agri_link/services/farmer_service.dart';
import 'package:agri_link/models/farmer_model.dart';

class FarmersListView extends StatefulWidget {
  final String? productName;

  const FarmersListView({
    super.key,
    this.productName,
  });

  @override
  State<FarmersListView> createState() => _FarmersListViewState();
}

class _FarmersListViewState extends State<FarmersListView> {
  final FarmerService _farmerService = FarmerService();
  final TextEditingController _searchController = TextEditingController();
  List<Farmer> _farmers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFarmers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFarmers() async {
    setState(() => _isLoading = true);
    try {
      final farmers = await _farmerService.getAllFarmers();
      setState(() {
        _farmers = farmers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading farmers: $e');
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
              'Farmers',
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
                : _farmers.isEmpty
                    ? const Center(child: Text('No farmers available'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _farmers.length,
                        itemBuilder: (context, index) {
                          final farmer = _farmers[index];
                          return _buildFarmerCard(farmer);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFarmerCard(Farmer farmer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Navigate to farmer profile screen
            Navigator.pushNamed(
              context,
              AppRoutes.farmerProfile,
              arguments: {
                'farmerId': farmer.id,
                'farmerName': farmer.name,
                'location': farmer.location,
                'phone': farmer.phone,
                'image': farmer.profileImageUrl,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Farmer profile image
                CircleAvatar(
                  radius: 32,
                  backgroundColor: const Color(0xFF6B8E23).withOpacity(0.2),
                  child: farmer.profileImageUrl.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            farmer.profileImageUrl,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                size: 32,
                                color: Color(0xFF6B8E23),
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          size: 32,
                          color: Color(0xFF6B8E23),
                        ),
                ),
                const SizedBox(width: 16),
                // Farmer info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        farmer.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        farmer.location,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      if (farmer.rating > 0) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              farmer.rating.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                // Arrow indicator
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
