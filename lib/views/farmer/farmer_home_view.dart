import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/services/auth_service.dart';
import 'package:agri_link/routes/app_routes.dart';

class FarmerHomeView extends StatefulWidget {
  const FarmerHomeView({super.key});

  @override
  State<FarmerHomeView> createState() => _FarmerHomeViewState();
}

class _FarmerHomeViewState extends State<FarmerHomeView> {
  final AuthService _authService = AuthService();

  Future<void> _handleLogout() async {
    await _authService.signOut();
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.backgroundCream,
      appBar: AppBar(
        backgroundColor: AppThemes.primaryGreen,
        title: const Text('Farmer Dashboard', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.agriculture,
                size: 120,
                color: AppThemes.primaryGreen,
              ),
              const SizedBox(height: 32),
              Text(
                'Welcome, Farmer!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.primaryGreen,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your farmer dashboard is coming soon.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
