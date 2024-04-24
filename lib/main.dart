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
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;
  Widget currentPage = SignUpPage();
  AuthClass authClass = AuthClass();
  void initState() {
    super.initState();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    if (token != null) {
      currentPage = HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}
