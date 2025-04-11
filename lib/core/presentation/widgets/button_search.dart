import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/recipes/presentation/bloc/recipe_bloc.dart';
import '../../../features/recipes/presentation/pages/search.dart';
import '../../constants/app_color.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_state.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonSearch extends StatelessWidget {
  final AuthBloc userBloc;

  const ButtonSearch({required this.userBloc, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
          color: AppColor.gris_1_8fa,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Material(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          onTap: () {
            final authState = context.read<AuthBloc>().state;
            if (authState is Authenticated) {
              if (authState.user.subscription) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BlocProvider(
                    create: (_) => context.read<RecipeBloc>(),
                    child: Search(authState.user.uid),
                  );
                }));
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          title: const Text("Not subscribed"),
                          content: const Text(
                              "To activate search, go to my profile and purchase the subscription."),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'OK'),
                              child: const Text('OK'),
                            ),
                          ],
                        ));
              }
            }
          },
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Search your favorite recipe",
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColor.morado_1_57a),
                  ),
                  const Icon(Icons.search, size: 20),
                ],
              )),
        ),
      ),
    );
  }
}
