import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:medicare/database/authenticate.dart';
import 'package:medicare/pages/log_sign_in_pages/login_page.dart';

class Createacc extends StatefulWidget {
  const Createacc({super.key});

  @override
  State<Createacc> createState() => CreateaccState();
}

class CreateaccState extends State<Createacc> {
  String? errorMessage = '';
  bool isDone = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

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
          style:
              const TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
    );
  }

  Widget title() {
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

  Widget _emailAndPasswordTextBox(
    TextEditingController controller,
    bool isEmail,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 10, 20, 0),
      child: TextField(
        controller: controller,
        obscureText: isEmail ? false : true,
        maxLength: isEmail ? 256 : 127,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          counterText: '',
          labelText: isEmail ? "Email" : "Password",
          hintText: isEmail ? "Enter Email" : "Enter Password",
          prefixIcon: isEmail
              ? const Icon(
                  Icons.email_rounded,
                  color: Color.fromRGBO(51, 83, 115, 10),
                )
              : const Icon(
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

// this is used to the username textflied the below code i mean
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

// The below code is used for the create account linking that will redirect to another page
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
                  Navigator.pop(context);
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
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/icons/background.png'),
                fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            title(),
            _usernamebox(),
            _emailAndPasswordTextBox(_emailController, true),
            _emailAndPasswordTextBox(_passwordController, false),
            _errorMessage(),
            _createlink(),
            _createAccButton(),
          ],
        ),
      ),
    );
  }
}
