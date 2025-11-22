import 'package:flutter/material.dart';
import '../../core/constants/app_themes.dart';
import 'order_details_view.dart'; // Add this import

class ViewOrdersView extends StatefulWidget {
  const ViewOrdersView({Key? key}) : super(key: key);

  @override
  State<ViewOrdersView> createState() => _ViewOrdersViewState();
}

class _ViewOrdersViewState extends State<ViewOrdersView> {
  final TextEditingController _searchController = TextEditingController();

  // TODO: This will be populated from your backend
  // Showing placeholder cards until orders are loaded from database
  List<Map<String, dynamic>> orders = [
    {
      'name': '',
      'farmer': '',
      'quantity': '',
      'price': '',
      'status': 'Pending', // Pending, New, Accepted
      'imageUrl': ''
    },
    {
      'name': '',
      'farmer': '',
      'quantity': '',
      'price': '',
      'status': 'New',
      'imageUrl': ''
    },
    {
      'name': '',
      'farmer': '',
      'quantity': '',
      'price': '',
      'status': 'Pending',
      'imageUrl': ''
    },
    {
      'name': '',
      'farmer': '',
      'quantity': '',
      'price': '',
      'status': 'Accepted',
      'imageUrl': ''
    },
  ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // TODO: Call your backend API here to fetch orders
    // _loadOrdersFromBackend();
  }

  // TODO: Implement this method to fetch data from your backend
  Future<void> _loadOrdersFromBackend() async {
    setState(() => isLoading = true);

    // Example:
    // final response = await YourBackendService.getOrders();
    // setState(() {
    //   orders = response;
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
          // Header section
          _buildHeader(),
          // Search bar
          _buildSearchBar(),
          // Orders grid
          Expanded(
            child: isLoading
                ? Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
                : _buildOrdersGrid(),
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
                  'Orders',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balance the back button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Find Your Needs',
            hintStyle: TextStyle(
              color: Colors.grey[500],
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[600],
              size: 22,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
          ),
          onChanged: (value) {
            // TODO: Implement search functionality
          },
        ),
      ),
    );
  }

  Widget _buildOrdersGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.68,
        ),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderCard(
            productName: order['name']?.isEmpty ?? true ? 'Product Name' : order['name']!,
            farmerName: order['farmer']?.isEmpty ?? true ? 'Farmer Name' : order['farmer']!,
            quantity: order['quantity']?.isEmpty ?? true ? '0 kg' : order['quantity']!,
            price: order['price']?.isEmpty ?? true ? 'Rs 0.00' : order['price']!,
            status: order['status'] ?? 'Pending',
            imageUrl: order['imageUrl'] ?? '',
            onTap: () {
              // Navigate to order details screen with the order data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailsView(order: order),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class OrderCard extends StatelessWidget {
  final String productName;
  final String farmerName;
  final String quantity;
  final String price;
  final String status; // Pending, New, Accepted
  final String imageUrl;
  final VoidCallback onTap; // Added this

  const OrderCard({
    Key? key,
    required this.productName,
    required this.farmerName,
    required this.quantity,
    required this.price,
    required this.status,
    required this.imageUrl,
    required this.onTap, // Added this
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFA726); // Orange
      case 'new':
        return const Color(0xFF42A5F5); // Blue
      case 'accepted':
        return const Color(0xFF66BB6A); // Green
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Wrapped with GestureDetector
      onTap: onTap, // Added this
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _getStatusColor(),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              child: Container(
                height: 110,
                width: double.infinity,
                color: const Color(0xFFF5F5F5),
                child: imageUrl.isEmpty
                    ? Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 50,
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
                        size: 50,
                        color: Colors.grey[400],
                      ),
                    );
                  },
                ),
              ),
            ),
            // Product details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      farmerName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      quantity,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                    ),
                    const Spacer(),
                    // Status button
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}