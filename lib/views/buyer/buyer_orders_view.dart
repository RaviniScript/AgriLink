import 'package:flutter/material.dart';

class BuyerOrdersView extends StatefulWidget {
  const BuyerOrdersView({Key? key}) : super(key: key);

  @override
  State<BuyerOrdersView> createState() => _BuyerOrdersViewState();
}

class _BuyerOrdersViewState extends State<BuyerOrdersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: const Center(child: Text('Buyer Orders View')),
    );
  }
}
