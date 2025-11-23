import 'package:flutter/material.dart';

class DeliveryMapView extends StatefulWidget {
  const DeliveryMapView({super.key});

  @override
  State<DeliveryMapView> createState() => _DeliveryMapViewState();
}

class _DeliveryMapViewState extends State<DeliveryMapView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Map')),
      body: const Center(child: Text('Delivery Map View')),
    );
  }
}
