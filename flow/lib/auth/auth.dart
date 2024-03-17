import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/auth/logreg.dart';
import 'package:flow/pages/homepage.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder(
       stream:FirebaseAuth.instance.authStateChanges(),
       builder:(context,snapshot){
        if(snapshot.hasData)
        {
          return const HomePage();
        }
        else {
          return const LoginOrRegister();
        }
       } 
      )
    );
  }
}