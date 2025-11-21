import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agri_link/routes/app_routes.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardPage> _pages = [
    _OnboardPage(
      image: 'assets/images/onboarding/onboarding1.png',
      title: 'Welcome to AgriLink',
      subtitle: 'where growth begins',
    ),
    _OnboardPage(
      image: 'assets/images/onboarding/onboarding2.png',
      title: 'Connecting Farmers, Buyers, &\nDelivery Personnel',
      subtitle: 'All in one place',
    ),
    _OnboardPage(
      image: 'assets/images/onboarding/onboarding3.png',
      title: 'Grow smarter',
      subtitle: 'trade easier, & build stronger\ncommunities',
    ),
  ];

  void _nextPage() {
    if (_currentIndex < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      // TODO: After teammate merges welcome + auth UI, this should go to login
      // Temporary: Navigate to home selector (will be replaced with new role selection)
      Navigator.of(context).pushReplacementNamed(AppRoutes.homeSelector);
      // After merge, change to: Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppThemes.backgroundCream,
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final page = _pages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      // illustration
                      Expanded(
                        child: Center(
                          child: Image.asset(
                            page.image,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.broken_image, size: 72, color: Colors.grey[400]),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Missing asset:\n${page.image.split('/').last}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),

                      // Title and subtitle
                      Text(
                        page.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        page.subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),

                      const SizedBox(height: 60),
                    ],
                  ),
                );
              },
            ),

            // bottom-left indicators
            Positioned(
              left: 24,
              bottom: 32,
              child: Row(
                children: List.generate(_pages.length, (i) {
                  final isActive = i == _currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 8),
                    width: isActive ? 28 : 12,
                    height: 6,
                    decoration: BoxDecoration(
                      color: isActive ? AppThemes.primaryGreen : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
            ),

            // bottom-right curved green shape with arrow button
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppThemes.primaryGreen,
                  borderRadius: BorderRadius.circular(80),
                ),
                child: Align(
                  alignment: Alignment(0.35, 0.35),
                  child: GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppThemes.primaryGreen,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardPage {
  final String image;
  final String title;
  final String subtitle;

  _OnboardPage({required this.image, required this.title, required this.subtitle});
}
