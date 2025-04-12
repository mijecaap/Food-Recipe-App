import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:recipez/User/bloc/bloc_user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipez/User/ui/screens/sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  /*runApp(DevicePreview(
    enabled: true,
    tools: [
      ...DevicePreview.defaultTools,
    ],
    builder: (context) => const MyApp(),
  ));*/
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: UserBloc(),
      child: const MaterialApp(
        useInheritedMediaQuery: true,
        /*locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,*/
        title: 'Recipez',
        home: SignIn(),
      ),
    );
  }
}
