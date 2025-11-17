import 'package:flutter/material.dart';

class HomeSelectorView extends StatefulWidget {
  const HomeSelectorView({Key? key}) : super(key: key);

  @override
  State<HomeSelectorView> createState() => _HomeSelectorViewState();
}

class _HomeSelectorViewState extends State<HomeSelectorView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Selector')),
      body: const Center(child: Text('Home Selector View')),
    );
  }
}
