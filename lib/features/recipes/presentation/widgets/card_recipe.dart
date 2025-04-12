import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:recipez/features/recipes/domain/entities/recipe.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_event.dart';
import 'package:recipez/features/recipes/presentation/pages/recipe_information.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_state.dart';

class CardRecipe extends StatelessWidget {
  final Recipe recipe;

  const CardRecipe({required this.recipe, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final isAuthenticated = context.read<AuthBloc>().state is Authenticated;
        final currentUserId =
            isAuthenticated
                ? (context.read<AuthBloc>().state as Authenticated).user.uid
                : '';

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (BuildContext context) => RecipeInformation(
                  recipe.id,
                  recipe.userId,
                  isAuthenticated && currentUserId == recipe.userId,
                ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: recipe.imageUrl,
                    width: double.infinity,
                    height: 130,
                    fit: BoxFit.cover,
                    memCacheWidth: 400, // Limitar el tamaño en memoria
                    memCacheHeight: 300,
                    fadeInDuration: const Duration(milliseconds: 300),
                    placeholderFadeInDuration: const Duration(
                      milliseconds: 200,
                    ),
                    placeholder:
                        (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Image.asset(
                          'assets/no-image.png',
                          width: double.infinity,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is Authenticated) {
                        final isLiked = recipe.likes.contains(state.user.uid);
                        return GestureDetector(
                          onTap: () {
                            context.read<RecipeBloc>().add(
                              LikeRecipeEvent(recipe.id, state.user.uid),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              recipe.title,
              style: GoogleFonts.roboto(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: recipe.userPhotoUrl,
                    width: 20,
                    height: 20,
                    fit: BoxFit.cover,
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
                          child: const Icon(Icons.person, size: 14),
                        ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    recipe.userName,
                    style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
