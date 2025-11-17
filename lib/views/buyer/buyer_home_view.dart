import 'package:flutter/material.dart';

class BuyerHomeView extends StatefulWidget {
  const BuyerHomeView({Key? key}) : super(key: key);

  @override
  State<BuyerHomeView> createState() => _BuyerHomeViewState();
}

class _BuyerHomeViewState extends State<BuyerHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buyer Home')),
      body: const Center(child: Text('Buyer Home View')),
    );
  }
}
