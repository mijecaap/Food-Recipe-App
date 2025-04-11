import 'package:flutter/material.dart';

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;

    path.moveTo(0, sh / 3);
    path.cubicTo(0, sh / 3, sw / 24, 0, 2 * sw / 12, 0);
    path.cubicTo(3 * sw / 12, 0, 3 * sw / 12, 0, 4 * sw / 12, 0);
    path.cubicTo(
        5 * sw / 12, 0, 5 * sw / 12, 2 * sh / 3, 6 * sw / 12, 2 * sh / 3);
    path.cubicTo(7 * sw / 12, 2 * sh / 3, 7 * sw / 12, 0, 8 * sw / 12, 0);
    path.lineTo(10 * sw / 12, 0);
    path.cubicTo(10 * sw / 12, 0, sw - (sw / 24), 0, sw, sh / 3);
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
