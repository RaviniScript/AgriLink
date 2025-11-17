import 'package:flutter/material.dart';

class AddFruitView extends StatefulWidget {
  const AddFruitView({Key? key}) : super(key: key);

  @override
  State<AddFruitView> createState() => _AddFruitViewState();
}

class _AddFruitViewState extends State<AddFruitView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Fruit')),
      body: const Center(child: Text('Add Fruit View')),
    );
  }
}
