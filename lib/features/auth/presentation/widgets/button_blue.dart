import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonBlue extends StatefulWidget {
  final String text;
  final double width;
  final double height;
  final VoidCallback onPressed;

  const ButtonBlue(
      {super.key,
      required this.text,
      required this.onPressed,
      this.width = 0.0,
      this.height = 0.0});

  @override
  State<ButtonBlue> createState() => _ButtonBlueState();
}

class _ButtonBlueState extends State<ButtonBlue> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 30.0,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          gradient: LinearGradient(
              colors: [Color(0xFF2596BE), Color(0xFF325EA8)],
              begin: FractionalOffset(0.2, 0.0),
              end: FractionalOffset(1.0, 0.6),
              stops: [0.0, 0.6],
              tileMode: TileMode.clamp)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(15.0),
          child: SizedBox(
            width: widget.width,
            height: widget.height,
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageIcon(
                  NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/59/59439.png"),
                  size: 18.0,
                  color: Colors.white,
                ),
                SizedBox(width: 16.0),
                Text(widget.text,
                    style: GoogleFonts.openSans(
                        fontSize: 18.0, color: Colors.white)),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
