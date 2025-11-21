import 'package:flutter/material.dart';
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
      appBar: AppBar(title: const Text('Home Selector')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Select your role', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Navigate to farmer home and remove this from stack
                Navigator.of(context).pushReplacementNamed(AppRoutes.farmerHome);
              },
              child: const SizedBox(width: double.infinity, child: Center(child: Text('Farmer'))),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Buyer path (placeholder)
                Navigator.of(context).pushReplacementNamed(AppRoutes.buyerHome);
              },
              child: const SizedBox(width: double.infinity, child: Center(child: Text('Buyer'))),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // Delivery path (placeholder)
                Navigator.of(context).pushReplacementNamed(AppRoutes.deliveryHome);
              },
              child: const SizedBox(width: double.infinity, child: Center(child: Text('Delivery'))),
            ),
          ],
        ),
      ),
    );
  }
}
