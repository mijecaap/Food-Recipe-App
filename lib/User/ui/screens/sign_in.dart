import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Shared/ui/widgets/title_header.dart';
import 'package:recipez/User/bloc/bloc_user.dart';
import 'package:recipez/User/model/user.dart';
import 'package:recipez/User/ui/widgets/button_green.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipez/recipez_app.dart';

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
          return signInGoogleUI();
        } else {
          return RecipezApp();
        }
      },
    );
  }

  Widget signInGoogleUI() {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome\nThis is your Recipe App",
                style: GoogleFonts.openSans(
                  fontSize: 30.0,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              ButtonGreen(
                text: "Login with Gmail",
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
              )
            ],
          ),
        )
      ),
    );
  }
}
