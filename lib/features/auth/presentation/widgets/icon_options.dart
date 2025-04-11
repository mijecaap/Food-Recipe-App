import 'package:flutter/material.dart';
import 'package:recipez/core/constants/app_color.dart';

enum Menu { profile, signOut }

class IconOptions extends StatefulWidget {
  final VoidCallback onPressed;
  final double heightIcon;

  const IconOptions(
      {required this.onPressed, required this.heightIcon, super.key});

  @override
  State<IconOptions> createState() => _IconOptionsState();
}

class _IconOptionsState extends State<IconOptions> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
        onSelected: (Menu item) {},
        child: Container(
            height: widget.heightIcon,
            width: widget.heightIcon,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.heightIcon / 2)),
            child: FittedBox(
              child: Icon(
                Icons.more_vert,
                color: AppColor.fourthyColor,
              ),
            )),
        itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
              PopupMenuItem<Menu>(
                value: Menu.profile,
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 16.0),
                    Text('Subscribe')
                  ],
                ),
              ),
              PopupMenuItem<Menu>(
                value: Menu.signOut,
                onTap: widget.onPressed,
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 16.0),
                    Text('Sign Out')
                  ],
                ),
              ),
            ]);
  }
}
