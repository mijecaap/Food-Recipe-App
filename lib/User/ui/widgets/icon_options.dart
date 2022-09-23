import 'package:flutter/material.dart';
import 'package:recipez/Shared/model/app_color.dart';

enum Menu { profile, signOut }

class IconOptions extends StatefulWidget {

  VoidCallback onPressed;
  final double heightIcon;

  IconOptions({required this.onPressed, required this.heightIcon, Key? key}) : super(key: key);

  @override
  State<IconOptions> createState() => _IconOptionsState();
}

class _IconOptionsState extends State<IconOptions> {
  String _selectedMenu = '';

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Menu>(
      // Callback that sets the selected popup menu item.
        onSelected: (Menu item) {
          setState(() {
            _selectedMenu = item.name;
          });
        },
        child: Container(
          height: widget.heightIcon,
          width: widget.heightIcon,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.heightIcon / 2)
          ),
          child: FittedBox(
            child: Icon(
              Icons.more_vert,
              color: AppColor.fourthyColor,
            ),
          )
        ),
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
            child: Row(
              children: [
                Icon(Icons.logout),
                SizedBox(width: 16.0),
                Text('Sign Out')
              ],
            ),
            onTap: widget.onPressed,
          ),
        ]);
  }
}
