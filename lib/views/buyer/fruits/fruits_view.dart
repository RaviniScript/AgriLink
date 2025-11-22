import 'package:flutter/material.dart';

class FruitsView extends StatefulWidget {
  const FruitsView({Key? key}) : super(key: key);

  @override
  State<FruitsView> createState() => _FruitsViewState();
}

class _FruitsViewState extends State<FruitsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fruits')),
      body: const Center(child: Text('Fruits View')),
    );
  }
}

// Function to calculate the sum of numbers in a list


