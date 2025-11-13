
import 'package:flutter/material.dart';
import '../../core/constants/app_themes.dart';
import '../../widgets/common/custom_bottom_nav_bar.dart';

class FarmerHomeView extends StatefulWidget {
  const FarmerHomeView({Key? key}) : super(key: key);

  @override
  State<FarmerHomeView> createState() => _FarmerHomeViewState();
}

class _FarmerHomeViewState extends State<FarmerHomeView> {
  int _currentBannerIndex = 0;
  int _selectedNavIndex = 0;
  final PageController _bannerController = PageController();

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedNavIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        _showComingSoon('Accounts');
        break;
      case 2:
        _showComingSoon('Profile');
        break;
      case 3:
        _showComingSoon('Settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    _buildBannerCarousel(),
                    const SizedBox(height: 24),
                    _buildNavigationGrid(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            CustomBottomNavBar(
              currentIndex: _selectedNavIndex,
              onTap: _onNavItemTapped,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primary,
            AppColors.primaryLight.withOpacity(0.6),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello',
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                'Arunal!',
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.notifications,
              color: Colors.white,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCarousel() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView(
            controller: _bannerController,
            onPageChanged: (index) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
            children: [
              _buildBannerCard(
                title: 'Are you a',
                subtitle: 'Farmer?',
                description: 'Sell your\nProducts here',
              ),
              _buildBannerCard(
                title: 'Fresh Products',
                subtitle: 'Daily!',
                description: 'Quality\nGuaranteed',
              ),
              _buildBannerCard(
                title: 'Best Prices',
                subtitle: 'Market!',
                description: 'Competitive\nRates',
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
                (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentBannerIndex == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentBannerIndex == index
                    ? AppColors.primary
                    : Colors.grey.shade300,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerCard({
    required String title,
    required String subtitle,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFFFF9C4),
            const Color(0xFFFFE082),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFFD4A574).withOpacity(0.35),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          subtitle,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        description,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: const Color(0xFFB85450),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.person,
                        size: 75,
                        color: AppColors.secondary,
                      ),
                      Positioned(
                        bottom: 18,
                        child: Icon(
                          Icons.eco,
                          size: 38,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 0.95,
      children: [
        _buildNavigationCard(
          title: 'My Crops',
          imagePath: 'assets/images/my_crops.png',
          onTap: () => _showComingSoon('My Crops'),
        ),
        _buildNavigationCard(
          title: 'Add Crops',
          imagePath: 'assets/images/add_crops.png',
          onTap: () => _showComingSoon('Add Crops'),
        ),
        _buildNavigationCard(
          title: 'View Orders',
          imagePath: 'assets/images/view_orders.png',
          onTap: () => _showComingSoon('View Orders'),
        ),
        _buildNavigationCard(
          title: 'Stock History',
          imagePath: 'assets/images/stock_history.png',
          onTap: () => _showComingSoon('Stock History'),
        ),
      ],
    );
  }

  Widget _buildNavigationCard({
    required String title,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  imagePath,
                  width: 110,
                  height: 110,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    IconData fallbackIcon;
                    Color fallbackColor;

                    if (title == 'My Crops') {
                      fallbackIcon = Icons.shopping_basket;
                      fallbackColor = AppColors.error;
                    } else if (title == 'Add Crops') {
                      fallbackIcon = Icons.add_box;
                      fallbackColor = AppColors.success;
                    } else if (title == 'View Orders') {
                      fallbackIcon = Icons.shopping_cart;
                      fallbackColor = AppColors.success;
                    } else {
                      fallbackIcon = Icons.folder_open;
                      fallbackColor = AppColors.info;
                    }

                    return Icon(
                      fallbackIcon,
                      size: 70,
                      color: fallbackColor,
                    );
                  },
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming Soon'),
        duration: const Duration(milliseconds: 800),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}