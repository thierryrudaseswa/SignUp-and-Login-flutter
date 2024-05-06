import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:thirder/Service/Auth_Service.dart';
import 'package:thirder/pages/AddTodo.dart';
import 'package:thirder/pages/HomePage.dart';
import 'package:thirder/pages/SignInPage.dart';
import 'package:thirder/pages/SignUpPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final ValueNotifier<Color> themeNotifier = ValueNotifier<Color>(
      ThemeMode.light == ThemeMode.light ? Colors.white : Colors.black);
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  Widget currentPage = SignUpPage();
  AuthClass authClass = AuthClass();
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    if (token != null) {
      setState(() {
        currentPage = SignInPage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: MyApp.themeNotifier,
      builder: (_, Color currentColor, __) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.amber,
            // backgroundColor: currentColor,
            textTheme: TextTheme(
              bodyText1: TextStyle(color: currentColor),
              bodyText2: TextStyle(color: currentColor),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            backgroundColor: currentColor,
            textTheme: TextTheme(
              bodyText1: TextStyle(color: currentColor),
              bodyText2: TextStyle(color: currentColor),
            ),
          ),
          themeMode: ThemeMode.light, // Set the default theme mode to light
          home: currentPage,
        );
      },
    );
  }
}
