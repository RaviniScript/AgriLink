import 'package:flutter/material.dart';

class DeliveryOrderListView extends StatefulWidget {
  const DeliveryOrderListView({super.key});

  @override
  State<DeliveryOrderListView> createState() => _DeliveryOrderListViewState();
}

class _DeliveryOrderListViewState extends State<DeliveryOrderListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Orders')),
      body: const Center(child: Text('Delivery Order List View')),
    );
  }
}
