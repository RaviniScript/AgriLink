import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 

class AppThemes {
  AppThemes._();
  static const Color primaryGreen = Color(0xFF609400); // Main Green
  static const Color backgroundCream = Color(0xFFFFFDE8); // Cream Background
  static const Color neutralDark = Color(0xFF333333); // Main text
  
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryGreen,
    scaffoldBackgroundColor: backgroundCream,
    fontFamily: 'Poppins', 
  );
}

class AppRoutes {
  // Mock routes needed for navigation calls
  static const String login = '/login'; 
  // FIX: Added the welcome route constant to navigate to WelcomeView
  static const String welcome = '/welcome'; 
  static const String homeSelector = '/homeSelector'; 
}

class MockView extends StatelessWidget {
  final String title;
  const MockView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title Placeholder View')),
    );
  }
}

class _OnboardPage {
  final String image;
  final String title;
  final String subtitle;

  _OnboardPage({required this.image, required this.title, required this.subtitle});
}

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
      title: 'Connecting Farmers,\nBuyers, &\nDelivery Personnel',
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
      
      Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
    }
  }

  Widget _buildDot(int index) {
    final isActive = index == _currentIndex;
    final Color activeColor = AppThemes.primaryGreen;
    final Color inactiveColor = Colors.grey.shade300;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(right: 8),
      width: isActive ? 28.0 : 10.0,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inactiveColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final primaryColor = AppThemes.primaryGreen;

    return Scaffold(
      backgroundColor: AppThemes.backgroundCream,
      body: SafeArea(
        child: Stack(
          children: [
            // --- 1. PageView Content ---
            PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (context, index) {
                final page = _pages[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    // Changed to CrossAxisAlignment.start to align elements to the left
                    crossAxisAlignment: CrossAxisAlignment.stretch, 
                    children: [
                      // --- Image Area (Larger and Centered) ---
                      SizedBox(height: size.height * 0.05), // Small top margin
                      SizedBox(
                        height: size.height * 0.55, // Allocated 55% of screen height for the image area
                        child: Center(
                          child: Image.asset(
                            page.image,
                            fit: BoxFit.contain, // Ensures the image fits without cropping
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
                      
                      // --- Text Area (Below Image) ---
                      SizedBox(height: size.height * 0.05), // Space below image (5% height)
                      Text(
                        page.title,
                        // --- FIX: Changed from TextAlign.center to TextAlign.start ---
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppThemes.neutralDark,
                          fontWeight: FontWeight.w700,
                          fontSize: size.width * 0.065, // Responsive text size
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        page.subtitle,
                        // --- FIX: Changed from TextAlign.center to TextAlign.start ---
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w400,
                          fontSize: size.width * 0.04,
                        ),
                      ),
                      
                      const Spacer(), // Pushes content up, making room for bottom nav
                      const SizedBox(height: 80), // Space reservation for bottom elements
                    ],
                  ),
                );
              },
            ),

            // --- 2. Pagination Dots ---
            Positioned(
              left: 24,
              bottom: 48,
              child: Row(
                children: List.generate(_pages.length, (i) => _buildDot(i)),
              ),
            ),

            // --- 3. Combined Green Blob and Floating Action Button ---
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                // Size of the green quadrant blob
                width: size.width * 0.45, 
                height: size.width * 0.45, 
                decoration: BoxDecoration(
                  color: primaryColor, 
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(size.width * 0.45), 
                  ),
                ),
                child: Align(
                  // Position the button within the green blob.
                  alignment: const Alignment(0.35, 0.35), 
                  child: FloatingActionButton(
                    onPressed: _nextPage,
                    backgroundColor: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 6,
                    child: Icon(
                      Icons.arrow_forward, 
                      color: primaryColor, 
                      size: 24,
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