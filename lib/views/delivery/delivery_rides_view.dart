import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_themes.dart';
import '../../routes/app_routes.dart';
import '../../viewmodels/user_viewmodel.dart';
import '../../widgets/custom_bottom_nav_bar.dart';
import '../../models/user_model.dart';
import 'package:flutter/material.dart';

class DeliveryRidesView extends StatelessWidget {
  const DeliveryRidesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFCEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF5F8807),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Rides', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ride #${index + 1}', style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              const Text('Pickup: Farmer’s Market, Colombo 7'),
              const Text('Drop-off: Sunshine Restaurant, Colombo 3'),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.timer, size: 18, color: Color(0xFF5F8807)),
                  const SizedBox(width: 6),
                  Text(index == 0 ? 'Pending' : index == 1 ? 'In Progress' : 'Completed'),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5F8807),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Details'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppRoutes {
  static const String deliveryRides = '/delivery-rides';
}

// Inside your route generator switch case
/*
  switch (settings.name) {
    // ...existing cases...
    case AppRoutes.deliveryRides:
      return MaterialPageRoute(builder: (_) => const DeliveryRidesView());
  }
*/