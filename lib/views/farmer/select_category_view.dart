import 'package:flutter/material.dart';

class SelectCategoryView extends StatefulWidget {
  const SelectCategoryView({Key? key}) : super(key: key);

  @override
  State<SelectCategoryView> createState() => _SelectCategoryViewState();
}

class _SelectCategoryViewState extends State<SelectCategoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Category')),
      body: const Center(child: Text('Select Category View')),
    );
  }
}
