import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/constants/app_themes.dart';
import '../../widgets/common/custom_bottom_nav_bar.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';

class FarmerHomeView extends StatefulWidget {
  const FarmerHomeView({super.key});

  @override
  State<FarmerHomeView> createState() => _FarmerHomeViewState();
}

class _FarmerHomeViewState extends State<FarmerHomeView> {
  final AuthService _authService = AuthService();
  int _selectedNavIndex = 0;
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % 2;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    if (_selectedNavIndex == index) return;

    setState(() {
      _selectedNavIndex = index;
    });

    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.farmerAccounts);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.farmerProfile);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRoutes.farmerSettings);
        break;
    }
  }

  Future<void> _handleLogout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
                child: Column(
                  children: [
                    _buildBannerCarousel(),
                    const SizedBox(height: 12),
                    _buildNavigationGrid(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedNavIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 45, left: 24, right: 24, bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primary,
            AppColors.primaryLight.withOpacity(0.4),
            Colors.white.withOpacity(0.3),
          ],
          stops: const [0.0, 0.6, 1.0],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
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
                  fontSize: 24,
                ),
              ),
              Text(
                'Aruna!',
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ],
          ),
          const Icon(
            Icons.notifications_outlined,
            color: Colors.green,
            size: 28,
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
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              _buildBannerCard('assets/images/farmer_banner.png'),
              _buildBannerCard('assets/images/farmer_banner_2.png'),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPageIndicator(0),
            const SizedBox(width: 8),
            _buildPageIndicator(1),
          ],
        ),
      ],
    );
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      width: _currentPage == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? AppColors.primary : Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildBannerCard(String imagePath) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF9C4), Color(0xFFFFE082)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 175,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              Icons.agriculture,
              size: 80,
              color: AppColors.primaryDark,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.1,
      children: [
        _buildNavigationCard(
          title: 'My Crops',
          imagePath: 'assets/images/my_crops.png',
          onTap: () => Navigator.pushNamed(context, AppRoutes.myCrops),
        ),
        _buildNavigationCard(
          title: 'Add Crops',
          imagePath: 'assets/images/add_crops.png',
          onTap: () => Navigator.pushNamed(context, AppRoutes.addCrops),
        ),
        _buildNavigationCard(
          title: 'View Orders',
          imagePath: 'assets/images/view_orders.png',
          onTap: () => Navigator.pushNamed(context, AppRoutes.viewOrders),
        ),
        _buildNavigationCard(
          title: 'Stock History',
          imagePath: 'assets/images/stock_history.png',
          onTap: () => Navigator.pushNamed(context, AppRoutes.stockHistory),
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
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  imagePath,
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported_outlined,
                    size: 60,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}