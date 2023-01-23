// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:medicare/database/authenticate.dart';
import 'package:medicare/pages/log_sign_in_pages/create_account_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Authenticate().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {});
      switch (e.code) {
        case "invalid-email":
          errorMessage = "Invalid Email";
          break;
        case "user-not-found":
          errorMessage = "Email is Incorrect";
          break;
        case "wrong-password":
          errorMessage = "Incorrect Password";
          break;
        case "unknown":
          errorMessage = "Please enter your Email and Password";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
          print(e.code);
      }
    }
  }

  Future<void> createAccWithEmailAndPassword() async {
    try {
      await Authenticate().createAccWithEmailAndPassword(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {});
      switch (e.code) {
        case "invalid-email":
          errorMessage = "Invalid Email";
          break;
        case "weak-password":
          errorMessage = "Weak Password";
          break;
        case "unknown":
          errorMessage = "Please enter your Username, Email and Password";
          break;
        case "email-already-in-use":
          errorMessage = "Email is already in use";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = 'Error';
      }
    }
  }

  Widget _errorMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(errorMessage == '' ? '' : 'Error: $errorMessage',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
    );
  }

  Widget _title() {
    return Container(
      padding: EdgeInsets.all(2),
      child: Text(
        "Hello",
        style: TextStyle(
            //fontFamily: 'Cabin',
            fontWeight: FontWeight.w500,
            fontSize: 64,
            color: Color.fromARGB(255, 15, 15, 15)),
      ),
    );
  }

  Widget _createTitle() {
    return Container(
      padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: const Text(
        "Create Account",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Cabin',
            fontWeight: FontWeight.w500,
            fontSize: 50,
            color: Color.fromARGB(255, 15, 15, 15)),
      ),
    );
  }

//The below code is written for the Sign up to your account mini title
  Widget _minititle() {
    return Container(
      padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
      child: Text(
        "Login to your Account",
        style: TextStyle(
            //fontFamily: 'Cabin',
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Color.fromARGB(255, 15, 15, 15)),
      ),
    );
  }

  Widget _usernamebox() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 10, 20, 0),
      child: TextField(
        controller: _nameController,
        maxLength: 9,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: const EdgeInsets.all(16),
          labelText: "User Name",
          hintText: "Enter Username (1 - 9)",
          prefixIcon:
              const Icon(Icons.person, color: Color.fromRGBO(51, 83, 115, 10)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }

  Widget _loginTextBox(
    TextEditingController controller,
    bool isEmail,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 10, 20, 0),
      child: TextField(
        controller: controller,
        obscureText: isEmail ? false : true,
        maxLength: isEmail ? 256 : 127,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
          counterText: '',
          labelText: isEmail ? "Email" : "Password",
          hintText: isEmail ? "Enter Email" : "Enter Password",
          prefixIcon: isEmail
              ? Icon(
                  Icons.email_rounded,
                  color: Color.fromRGBO(51, 83, 115, 10),
                )
              : Icon(
                  Icons.lock,
                  color: Color.fromRGBO(51, 83, 115, 10),
                ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
    );
  }

// The below code is used for the create account linking that will redirect to another page
  Widget _createLink() {
    return Container(
      margin: EdgeInsets.fromLTRB(50, 10, 50, 0), //This is to keep spacing
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
                text: "Don't Have an Account? ",
                style: TextStyle(
                  //fontFamily: 'Cabin',
                  fontStyle: FontStyle.italic,
                )),
            TextSpan(
              text: 'Create',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = (() {
                  setState(() {
                    isLogin = false;
                    errorMessage = '';
                  });
                }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
    return InkWell(
      onTap: signInWithEmailAndPassword,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(top: 120)),
          Text(
            'Login',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          IconButton(
            onPressed: signInWithEmailAndPassword,
            icon: Image.asset(
              'assets/icons/loginbutton.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget _createlink() {
    return Container(
      margin:
          const EdgeInsets.fromLTRB(50, 10, 50, 0), //This is to keep spacing
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 18.0,
            color: Colors.black,
          ),
          children: <TextSpan>[
            const TextSpan(
              text: "Already Have an Account? ",
              style: TextStyle(
                fontFamily: 'Cabin',
                fontStyle: FontStyle.italic,
              ),
            ),
            TextSpan(
              text: 'Login',
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = (() {
                  setState(() {
                    isLogin = true;
                    errorMessage = '';
                  });
                }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createAccButton() {
    return InkWell(
      onTap: createAccWithEmailAndPassword,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(padding: EdgeInsets.only(top: 120)),
          const Text(
            'Sign Up',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          IconButton(
            onPressed: createAccWithEmailAndPassword,
            icon: Image.asset(
              'assets/icons/loginbutton.png',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/icons/background.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: isLogin
              ? <Widget>[
                  _title(),
                  _minititle(),
                  SizedBox(
                    height: 10,
                  ),
                  _loginTextBox(_emailController, true),
                  _loginTextBox(_passwordController, false),
                  _errorMessage(),
                  _createLink(),
                  _loginButton()
                ]
              : <Widget>[
                  _createTitle(),
                  _usernamebox(),
                  _loginTextBox(_emailController, true),
                  _loginTextBox(_passwordController, false),
                  _errorMessage(),
                  _createlink(),
                  _createAccButton(),
                ],
        ),
      ),
    );
  }
}
