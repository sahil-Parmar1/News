import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news/main.dart';
import 'package:news/userselection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
class loginPage extends StatefulWidget
{
  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  void _signIn(User? user) async {
    if (user != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context)=>selectCountry())
      );
      
    }
  }
  void _signInAsGuest() async {
    // Implement guest login logic here (e.g., sign in anonymously)
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      _signIn(userCredential.user);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e"),backgroundColor: Colors.red,));
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInButton(
              Buttons.Google,
              onPressed: () async {
                User? user = await signInWithGoogle();
                _signIn(user);
              },
            ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signInAsGuest,
                child: Text('Continue as Guest'),
              ),
            ],
          ),
        ),
      ),
    );

  }
}


//signin with google


Future<User?> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

  if (googleUser != null) {
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    return userCredential.user;
  }
  return null;
}



