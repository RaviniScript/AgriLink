import 'package:flutter/material.dart';

class ManageVegetableStockView extends StatefulWidget {
  const ManageVegetableStockView({Key? key}) : super(key: key);

  @override
  State<ManageVegetableStockView> createState() => _ManageVegetableStockViewState();
}

class _ManageVegetableStockViewState extends State<ManageVegetableStockView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Vegetable Stock')),
      body: const Center(child: Text('Manage Vegetable Stock View')),
    );
  }
}
