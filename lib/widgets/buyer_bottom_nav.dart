import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:agri_link/services/cart_service.dart';

class BuyerBottomNav extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BuyerBottomNav({Key? key, this.currentIndex = 0, required this.onTap}) : super(key: key);

  @override
  State<BuyerBottomNav> createState() => _BuyerBottomNavState();
}

class _BuyerBottomNavState extends State<BuyerBottomNav> {
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _cartService.addListener(_onCartUpdated);
  }

  @override
  void dispose() {
    _cartService.removeListener(_onCartUpdated);
    super.dispose();
  }

  void _onCartUpdated() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = _cartService.itemCount;
    return Container(
      decoration: BoxDecoration(
        color: AppThemes.primaryGreen,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: widget.onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white.withOpacity(0.6),
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            BottomNavigationBarItem(
              icon: _buildIcon('assets/icons/buyer/nav_home.png', Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon('assets/icons/buyer/nav_accounts.png', Icons.people),
              label: 'Farmers',
            ),
            BottomNavigationBarItem(
              icon: _buildIcon('assets/icons/buyer/nav_profile.png', Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: _buildCartIcon(cartCount),
              label: 'Cart',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(String assetPath, IconData fallback) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Image.asset(
        assetPath,
        width: 24,
        height: 24,
        color: Colors.white,
        errorBuilder: (context, error, stackTrace) {
          return Icon(fallback, size: 24, color: Colors.white);
        },
      ),
    );
  }

  Widget _buildCartIcon(int count) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _buildIcon('assets/icons/buyer/nav_cart.png', Icons.shopping_cart),
        if (count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 18,
                minHeight: 18,
              ),
              child: Text(
                count > 99 ? '99+' : count.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
