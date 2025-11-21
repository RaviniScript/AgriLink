import 'package:flutter/material.dart';
import '../../core/constants/app_themes.dart';

class StockHistoryView extends StatefulWidget {
  const StockHistoryView({Key? key}) : super(key: key);

  @override
  State<StockHistoryView> createState() => _StockHistoryViewState();
}

class _StockHistoryViewState extends State<StockHistoryView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // TODO: This will be populated from your backend
  List<Map<String, dynamic>> vegetables = [
    {
      'name': '',
      'imageUrl': '',
      'initial': '',
      'sold': '',
      'remaining': '',
      'updated': '',
    },
    {
      'name': '',
      'imageUrl': '',
      'initial': '',
      'sold': '',
      'remaining': '',
      'updated': '',
    },
    {
      'name': '',
      'imageUrl': '',
      'initial': '',
      'sold': '',
      'remaining': '',
      'updated': '',
    },
  ];

  List<Map<String, dynamic>> fruits = [
    {
      'name': '',
      'imageUrl': '',
      'initial': '',
      'sold': '',
      'remaining': '',
      'updated': '',
    },
    {
      'name': '',
      'imageUrl': '',
      'initial': '',
      'sold': '',
      'remaining': '',
      'updated': '',
    },
  ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update button states
    });
    // TODO: Call your backend API here to fetch stock data
    // _loadStockFromBackend();
  }

  // TODO: Implement this method to fetch data from your backend
  Future<void> _loadStockFromBackend() async {
    setState(() => isLoading = true);

    // Example:
    // final response = await YourBackendService.getStock();
    // setState(() {
    //   vegetables = response['vegetables'];
    //   fruits = response['fruits'];
    //   isLoading = false;
    // });

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          // Header
          _buildHeader(),
          // Tab bar
          _buildTabBar(),
          // Content
          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
                : TabBarView(
              controller: _tabController,
              children: [
                _buildStockList(vegetables),
                _buildStockList(fruits),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  'Stock History',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton(
              text: 'Vegetables',
              isSelected: _tabController.index == 0,
              onTap: () {
                setState(() {
                  _tabController.animateTo(0);
                });
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildTabButton(
              text: 'Fruits',
              isSelected: _tabController.index == 1,
              onTap: () {
                setState(() {
                  _tabController.animateTo(1);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStockList(List<Map<String, dynamic>> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return StockCard(
          name: item['name']?.isEmpty ?? true ? 'Item Name' : item['name']!,
          imageUrl: item['imageUrl'] ?? '',
          initial: item['initial']?.isEmpty ?? true ? '0 kg' : item['initial']!,
          sold: item['sold']?.isEmpty ?? true ? '0 kg' : item['sold']!,
          remaining: item['remaining']?.isEmpty ?? true ? '0 kg' : item['remaining']!,
          updated: item['updated']?.isEmpty ?? true ? 'Not updated' : item['updated']!,
        );
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class StockCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String initial;
  final String sold;
  final String remaining;
  final String updated;

  const StockCard({
    Key? key,
    required this.name,
    required this.imageUrl,
    required this.initial,
    required this.sold,
    required this.remaining,
    required this.updated,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Image section
          Container(
            width: 90,
            height: 90,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.isEmpty
                  ? Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 40,
                  color: Colors.grey[400],
                ),
              )
                  : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          ),
          // Details section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildDetailRow(
                    Icons.add_circle_outline,
                    'Initial: $initial',
                    const Color(0xFF2196F3),
                  ),
                  const SizedBox(height: 4),
                  _buildDetailRow(
                    Icons.check_circle_outline,
                    'Sold: $sold',
                    const Color(0xFF66BB6A),
                  ),
                  const SizedBox(height: 4),
                  _buildDetailRow(
                    Icons.inventory_2_outlined,
                    'Remaining: $remaining',
                    const Color(0xFFFFA726),
                  ),
                  const SizedBox(height: 4),
                  _buildDetailRow(
                    Icons.access_time,
                    'Updated: $updated',
                    Colors.grey[600]!,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }
}