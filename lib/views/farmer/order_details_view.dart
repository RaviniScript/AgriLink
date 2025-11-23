import 'package:flutter/material.dart';
import '../../core/constants/app_themes.dart';
import '../../services/order_service.dart';

class OrderDetailsView extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsView({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderDetailsView> createState() => _OrderDetailsViewState();
}

class _OrderDetailsViewState extends State<OrderDetailsView> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          // Header
          _buildHeader(context),
          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Product image card
                    _buildProductImage(),
                    const SizedBox(height: 24),
                    // Order details card
                    _buildOrderDetailsCard(),
                    const SizedBox(height: 24),
                    // Action buttons
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
                onPressed: () => Navigator.pop(context, false), // Return false when going back without action
              ),
              const Expanded(
                child: Text(
                  'Order Details',
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

  Widget _buildProductImage() {
    final items = widget.order['items'] as List<dynamic>? ?? [];
    final imageUrl = items.isNotEmpty ? items[0]['imageUrl']?.toString() ?? '' : '';
    
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: imageUrl.isEmpty
            ? Center(
          child: Icon(
            Icons.image_outlined,
            size: 60,
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
                size: 60,
                color: Colors.grey[400],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderDetailsCard() {
    final items = widget.order['items'] as List<dynamic>? ?? [];
    final firstItem = items.isNotEmpty ? items[0] : {};
    final totalQuantity = items.fold<double>(
      0,
      (sum, item) => sum + ((item['quantity'] as num?)?.toDouble() ?? 0),
    );
    final productName = items.length > 1 
        ? '${items.length} items' 
        : (firstItem['productName']?.toString() ?? 'N/A');
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildDetailRow('Buyer', widget.order['buyerName']?.toString() ?? 'N/A'),
            _buildDivider(),
            _buildDetailRow('Crop', productName),
            _buildDivider(),
            _buildDetailRow('Quantity', '$totalQuantity ${firstItem['unit'] ?? 'kg'}'),
            _buildDivider(),
            _buildDetailRow('Price', 'Rs ${(widget.order['total'] as num?)?.toStringAsFixed(2) ?? '0.00'}'),
            _buildDivider(),
            _buildDetailRow('Status', _capitalizeStatus(widget.order['status']?.toString() ?? 'Pending')),
            _buildDivider(),
            _buildDetailRow('Order Type', _getPaymentMethodDisplay(widget.order['paymentMethod']?.toString() ?? 'cash')),
          ],
        ),
      ),
    );
  }
  
  String _getPaymentMethodDisplay(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'cash':
        return 'Cash on Delivery';
      case 'card':
        return 'Card Payment';
      default:
        return 'Cash on Delivery';
    }
  }
  
  String _capitalizeStatus(String status) {
    if (status.isEmpty) return 'Pending';
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF2C2C2C),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[200],
      thickness: 1,
      height: 1,
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final status = widget.order['status']?.toString().toLowerCase() ?? 'pending';
    // Show Accept/Reject buttons only for 'new' and 'pending' statuses
    if (status != 'pending' && status != 'new') {
      return const SizedBox.shrink();
    }
    
    if (_isProcessing) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _showActionDialog(context, 'Reject', 'Are you sure you want to reject this order?', 'cancelled');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Reject',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              _showActionDialog(context, 'Accept', 'Are you sure you want to accept this order?', 'accepted');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF689F38),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Accept',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showActionDialog(BuildContext context, String action, String message, String newStatus) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            action,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: _isProcessing ? null : () => Navigator.pop(dialogContext),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: _isProcessing ? null : () async {
                setState(() => _isProcessing = true);
                Navigator.pop(dialogContext); // Close confirmation dialog
                
                // Update local order status immediately
                widget.order['status'] = newStatus;
                
                // Update Firebase in background
                OrderService().updateOrderStatus(widget.order['id'], newStatus).catchError((e) {
                  print('Error updating order status: $e');
                });
                
                setState(() => _isProcessing = false);
                
                // Show success message dialog immediately
                if (context.mounted) {
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext successContext) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Text(
                          'Success',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        content: Text('The order is ${newStatus == 'accepted' ? 'accepted' : 'rejected'}'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(successContext); // Close success dialog
                              Navigator.pop(context, true); // Go back to orders screen with result
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text(
                action,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}