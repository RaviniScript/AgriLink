import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/services/order_service.dart';
import 'package:agri_link/services/review_service.dart';
import 'package:agri_link/views/buyer/widgets/add_review_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class OrderHistoryView extends StatefulWidget {
  final String buyerPhone;

  const OrderHistoryView({Key? key, required this.buyerPhone})
      : super(key: key);

  @override
  State<OrderHistoryView> createState() => _OrderHistoryViewState();
}

class _OrderHistoryViewState extends State<OrderHistoryView> {
  final OrderService _orderService = OrderService();
  final ReviewService _reviewService = ReviewService();
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5DC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF5F5DC),
        title: Text(
          'Order History',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/back_icon.png',
            width: 24,
            height: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _orderService.streamBuyerOrders(widget.buyerPhone),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppThemes.primaryGreen,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            size: 64, color: Colors.red[300]),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading orders',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag_outlined,
                            size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No orders yet',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Start shopping to see your orders here',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Filter orders based on selected status
                final allOrders = snapshot.data!.docs;
                final filteredOrders = _selectedFilter == 'all'
                    ? allOrders
                    : allOrders.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return data['status'] == _selectedFilter;
                      }).toList();

                if (filteredOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.filter_list_off,
                            size: 64, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No ${_selectedFilter} orders',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredOrders.length,
                  itemBuilder: (context, index) {
                    final orderDoc = filteredOrders[index];
                    final orderData =
                        orderDoc.data() as Map<String, dynamic>;
                    return _buildOrderCard(orderDoc.id, orderData);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('All', 'all'),
            const SizedBox(width: 8),
            _buildFilterChip('Pending', 'pending'),
            const SizedBox(width: 8),
            _buildFilterChip('Confirmed', 'confirmed'),
            const SizedBox(width: 8),
            _buildFilterChip('Delivered', 'delivered'),
            const SizedBox(width: 8),
            _buildFilterChip('Cancelled', 'cancelled'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: Colors.grey[200],
      selectedColor: AppThemes.primaryGreen,
      labelStyle: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
        color: isSelected ? Colors.white : Colors.grey[700],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Future<void> _showReviewDialog(String orderId, Map<String, dynamic> orderData) async {
    // Check if already reviewed
    final hasReviewed = await _reviewService.hasReviewed(orderId, 'buyer_001');
    
    if (hasReviewed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have already reviewed this order'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Get product info from first item (for simplicity, review first product)
    final items = orderData['items'] as List<dynamic>? ?? [];
    if (items.isEmpty) return;
    
    final firstItem = items[0] as Map<String, dynamic>;
    final productId = firstItem['productId'] ?? '';
    final productName = firstItem['productName'] ?? 'Product';

    final result = await showDialog(
      context: context,
      builder: (context) => AddReviewDialog(
        orderId: orderId,
        productId: productId,
        buyerId: 'buyer_001', // TODO: Get from auth
        buyerName: 'Customer', // TODO: Get from buyer profile
        productName: productName,
      ),
    );

    if (result == true) {
      // Review submitted successfully, refresh if needed
      setState(() {});
    }
  }

  Widget _buildOrderCard(String orderId, Map<String, dynamic> orderData) {
    final status = orderData['status'] ?? 'pending';
    final total = orderData['total'] ?? 0.0;
    final items = orderData['items'] as List<dynamic>? ?? [];
    final farmerName = orderData['farmerName'] ?? 'Unknown Farmer';
    final createdAt = orderData['createdAt'] as Timestamp?;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showOrderDetails(orderId, orderData),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order #${orderId.substring(0, 8).toUpperCase()}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          farmerName,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(status),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${items.length} item${items.length > 1 ? 's' : ''}',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (createdAt != null)
                        Text(
                          DateFormat('MMM dd, yyyy')
                              .format(createdAt.toDate()),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                  Text(
                    'Rs ${total.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppThemes.primaryGreen,
                    ),
                  ),
                ],
              ),
              
              // Write Review Button for delivered orders
              if (status.toLowerCase() == 'delivered') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showReviewDialog(orderId, orderData),
                    icon: const Icon(Icons.rate_review, size: 18),
                    label: Text(
                      'Write Review',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppThemes.primaryGreen,
                      side: const BorderSide(color: AppThemes.primaryGreen),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'pending':
        badgeColor = Colors.orange;
        icon = Icons.schedule;
        break;
      case 'confirmed':
        badgeColor = Colors.blue;
        icon = Icons.check_circle_outline;
        break;
      case 'delivered':
        badgeColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'cancelled':
        badgeColor = Colors.red;
        icon = Icons.cancel_outlined;
        break;
      default:
        badgeColor = Colors.grey;
        icon = Icons.info_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: badgeColor),
          const SizedBox(width: 4),
          Text(
            status.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: badgeColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(String orderId, Map<String, dynamic> orderData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          final items = orderData['items'] as List<dynamic>? ?? [];
          final status = orderData['status'] ?? 'pending';
          final subtotal = orderData['subtotal'] ?? 0.0;
          final deliveryFee = orderData['deliveryFee'] ?? 0.0;
          final total = orderData['total'] ?? 0.0;
          final farmerName = orderData['farmerName'] ?? 'Unknown Farmer';
          final deliveryAddress = orderData['deliveryAddress'] ?? '';
          final paymentMethod = orderData['paymentMethod'] ?? '';
          final notes = orderData['notes'] ?? '';
          final createdAt = orderData['createdAt'] as Timestamp?;

          return Container(
            padding: const EdgeInsets.all(24),
            child: ListView(
              controller: scrollController,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Order Details',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                      ),
                    ),
                    _buildStatusBadge(status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Order #${orderId.substring(0, 8).toUpperCase()}',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                if (createdAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy - hh:mm a')
                        .format(createdAt.toDate()),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                _buildDetailSection('Farmer', farmerName),
                const SizedBox(height: 16),
                _buildDetailSection('Delivery Address', deliveryAddress),
                const SizedBox(height: 16),
                _buildDetailSection(
                  'Payment Method',
                  paymentMethod.toUpperCase(),
                ),
                if (notes.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _buildDetailSection('Notes', notes),
                ],
                const SizedBox(height: 24),
                Text(
                  'Items',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 12),
                ...items.map((item) => _buildOrderItem(item)).toList(),
                const Divider(height: 32),
                _buildPriceRow('Subtotal', subtotal),
                const SizedBox(height: 8),
                _buildPriceRow('Delivery Fee', deliveryFee),
                const Divider(height: 24),
                _buildPriceRow('Total', total, isTotal: true),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItem(dynamic item) {
    final productName = item['productName'] ?? '';
    final quantity = item['quantity'] ?? 0;
    final price = item['price'] ?? 0.0;
    final unit = item['unit'] ?? '';
    final imageUrl = item['imageUrl'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported,
                          color: Colors.grey[500]),
                    ),
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[300],
                    child: Icon(Icons.shopping_bag,
                        color: Colors.grey[500]),
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$quantity $unit × Rs ${price.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Rs ${(quantity * price).toStringAsFixed(2)}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppThemes.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
        Text(
          'Rs ${amount.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.w700,
            color: isTotal ? AppThemes.primaryGreen : Colors.grey[800],
          ),
        ),
      ],
    );
  }
}
