import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipez/Shared/model/app_color.dart';
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
                    pause: const Duration(milliseconds: 1000),
                    repeatForever: true,
                  ),
                ),
              ),
            ),

            Image.asset('assets/Logo.png'),



            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    "Iniciar Sesión",
                    style:  TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: AppColor.morado_3_53c,
                    ),
                  ),
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
                child: TextButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Terms and Conditions'),
                      content: Container(
                        height: 300,
                        child: const SingleChildScrollView(
                          child: Text(
                            'Bienvenido a nuestra aplicación de compartir recetas (en adelante, Recipez). Al acceder y utilizar Recipez, aceptas los siguientes términos y condiciones (en adelante, los "Términos"). Si no estás de acuerdo con estos Términos, por favor no utilices Recipez.\n\n'
                            '1. Propiedad intelectual\n\n'
                            'Todo el contenido publicado en Recipez, incluyendo pero no limitado a textos, imágenes, fotografías, gráficos, iconos y software (en adelante, el "Contenido"), es propiedad de los usuarios que lo han publicado o que cuentan con la autorización necesaria para hacerlo. Al utilizar la Aplicación, te comprometes a no utilizar el Contenido de manera ilegal o sin la debida autorización.\n\n'
                            '2. Uso permitido del Contenido\n\n'
                            'Estás autorizado a ver y utilizar el Contenido únicamente para tu uso personal y no comercial. No estás autorizado a modificar, distribuir, transmitir, reutilizar, reeditar, publicar o utilizar el Contenido de ninguna manera sin la debida autorización por escrito de nosotros o del propietario del Contenido.\n\n'
                            '3. Responsabilidad del Contenido\n\n'
                            'Los usuarios son responsables de asegurarse de que el Contenido que publiquen sea legal y no infrinja derechos de autor o marcas registradas. Nosotros no asumimos ninguna responsabilidad por el Contenido publicado por los usuarios en la Aplicación.\n\n'
                            '4. Terminación de la cuenta\n\n'
                            'Nos reservamos el derecho de terminar la cuenta de cualquier usuario en cualquier momento y sin previo aviso si consideramos que el usuario ha violado estos Términos o ha utilizado la Aplicación de manera inapropiada.\n\n'
                            '5. Cambios a los Términos\n\n'
                            'Nos reservamos el derecho de modificar estos Términos en cualquier momento y sin previo aviso. Los cambios entrarán en vigor inmediatamente después de su publicación en la Aplicación. Al utilizar la Aplicación después de la publicación de cualquier cambio, aceptas estar sujeto a los Términos modificados.'
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'OK'),
                          child: const Text("OK")
                        )
                      ],
                    )
                  ),
                  child: const Text("By logging in, you accept the terms and conditions."),
                )
            ),
          ],
        ),
      ),
    );
  }

}
