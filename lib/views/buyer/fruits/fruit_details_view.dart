import 'package:flutter/material.dart';

class FruitDetailsView extends StatefulWidget {
  const FruitDetailsView({super.key});

  @override
  State<FruitDetailsView> createState() => _FruitDetailsViewState();
}

class _FruitDetailsViewState extends State<FruitDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fruit Details')),
      body: const Center(child: Text('Fruit Details View')),
    );
  }
}
