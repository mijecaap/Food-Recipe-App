import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_bloc.dart';
import 'package:recipez/core/injection/injection_container.dart' as di;
import 'package:recipez/core/presentation/widgets/navigation/bottom_nav_bar.dart';

class RecipezApp extends StatefulWidget {
  const RecipezApp({super.key});

  @override
  State<RecipezApp> createState() => _RecipezAppState();
}

class _RecipezAppState extends State<RecipezApp> {
  int _currentIndex = 0;

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider<RecipeBloc>(
          create: (_) => di.sl<RecipeBloc>(),
        ),
      ],
      child: Scaffold(
        body: BottomNavBar(
          indexTap: _currentIndex,
          onTapTapped: _onTapTapped,
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
