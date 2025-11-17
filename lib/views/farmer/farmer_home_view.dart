import 'package:flutter/material.dart';

class FarmerHomeView extends StatefulWidget {
  const FarmerHomeView({Key? key}) : super(key: key);

  @override
  State<FarmerHomeView> createState() => _FarmerHomeViewState();
}

class _FarmerHomeViewState extends State<FarmerHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Farmer Home')),
      body: const Center(child: Text('Farmer Home View')),
    );
  }
}
