import 'package:flutter/material.dart';

class FruitsListView extends StatefulWidget {
  const FruitsListView({super.key});

  @override
  State<FruitsListView> createState() => _FruitsListViewState();
}

class _FruitsListViewState extends State<FruitsListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fruits List')),
      body: const Center(child: Text('Fruits List View')),
    );
  }
}
