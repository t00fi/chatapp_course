import 'package:chatapp_course/screens/auth_screen.dart';
import 'package:chatapp_course/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  //initialize firebase connection.
  final Future<FirebaseApp> fbInit = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'chat app',
      //***********THEME DATA************* */
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.pink,
          background: Colors.pink,
          secondary: Colors.deepPurple,
        ),
        //make all elevatedButton as:
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      //***************************** */
      home: CheckBackend(fbInit: fbInit),
    );
  }
}

class CheckBackend extends StatelessWidget {
  const CheckBackend({
    Key? key,
    required this.fbInit,
  }) : super(key: key);

  final Future<FirebaseApp> fbInit;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fbInit,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('${snapshot.error}');
          return const Text('Some Thing Went Wrong!');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return ChatScreen();
            }
            return const AuthScreen();
          },
        );
      },
    );
  }
}
