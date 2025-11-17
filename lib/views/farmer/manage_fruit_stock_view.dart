import 'package:flutter/material.dart';

class ManageFruitStockView extends StatefulWidget {
  const ManageFruitStockView({Key? key}) : super(key: key);

  @override
  State<ManageFruitStockView> createState() => _ManageFruitStockViewState();
}

class _ManageFruitStockViewState extends State<ManageFruitStockView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Fruit Stock')),
      body: const Center(child: Text('Manage Fruit Stock View')),
    );
  }
}
