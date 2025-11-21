import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:agri_link/routes/app_routes.dart';
import 'package:agri_link/services/auth_service.dart';

class RoleSelectionView extends StatefulWidget {
  const RoleSelectionView({super.key});

  @override
  State<RoleSelectionView> createState() => _RoleSelectionViewState();
}

class _RoleSelectionViewState extends State<RoleSelectionView> {
  String? _selectedRole;
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  void _selectRole(String role) => setState(() => _selectedRole = role);

  Future<void> _handleRoleSelection() async {
    debugPrint('🎯 Role selection button clicked');
    debugPrint('🎯 Current user ID: ${_authService.currentUserId}');
    debugPrint('🎯 Selected role: $_selectedRole');
    
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a role first.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      debugPrint('🔵 Saving role: $_selectedRole');
      
      // Update user role in Firestore
      final result = await _authService.updateUserRole(_selectedRole!);

      debugPrint('📬 Update role result: $result');

      if (!mounted) return;

      if (result['success']) {
        debugPrint('✅ Role saved successfully');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Role set as $_selectedRole!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to login
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      } else {
        debugPrint('❌ Failed to save role: ${result['message']}');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message']),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error saving role: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save role: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final primary = AppThemes.primaryGreen;
    final bg = AppThemes.backgroundCream;

    return Scaffold(
      body: Stack(
        children: [
          // Background vegetables image
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash/splash_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: bg),
            ),
          ),
          
          // Dark semi-transparent overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          
          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.12),
                  Text(
                    "I'm here as a",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.06),
                  
                  // Farmer Button
                  _roleButton('Farmer', isSelected: _selectedRole == 'Farmer', onPressed: () => _selectRole('Farmer')),
                  const SizedBox(height: 20),
                  
                  // Consumer Button
                  _roleButton('Consumer', isSelected: _selectedRole == 'Consumer', onPressed: () => _selectRole('Consumer')),
                  const SizedBox(height: 20),
                  
                  // Delivery Personnel Button
                  _roleButton('Delivery Personnel', isSelected: _selectedRole == 'Delivery Personnel', onPressed: () => _selectRole('Delivery Personnel')),
                  
                  const Spacer(),
                ],
              ),
            ),
          ),

          // Green blob decoration at bottom right
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: size.width * 0.6,
              height: size.width * 0.6,
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size.width * 0.6),
                ),
              ),
            ),
          ),

          // Arrow button
          Positioned(
            bottom: 32,
            right: 32,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              elevation: 6,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  debugPrint('⭐⭐⭐ ARROW BUTTON CLICKED! ⭐⭐⭐');
                  if (_isLoading) {
                    debugPrint('⚠️ Already loading, ignoring click');
                    return;
                  }
                  _handleRoleSelection();
                },
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: _isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(primary),
                          ),
                        )
                      : Icon(
                          Icons.arrow_forward,
                          color: primary,
                          size: 28,
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roleButton(String label, {required bool isSelected, required VoidCallback onPressed}) {
    final primary = AppThemes.primaryGreen;
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? primary : Colors.white,
          foregroundColor: isSelected ? Colors.white : Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: primary,
              width: 2,
            ),
          ),
          elevation: isSelected ? 4 : 2,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}