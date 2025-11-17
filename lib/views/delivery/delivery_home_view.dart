import 'package:flutter/material.dart';

class DeliveryHomeView extends StatefulWidget {
  const DeliveryHomeView({Key? key}) : super(key: key);

  @override
  State<DeliveryHomeView> createState() => _DeliveryHomeViewState();
}

class _DeliveryHomeViewState extends State<DeliveryHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Home')),
      body: const Center(child: Text('Delivery Home View')),
    );
  }
}
