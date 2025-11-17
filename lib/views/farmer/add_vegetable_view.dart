import 'package:flutter/material.dart';

class AddVegetableView extends StatefulWidget {
  const AddVegetableView({Key? key}) : super(key: key);

  @override
  State<AddVegetableView> createState() => _AddVegetableViewState();
}

class _AddVegetableViewState extends State<AddVegetableView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Vegetable')),
      body: const Center(child: Text('Add Vegetable View')),
    );
  }
}
