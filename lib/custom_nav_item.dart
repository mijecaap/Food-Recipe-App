import 'package:flutter/material.dart';
import 'package:recipez/Shared/model/app_color.dart';
import '../main.dart';

class CustomNavItem extends StatelessWidget {
  final IconData icon;
  final int id;
  final Function setPage;
  int indexTap;

  CustomNavItem({
    required this.setPage,
    required this.icon,
    required this.id,
    required this.indexTap,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setPage(id);
      },
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(30),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: AppColor.morado_2_347,
          child: CircleAvatar(
            radius: 25,
            backgroundColor: indexTap == id
                ? Colors.white.withOpacity(0.9)
                : Colors.transparent,
            child: Icon(
              icon,
              color: indexTap == id
                  ? AppColor.morado_2_347
                  : Colors.white,
              size: 32.0,
            ),
          ),
        ),
      )
    );
  }
}
