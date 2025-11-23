import 'package:flutter/material.dart';

class VegetablesListView extends StatefulWidget {
  const VegetablesListView({super.key});

  @override
  State<VegetablesListView> createState() => _VegetablesListViewState();
}

class _VegetablesListViewState extends State<VegetablesListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vegetables List')),
      body: const Center(child: Text('Vegetables List View')),
    );
  }
}
