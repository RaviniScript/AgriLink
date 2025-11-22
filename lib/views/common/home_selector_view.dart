import 'package:flutter/material.dart';
import 'package:agri_link/core/constants/app_themes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:agri_link/routes/app_routes.dart';

class HomeSelectorView extends StatefulWidget {
  const HomeSelectorView({Key? key}) : super(key: key);

  @override
  State<HomeSelectorView> createState() => _HomeSelectorViewState();
}

class _HomeSelectorViewState extends State<HomeSelectorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.backgroundCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Your Role',
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppThemes.primaryGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Choose how you want to use AgriLink',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              _buildRoleCard(
                context: context,
                title: 'Buyer',
                description: 'Purchase fresh farm products',
                icon: Icons.shopping_basket,
                onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.buyerHome),
              ),
              const SizedBox(height: 20),
              _buildRoleCard(
                context: context,
                title: 'Farmer',
                description: 'Sell your products',
                icon: Icons.agriculture,
                onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.farmerHome),
              ),
              const SizedBox(height: 20),
              _buildRoleCard(
                context: context,
                title: 'Delivery',
                description: 'Deliver orders',
                icon: Icons.delivery_dining,
                onTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.deliveryHome),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required BuildContext context,
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppThemes.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppThemes.primaryGreen, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: AppThemes.primaryGreen),
            ],
          ),
        ),
      ),
    );
  }
}
