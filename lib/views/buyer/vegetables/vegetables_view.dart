import 'package:flutter/material.dart';

class VegetablesView extends StatefulWidget {
  const VegetablesView({Key? key}) : super(key: key);

  @override
  State<VegetablesView> createState() => _VegetablesViewState();
}

class _VegetablesViewState extends State<VegetablesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vegetables')),
      body: const Center(child: Text('Vegetables View')),
    );
  }
}
