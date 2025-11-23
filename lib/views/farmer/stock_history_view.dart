import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_themes.dart';
import '../../repository/stock_history_repository.dart';
import '../../models/stock_history_model.dart';

class StockHistoryView extends StatefulWidget {
  const StockHistoryView({Key? key}) : super(key: key);

  @override
  State<StockHistoryView> createState() => _StockHistoryViewState();
}

class _StockHistoryViewState extends State<StockHistoryView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final StockHistoryRepository _stockRepo = StockHistoryRepository();

  List<StockHistoryModel> vegetables = [];
  List<StockHistoryModel> fruits = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {}); // Rebuild to update button states
    });
    _loadStockFromBackend();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload stock when returning to this view
    _loadStockFromBackend();
  }

  Future<void> _loadStockFromBackend() async {
    setState(() => isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('❌ No user logged in');
        setState(() => isLoading = false);
        return;
      }

      print('📦 Loading stock history for farmer: ${currentUser.uid}');

      // Load vegetables
      final vegList = await _stockRepo.getFarmerStockByCategory(currentUser.uid, 'Vegetables');
      print('   ✅ Loaded ${vegList.length} vegetables');

      // Load fruits
      final fruitList = await _stockRepo.getFarmerStockByCategory(currentUser.uid, 'Fruits');
      print('   ✅ Loaded ${fruitList.length} fruits');

      setState(() {
        vegetables = vegList;
        fruits = fruitList;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading stock: $e');
      setState(() => isLoading = false);
    }
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
                RefreshIndicator(
                  onRefresh: _loadStockFromBackend,
                  color: AppColors.primary,
                  child: _buildStockList(vegetables),
                ),
                RefreshIndicator(
                  onRefresh: _loadStockFromBackend,
                  color: AppColors.primary,
                  child: _buildStockList(fruits),
                ),
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

  Widget _buildStockList(List<StockHistoryModel> items) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No stock history yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add products to see stock history',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return StockCard(
          name: item.productName,
          imageUrl: item.imageUrl,
          initial: '${item.initialStock} ${item.unit}',
          sold: '${item.soldQuantity} ${item.unit}',
          remaining: '${item.remainingStock} ${item.unit}',
          updated: DateFormat('MMM dd, yyyy hh:mm a').format(item.updatedAt),
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