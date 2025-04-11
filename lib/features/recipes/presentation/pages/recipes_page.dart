import 'package:flutter/material.dart';
import 'package:recipez/core/constants/app_color.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: const Center(
        child: Text('Lista de recetas'),
      ),
    );
  }
}
