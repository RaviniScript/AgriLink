import 'package:flutter/material.dart';

class VegetableDetailsView extends StatefulWidget {
  const VegetableDetailsView({Key? key}) : super(key: key);

  @override
  State<VegetableDetailsView> createState() => _VegetableDetailsViewState();
}

class _VegetableDetailsViewState extends State<VegetableDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vegetable Details')),
      body: const Center(child: Text('Vegetable Details View')),
    );
  }
}
