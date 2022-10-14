import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Shared/ui/widgets/title_header.dart';
import 'package:recipez/User/bloc/bloc_user.dart';
import 'package:recipez/User/model/user.dart';
import 'package:recipez/User/ui/widgets/button_blue.dart';
import 'package:recipez/User/ui/widgets/button_green.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipez/recipez_app.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  late UserBloc userBloc;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of(context);
    return _handleCurrentSesion();
  }

  Widget _handleCurrentSesion() {
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // snapshot contiene nuestra data
        if (!snapshot.hasData || snapshot.hasError) {
          return signIn();
        } else {
          return RecipezApp();
        }
      },
    );
  }



  Widget signIn(){
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
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1C153C),
                  ),

                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText('Bienvenido a Recipez'), //Español
                      FadeAnimatedText('Welcome to Recipez'), //Inglés
                      FadeAnimatedText('Benvenuto su Recipez'), //Italiano
                      FadeAnimatedText('Bienvenue sur Recipez'), //Frances
                      FadeAnimatedText('Recipezへようこそ'), //Japonés
                    ],
                    pause: const Duration(milliseconds: 1500),
                    repeatForever: true,
                  ),
                ),
              ),
            ),

            Image.asset('assets/Logo.png'),

            Text(
                "Iniciar Sesión",
              style:  TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1C153C),
              ),

            ),

            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Column(
                children: [

                  ButtonBlue(
                    text: "Facebook",
                    onPressed: () {
                      userBloc.signOut();
                      userBloc.singInFacebook()
                          .then((User? user) {
                        userBloc.getUserId()
                            .then((value) => userBloc.readUser(value)
                            .then((value) {
                          if(value.uid.isEmpty) {
                            userBloc.updateUserData(UserModel(
                                uid: user!.uid,
                                name: user.displayName!,
                                email: user.email!,
                                photoURL: user.photoURL!,
                                subscription: false,
                                myRecipes: [],
                                favoriteRecipes: []
                            ));
                          }
                        }));
                      });
                    },
                    width: 300.0,
                    height: 50.0,
                  ),
                  ButtonGreen(
                    text: "Gmail",
                    onPressed: () {
                      userBloc.signOut();
                      userBloc.signIn()
                          .then((User? user) {
                        userBloc.getUserId()
                            .then((value) => userBloc.readUser(value)
                            .then((value) {
                          if(value.uid.isEmpty) {
                            userBloc.updateUserData(UserModel(
                                uid: user!.uid,
                                name: user.displayName!,
                                email: user.email!,
                                photoURL: user.photoURL!,
                                subscription: false,
                                myRecipes: [],
                                favoriteRecipes: []
                            ));
                          }
                        }));
                      });
                    },
                    width: 300.0,
                    height: 50.0,
                  ),
                ],
              )
            ),

            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 150,
              child: SizedBox(
                child: DefaultTextStyle(
                  style: GoogleFonts.italiana(
                    textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1C153C),
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      FadeAnimatedText('¡Buen provecho!'), //Español
                      FadeAnimatedText('Bon appetit!'), //Inglés
                      FadeAnimatedText('Buon appetito!'), //Italiano
                      FadeAnimatedText('Bon appétit!'), //Frances
                      FadeAnimatedText('ボナペティ！'), //Japonés
                    ],
                    pause: const Duration(milliseconds: 1500),
                    repeatForever: true,
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
