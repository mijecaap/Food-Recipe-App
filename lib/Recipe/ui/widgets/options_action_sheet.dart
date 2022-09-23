import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Shared/model/app_color.dart';

class OptionsActionSheet extends StatefulWidget {
  VoidCallback onPressed;
  VoidCallback onPressed2;
  final double heightIcon;

  OptionsActionSheet({required this.onPressed, required this.onPressed2, required this.heightIcon, Key? key}) : super(key: key);

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

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.heightIcon / 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showActionsSheet(context),
          borderRadius: BorderRadius.circular(widget.heightIcon / 2),
          child: Container(
            height: widget.heightIcon,
            width: widget.heightIcon,
            child: Icon(
              Icons.more_vert,
              size: widget.heightIcon / 1.5,
            )
          ),
        ),
      )
    );
  }
}
