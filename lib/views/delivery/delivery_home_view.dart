import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:agri_link/models/user_model.dart';
import 'package:agri_link/viewmodels/user_viewmodel.dart';
import 'package:agri_link/widgets/custom_bottom_nav_bar.dart';

class DeliveryHomeView extends StatefulWidget {
  const DeliveryHomeView({super.key});

  @override
  State<DeliveryHomeView> createState() => _DeliveryHomeViewState();
}

class _DeliveryHomeViewState extends State<DeliveryHomeView> {
  final List<_OrderSummary> _orders = const [
    _OrderSummary(
      id: 'ORD-10245',
      pickup: 'Farmer\'s Market, Colombo 7',
      dropoff: 'Sunshine Restaurant, Colombo 3',
      status: OrderStatus.pending,
    ),
    _OrderSummary(
      id: 'ORD-10250',
      pickup: 'Green Farms, Gampaha',
      dropoff: 'Healthy Cafe, Colombo 5',
      status: OrderStatus.inProgress,
    ),
    _OrderSummary(
      id: 'ORD-10211',
      pickup: 'Fresh Roots, Kandy',
      dropoff: 'Downtown Superfoods, Colombo 1',
      status: OrderStatus.completed,
    ),
  ];

  int get _pendingCount =>
      _orders.where((order) => order.status == OrderStatus.pending).length;
  int get _inProgressCount =>
      _orders.where((order) => order.status == OrderStatus.inProgress).length;
  int get _completedCount =>
      _orders.where((order) => order.status == OrderStatus.completed).length;

  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    if (_selectedIndex == index) return;

    switch (index) {
      case 0:
        setState(() => _selectedIndex = 0);
        break;
      case 1:
        Navigator.pushNamed(context, AppRoutes.deliveryRides)
            .then((_) => setState(() => _selectedIndex = 0));
        break;
      case 2:
        Navigator.pushNamed(context, AppRoutes.deliveryProfile)
            .then((_) => setState(() => _selectedIndex = 0));
        break;
      case 3:
        Navigator.pushNamed(context, AppRoutes.deliverySettings)
            .then((_) => setState(() => _selectedIndex = 0));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCEB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),   // <- pass context
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                children: [
                  _buildPromoBanner(),
                  const SizedBox(height: 20),
                  _buildStatsRow(),
                  const SizedBox(height: 20),
                  Text(
                    'Latest Orders',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF375100),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._orders.map(_buildOrderCard),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFACC867), Color(0xFFCFE59A), Color(0xFFF5F9E2)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: StreamBuilder<UserModel?>(
              stream: context.read<UserViewModel>().streamCurrentUser(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                final firstName = user?.firstName?.trim();
                final greetingName =
                    (firstName != null && firstName.isNotEmpty) ? firstName : 'Delivery Partner';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello',
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$greetingName!',
                      style: textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          const Icon(
            Icons.notifications_outlined,
            color: Colors.green,
            size: 28,
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.asset(
          'assets/images/delivery/delivery.png', // same image as header
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _statCard(
          count: _pendingCount,
          label: 'Pending',
          background: const Color(0xFFDEEDC4),
        ),
        _statCard(
          count: _inProgressCount,
          label: 'In Progress',
          background: const Color(0xFFC7E7A0),
        ),
        _statCard(
          count: _completedCount,
          label: 'Completed',
          background: const Color(0xFF9EC86D),
        ),
      ],
    );
  }

  Widget _statCard({
    required int count,
    required String label,
    required Color background,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F3B00),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF1F3B00),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(_OrderSummary order) {
    final statusStyle = _statusConfig(order.status);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order ID: ${order.id}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF3A3A3A),
            ),
          ),
          const SizedBox(height: 10),
          _orderDetailRow('Pickup', order.pickup),
          const SizedBox(height: 6),
          _orderDetailRow('Dropoff', order.dropoff),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: statusStyle.background,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                statusStyle.label,
                style: TextStyle(
                  color: statusStyle.color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderDetailRow(String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF4E7A00),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  _StatusStyle _statusConfig(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return const _StatusStyle(
          label: 'Pending',
          color: Color(0xFFCD7A00),
          background: Color(0xFFFFF0D9),
        );
      case OrderStatus.inProgress:
        return const _StatusStyle(
          label: 'In Progress',
          color: Color(0xFF2E7D32),
          background: Color(0xFFE5F4E7),
        );
      case OrderStatus.completed:
        return const _StatusStyle(
          label: 'Completed',
          color: Color(0xFF1B5E20),
          background: Color(0xFFDDEEDC),
        );
    }
  }
}

enum OrderStatus { pending, inProgress, completed }

class _OrderSummary {
  final String id;
  final String pickup;
  final String dropoff;
  final OrderStatus status;

  const _OrderSummary({
    required this.id,
    required this.pickup,
    required this.dropoff,
    required this.status,
  });
}

class _StatusStyle {
  final String label;
  final Color color;
  final Color background;

  const _StatusStyle({
    required this.label,
    required this.color,
    required this.background,
  });
}
