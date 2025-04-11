import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recipez/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:recipez/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:recipez/features/auth/domain/repositories/auth_repository.dart';
import 'package:recipez/features/auth/domain/usecases/sign_in_with_facebook.dart';
import 'package:recipez/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:recipez/features/auth/domain/usecases/sign_out.dart';
import 'package:recipez/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recipez/features/recipes/data/datasources/recipe_remote_datasource.dart';
import 'package:recipez/features/recipes/data/repositories/recipe_repository_impl.dart';
import 'package:recipez/features/recipes/domain/repositories/recipe_repository.dart';
import 'package:recipez/features/recipes/domain/usecases/create_recipe.dart';
import 'package:recipez/features/recipes/domain/usecases/get_all_recipes.dart';
import 'package:recipez/features/recipes/domain/usecases/get_recipe_by_id.dart';
import 'package:recipez/features/recipes/presentation/bloc/recipe_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signInWithGoogle: sl(),
      signInWithFacebook: sl(),
      signOut: sl(),
      repository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInWithGoogle(sl()));
  sl.registerLazySingleton(() => SignInWithFacebook(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      auth: sl(),
      firestore: sl(),
      googleSignIn: sl(),
      facebookAuth: sl(),
    ),
  );

  // Features - Recipes
  // Bloc
  sl.registerFactory(
    () => RecipeBloc(
      repository: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllRecipes(sl()));
  sl.registerLazySingleton(() => GetRecipeById(sl()));
  sl.registerLazySingleton(() => CreateRecipe(sl()));

  // Repository
  sl.registerLazySingleton<RecipeRepository>(
    () => RecipeRepositoryImpl(sl()),
  );

  // Data sources
  sl.registerLazySingleton<RecipeRemoteDataSource>(
    () => RecipeRemoteDataSourceImpl(
      firestore: sl(),
    ),
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => FacebookAuth.instance);
}