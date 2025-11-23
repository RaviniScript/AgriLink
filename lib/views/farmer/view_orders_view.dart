import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_themes.dart';
import '../../services/order_service.dart';
import 'order_details_view.dart';

class ViewOrdersView extends StatefulWidget {
  const ViewOrdersView({Key? key}) : super(key: key);

  @override
  State<ViewOrdersView> createState() => _ViewOrdersViewState();
}

class _ViewOrdersViewState extends State<ViewOrdersView> {
  final TextEditingController _searchController = TextEditingController();
  final OrderService _orderService = OrderService();
  
  StreamSubscription<QuerySnapshot>? _ordersSubscription;
  List<Map<String, dynamic>> orders = [];
  List<Map<String, dynamic>> filteredOrders = [];
  bool isLoading = true;
  String? _justUpdatedOrderId;

  @override
  void initState() {
    super.initState();
    _setupOrdersStream();
  }

  void _setupOrdersStream() {
    setState(() => isLoading = true);
    
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('❌ No user logged in');
        setState(() => isLoading = false);
        return;
      }

      print('🔍 Setting up real-time orders stream for farmer UID: ${currentUser.uid}');
      
      _ordersSubscription = _orderService.streamFarmerOrders(currentUser.uid).listen(
        (QuerySnapshot snapshot) {
          print('📦 Stream update: ${snapshot.docs.length} orders');
          
          final fetchedOrders = snapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            data['id'] = doc.id;
            return data;
          }).toList();
          
          if (fetchedOrders.isNotEmpty) {
            print('📦 First order: Buyer ${fetchedOrders[0]['buyerName']}, Status ${fetchedOrders[0]['status']}');
          }
          
          // If we just updated an order locally, preserve that status
          if (_justUpdatedOrderId != null) {
            final justUpdatedOrder = orders.firstWhere(
              (o) => o['id'] == _justUpdatedOrderId,
              orElse: () => {},
            );
            if (justUpdatedOrder.isNotEmpty) {
              final fetchedOrderIndex = fetchedOrders.indexWhere((o) => o['id'] == _justUpdatedOrderId);
              if (fetchedOrderIndex != -1) {
                fetchedOrders[fetchedOrderIndex]['status'] = justUpdatedOrder['status'];
              }
            }
            _justUpdatedOrderId = null; // Clear the flag
          }
          
          setState(() {
            orders = fetchedOrders;
            // Apply current search filter if exists
            if (_searchController.text.isEmpty) {
              filteredOrders = fetchedOrders;
            } else {
              _applySearchFilter(_searchController.text);
            }
            isLoading = false;
          });
        },
        onError: (error) {
          print('❌ Stream error: $error');
          setState(() => isLoading = false);
        },
      );
    } catch (e) {
      print('❌ Error setting up stream: $e');
      setState(() => isLoading = false);
    }
  }

  void _applySearchFilter(String query) {
    if (query.isEmpty) {
      filteredOrders = orders;
    } else {
      filteredOrders = orders.where((order) {
        final buyerName = (order['buyerName'] ?? '').toString().toLowerCase();
        final productNames = (order['items'] as List?)
            ?.map((item) => (item['productName'] ?? '').toString().toLowerCase())
            .join(' ') ?? '';
        final searchQuery = query.toLowerCase();
        return buyerName.contains(searchQuery) || productNames.contains(searchQuery);
      }).toList();
    }
  }

  @override
  void dispose() {
    _ordersSubscription?.cancel();
    _searchController.dispose();
    super.dispose();
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
            setState(() {
              _applySearchFilter(value);
            });
          },
        ),
      ),
    );
  }

  Widget _buildOrdersGrid() {
    if (filteredOrders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.62,
        ),
        itemCount: filteredOrders.length,
        itemBuilder: (context, index) {
          final order = filteredOrders[index];
          final items = order['items'] as List<dynamic>? ?? [];
          final firstItem = items.isNotEmpty ? items[0] : {};
          
          // Calculate total quantity
          final totalQuantity = items.fold<int>(
            0,
            (sum, item) => sum + ((item['quantity'] as num?)?.toInt() ?? 0),
          );
          
          return OrderCard(
            productName: items.length > 1 
                ? '${items.length} items' 
                : (firstItem['productName']?.toString() ?? 'N/A'),
            buyerName: order['buyerName']?.toString() ?? 'Unknown Buyer',
            quantity: '$totalQuantity ${firstItem['unit'] ?? 'kg'}',
            price: 'Rs ${(order['total'] as num?)?.toStringAsFixed(2) ?? '0.00'}',
            status: _mapOrderStatus(order['status']?.toString() ?? 'pending'),
            imageUrl: firstItem['imageUrl']?.toString() ?? '',
            onTap: () async {
              final originalStatus = order['status']?.toString().toLowerCase();
              
              // If order is 'new', mark it as 'pending' when farmer views it
              if (originalStatus == 'new') {
                try {
                  // Update in Firebase - the stream will automatically update the UI
                  await _orderService.updateOrderStatus(order['id'], 'pending');
                } catch (e) {
                  print('Error updating order status: $e');
                }
              }
              
              if (mounted) {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsView(order: order),
                  ),
                );
                
                // If order was accepted/rejected, update the local list immediately
                if (result == true && mounted) {
                  setState(() {
                    // Mark this order as just updated to preserve status on next stream update
                    _justUpdatedOrderId = order['id'];
                    
                    // Find and update this specific order in both lists
                    final orderIndex = orders.indexWhere((o) => o['id'] == order['id']);
                    if (orderIndex != -1) {
                      orders[orderIndex]['status'] = order['status'];
                    }
                    
                    final filteredIndex = filteredOrders.indexWhere((o) => o['id'] == order['id']);
                    if (filteredIndex != -1) {
                      filteredOrders[filteredIndex]['status'] = order['status'];
                    }
                  });
                }
              }
            },
          );
        },
      ),
    );
  }

  String _mapOrderStatus(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return 'New';
      case 'pending':
        return 'Pending';
      case 'confirmed':
      case 'accepted':
        return 'Accepted';
      case 'preparing':
        return 'Preparing';
      case 'ready':
        return 'Ready';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return 'Pending';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class OrderCard extends StatelessWidget {
  final String productName;
  final String buyerName;
  final String quantity;
  final String price;
  final String status; // Pending, New, Accepted
  final String imageUrl;
  final VoidCallback onTap; // Added this

  const OrderCard({
    Key? key,
    required this.productName,
    required this.buyerName,
    required this.quantity,
    required this.price,
    required this.status,
    required this.imageUrl,
    required this.onTap, // Added this
  }) : super(key: key);

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'new':
        return const Color(0xFF2196F3); // Bright Blue for New
      case 'pending':
        return const Color(0xFFFF9800); // Orange for Pending
      case 'accepted':
      case 'confirmed':
        return const Color(0xFF66BB6A); // Green
      case 'preparing':
        return const Color(0xFFFFA726); // Orange
      case 'ready':
        return const Color(0xFF9C27B0); // Purple
      case 'delivered':
        return const Color(0xFF4CAF50); // Dark Green
      case 'cancelled':
        return const Color(0xFFEF5350); // Red
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
                height: 90,
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
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      productName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      buyerName,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      quantity,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF2C2C2C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2C2C2C),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Status button
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
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