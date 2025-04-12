import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipez/core/constants/app_color.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_state.dart';
import 'package:recipez/core/presentation/app/recipez_app.dart';
import 'package:recipez/features/auth/presentation/widgets/animated_welcome_text.dart';
import 'package:recipez/features/auth/presentation/widgets/social_login_buttons.dart';
import 'package:recipez/features/auth/presentation/widgets/terms_dialog.dart';

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
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is Authenticated) {
          return const RecipezApp();
        }
        if (state is AuthLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFFC2B8FF),
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return _buildSignInScreen(context);
      },
    );
  }

  Widget _buildSignInScreen(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFC2B8FF),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const AnimatedWelcomeText(),
                    Semantics(
                      image: true,
                      label: 'Logo de la aplicación',
                      child: Image.asset(
                        'assets/Logo.png',
                        width: size.width * 0.7,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.1,
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Iniciar Sesión",
                            style: Theme.of(
                              context,
                            ).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColor.morado_3_53c,
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          const SocialLoginButtons(),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: const TermsDialog(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
