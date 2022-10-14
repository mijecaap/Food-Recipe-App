import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Shared/model/app_color.dart';

class OptionsActionSheet extends StatefulWidget {
  VoidCallback onPressed;
  VoidCallback onPressed2;

  OptionsActionSheet({required this.onPressed, required this.onPressed2, Key? key}) : super(key: key);

  @override
  State<OptionsActionSheet> createState() => _OptionsActionSheetState();
}

class _OptionsActionSheetState extends State<OptionsActionSheet> {

  void _showActionsSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          "Options",
          style: GoogleFonts.openSans(),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              widget.onPressed2();
              Navigator.pop(context);
            },
            child: Text(
              "Subscribe",
              style: GoogleFonts.openSans(
                color: AppColor.secondaryColor.withBlue(30)
              ),
            ),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              widget.onPressed();
              Navigator.pop(context);
            },
            child: Text(
              "Sign Out",
              style: GoogleFonts.openSans(),
            ),
          )
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => _showActionsSheet(context),
      child: const Icon(
        Icons.more_horiz,
        size: 24,
      ),
    );
  }
}
