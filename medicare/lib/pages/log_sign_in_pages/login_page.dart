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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Authenticate().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        errorMessage = e.message;
      });
    }
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Error: $errorMessage');
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

  Widget _loginTextBox(
    TextEditingController controller,
    bool isEmail,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 10, 20, 0),
      child: TextField(
        controller: controller,
        obscureText: isEmail ? false : true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => Createacc()),
                    ),
                  );
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
          children: <Widget>[
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
          ],
        ),
      ),
    );
  }
}
