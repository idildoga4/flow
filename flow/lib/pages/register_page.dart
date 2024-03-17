import 'package:firebase_auth/firebase_auth.dart';
import 'package:flow/components/button.dart';
import 'package:flow/components/text_field.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key,required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
final emailTextController = TextEditingController();
final passwordTextController= TextEditingController();
final confirmPasswordTextController= TextEditingController();

void displayMessage(String message)
  {
    showDialog(
      context: context,
      builder: (context)=> AlertDialog(
        title: Text(message)
      )
    );
  }

void signUp() async
{
  showDialog(context: context,
  builder: (context)=> const Center(
  child: CircularProgressIndicator(),));
  if(passwordTextController.text != confirmPasswordTextController.text)
  {
    Navigator.pop(context);
    displayMessage("Passwords don't match");
    return;
  }
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailTextController.text,
      password: passwordTextController.text);
      if(context.mounted) Navigator.pop(context);
  } on FirebaseAuthException catch(e) {
    Navigator.pop(context);
    displayMessage(e.code);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                const SizedBox(height: 50,),
                const Icon(Icons.lock,
                size:100,
            
                ),
                const SizedBox(height:50),
               Text("Let's create an account for you",
               style: TextStyle(color:Colors.grey[700])),
                const SizedBox(height:25),

                MyTextField(
                controller: emailTextController,
                 hintText:'Email' , 
                 obscureText: false),
                 const SizedBox(height:25),

                 MyTextField(
                controller: passwordTextController,
                 hintText:'Password' , 
                 obscureText: true),
                 const SizedBox(height:10),

                MyTextField(
                controller: confirmPasswordTextController,
                 hintText:'Confirm Password' , 
                 obscureText: true),
                 const SizedBox(height:25),

                 MyButton(onTap: signUp, text: 'Sign Up'),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Text("Already have an account?",
                    style: TextStyle(color:Colors.grey[700])),
                    const SizedBox(width:4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text("Login now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:Colors.blue,
                      )),
                    )
                  ]
                  
                 )
              ]
            ),
          ),
        ),
      )
    );
    
  }
}
