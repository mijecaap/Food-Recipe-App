import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/core/constants/app_color.dart';
import 'package:recipez/features/auth/presentation/widgets/button_blue.dart';
import 'package:recipez/features/auth/presentation/widgets/button_green.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_event.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_state.dart';
import 'package:recipez/core/presentation/app/recipez_app.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          return const RecipezApp();
        }
        return _buildSignInScreen(context);
      },
    );
  }

  Widget _buildSignInScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC2B8FF),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 100,
              child: SizedBox(
                child: DefaultTextStyle(
                  style: GoogleFonts.italiana(
                    textStyle: Theme.of(context).textTheme.headlineMedium,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1C153C),
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText('Bienvenido a Recipez'),
                      FadeAnimatedText('Welcome to Recipez'),
                      FadeAnimatedText('Benvenuto su Recipez'),
                      FadeAnimatedText('Bienvenue sur Recipez'),
                      FadeAnimatedText('Recipezへようこそ'),
                    ],
                    pause: const Duration(milliseconds: 1000),
                    repeatForever: true,
                  ),
                ),
              ),
            ),
            Image.asset('assets/Logo.png'),
            Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: Column(
                  children: [
                    Text(
                      "Iniciar Sesión",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        color: AppColor.morado_3_53c,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ButtonBlue(
                      text: "Facebook",
                      onPressed: () {
                        context
                            .read<AuthBloc>()
                            .add(SignInWithFacebookPressed());
                      },
                      width: 300.0,
                      height: 50.0,
                    ),
                    ButtonGreen(
                      text: "Gmail",
                      onPressed: () {
                        context.read<AuthBloc>().add(SignInWithGooglePressed());
                      },
                      width: 300.0,
                      height: 50.0,
                    ),
                  ],
                )),
            Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: TextButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text('Terms and Conditions'),
                            content: SizedBox(
                              height: 300,
                              child: const SingleChildScrollView(
                                child: Text(
                                  'Lorem ipsum dolor sit amet...',
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, 'OK'),
                                child: const Text('OK'),
                              ),
                            ],
                          )),
                  child: Text(
                    "Términos y Condiciones",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AppColor.morado_3_53c,
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
