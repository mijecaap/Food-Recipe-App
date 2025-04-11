import 'package:flutter/material.dart';
import 'package:recipez/core/constants/app_color.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: AppColor.primaryColor,
      ),
      body: const Center(
        child: Text('Información del perfil'),
      ),
    );
  }
}
