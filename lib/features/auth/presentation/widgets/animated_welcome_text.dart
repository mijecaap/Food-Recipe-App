import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnimatedWelcomeText extends StatelessWidget {
  const AnimatedWelcomeText({
    super.key,
    this.textColor = const Color(0xFF1C153C),
    this.fontSize,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.pauseDuration = const Duration(milliseconds: 1000),
    this.textHeight = 100,
    this.fontWeight = FontWeight.w900,
    this.reduceAnimation = false,
  });

  final Color textColor;
  final double? fontSize;
  final Duration animationDuration;
  final Duration pauseDuration;
  final double textHeight;
  final FontWeight fontWeight;
  final bool reduceAnimation;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double calculatedFontSize =
        fontSize ?? (screenWidth * 0.07).clamp(20.0, 30.0);

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: textHeight,
        child: DefaultTextStyle(
          style: GoogleFonts.italiana(
            textStyle: Theme.of(context).textTheme.headlineMedium,
            fontSize: calculatedFontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
          child:
              MediaQuery.of(context).accessibleNavigation || reduceAnimation
                  ? const Text(
                    'Bienvenido a Recipez',
                    textAlign: TextAlign.center,
                    semanticsLabel: 'Mensaje de bienvenida a Recipez',
                  )
                  : AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText(
                        'Bienvenido a Recipez',
                        duration: animationDuration,
                        textAlign: TextAlign.center,
                        fadeInEnd: 0.5,
                        fadeOutBegin: 0.8,
                      ),
                      FadeAnimatedText(
                        'Welcome to Recipez',
                        duration: animationDuration,
                        textAlign: TextAlign.center,
                        fadeInEnd: 0.5,
                        fadeOutBegin: 0.8,
                      ),
                      FadeAnimatedText(
                        'Benvenuto su Recipez',
                        duration: animationDuration,
                        textAlign: TextAlign.center,
                        fadeInEnd: 0.5,
                        fadeOutBegin: 0.8,
                      ),
                      FadeAnimatedText(
                        'Bienvenue sur Recipez',
                        duration: animationDuration,
                        textAlign: TextAlign.center,
                        fadeInEnd: 0.5,
                        fadeOutBegin: 0.8,
                      ),
                      FadeAnimatedText(
                        'Recipezへようこそ',
                        duration: animationDuration,
                        textAlign: TextAlign.center,
                        fadeInEnd: 0.5,
                        fadeOutBegin: 0.8,
                      ),
                    ],
                    pause: pauseDuration,
                    repeatForever: true,
                  ),
        ),
      ),
    );
  }
}
