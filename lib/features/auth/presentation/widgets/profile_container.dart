import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/core/constants/app_color.dart';
import 'package:recipez/features/auth/domain/entities/user.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_state.dart';
import 'package:recipez/features/auth/presentation/widgets/subscription_button.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileContainer extends StatelessWidget {
  final AuthBloc userBloc;
  final User user;

  const ProfileContainer({
    super.key,
    required this.userBloc,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: userBloc,
      builder: (context, state) {
        if (state is AuthLoading) {
          return const CardLoading(
            height: 54,
            borderRadius: BorderRadius.all(Radius.circular(15)),
          );
        }
        if (state is Authenticated) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildProfileData(context, state.user),
          );
        }
        return _buildProfileData(context, user);
      },
    );
  }

  Widget _buildProfileData(BuildContext context, User currentUser) {
    return Container(
      key: ValueKey(currentUser.uid),
      height: 54,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.gris_1_8fa,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Hero(
            tag: 'profile-${currentUser.uid}',
            child: SizedBox(
              height: 32,
              width: 32,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: currentUser.photoURL,
                  placeholder:
                      (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 20),
                      ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              currentUser.name,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SubscriptionButton(currentUser: currentUser),
        ],
      ),
    );
  }
}
