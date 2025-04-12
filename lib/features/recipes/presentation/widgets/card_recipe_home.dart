import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_event.dart';
import 'package:recipez/features/recipes/presentation/pages/recipe_information.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CardRecipeHome extends StatelessWidget {
  final String id;
  final String imageRecipe;
  final String titleRecipe;
  final String personQuantity;
  final String estimatedTime;
  final String uid;
  final bool isMain;
  final RecipeBloc recipeBloc;

  const CardRecipeHome(
    this.id,
    this.imageRecipe,
    this.titleRecipe,
    this.personQuantity,
    this.estimatedTime,
    this.uid,
    this.isMain,
    this.recipeBloc, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var statusHeight = MediaQuery.of(context).viewPadding.top;
    var size = MediaQuery.of(context).size;
    var screenHeight = (size.height - (statusHeight)) / 4;

    return GestureDetector(
      onTap: () {
        context.read<RecipeBloc>().add(UpdateViewsEvent(id));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => BlocProvider.value(
                  value: recipeBloc,
                  child: RecipeInformation(id, uid, false),
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        width: 240,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(screenHeight / 24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Hero(
                tag: 'recipe-$id',
                child: CachedNetworkImage(
                  imageUrl: imageRecipe,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              const Color(0xFFC2B8FF), // Color lila_1_8ff
                            ),
                          ),
                        ),
                      ),
                  errorWidget:
                      (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Image.asset(
                            'assets/no-image.png',
                            width: 48,
                            height: 48,
                          ),
                        ),
                      ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
              padding: EdgeInsets.all(screenHeight / 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    titleRecipe[0].toUpperCase() + titleRecipe.substring(1),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    presetFontSizes: const [18, 16, 14],
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isMain) ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.group,
                          size: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          personQuantity,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "$estimatedTime min",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
