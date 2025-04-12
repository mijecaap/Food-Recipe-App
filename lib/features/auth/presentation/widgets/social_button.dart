import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SocialButton extends StatelessWidget {
  final String text;
  final String iconUrl;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final double width;
  final double height;

  const SocialButton({
    super.key,
    required this.text,
    required this.iconUrl,
    required this.onPressed,
    required this.gradientColors,
    this.width = 300.0,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: const FractionalOffset(0.2, 0.0),
          end: const FractionalOffset(1.0, 0.6),
          stops: const [0.0, 0.6],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15.0),
          child: SizedBox(
            width: width,
            height: height,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl: iconUrl,
                    width: 18.0,
                    height: 18.0,
                    color: Colors.white,
                    placeholder:
                        (context, url) => const SizedBox(
                          width: 18.0,
                          height: 18.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => const Icon(
                          Icons.error,
                          size: 18.0,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(width: 16.0),
                  Text(
                    text,
                    style: GoogleFonts.openSans(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
