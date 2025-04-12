import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_event.dart';
import 'package:recipez/features/auth/presentation/widgets/social_button.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  Future<void> _handleSocialLogin(
    BuildContext context,
    Function() loginAction,
  ) async {
    try {
      loginAction();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar sesión: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SocialButton(
          text: "Facebook",
          iconUrl: "https://cdn-icons-png.flaticon.com/512/59/59439.png",
          gradientColors: const [Color(0xFF2596BE), Color(0xFF325EA8)],
          onPressed:
              () => _handleSocialLogin(
                context,
                () => context.read<AuthBloc>().add(SignInWithFacebookPressed()),
              ),
        ),
        const SizedBox(height: 16),
        SocialButton(
          text: "Gmail",
          iconUrl: "https://cdn-icons-png.flaticon.com/512/2875/2875331.png",
          gradientColors: const [Color(0xFFEA4335), Color(0xFFC5221F)],
          onPressed:
              () => _handleSocialLogin(
                context,
                () => context.read<AuthBloc>().add(SignInWithGooglePressed()),
              ),
        ),
      ],
    );
  }
}
