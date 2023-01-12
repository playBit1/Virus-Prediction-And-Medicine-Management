import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicare/database/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:medicare/pages/medicine_manager_pages/medicine_manager_page.dart';
import 'package:medicare/pages/virus_predictor_pages/virus_predictor_home_page.dart';
import 'package:medicare/widgets/user_dialog_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Authenticate().currentUser;

  Widget _navButton(
    BuildContext context,
    double buttonWidth,
    double buttonHeight,
    bool isPredictor,
  ) {
    String buttonName = isPredictor ? 'VIRUS PREDICTOR' : 'PILL MANAGEMENT';
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 1,
        fixedSize: Size(buttonWidth, buttonHeight),
        foregroundColor: Colors.white,
        backgroundColor: isPredictor
            ? const Color.fromRGBO(32, 70, 109, 100)
            : const Color.fromARGB(156, 7, 24, 41),
        padding: const EdgeInsets.fromLTRB(60, 100, 60, 100),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30))),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                isPredictor ? const VirusHomePage() : const MedsPage(),
          ),
        );
      },
      child: Text(
        buttonName,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _logo(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.only(right: 20),
      child: IconButton(
        onPressed: () {},
        icon: Transform.scale(
          scale: 2,
          child: Image.asset(
            'assets/icons/logo.png',
            //alignment: Alignment.topRight,
            width: 100,
            height: 100,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width - 60;
    double buttonHeight = MediaQuery.of(context).size.height - 475;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Color.fromRGBO(97, 180, 201, 10),
              Color.fromRGBO(58, 104, 129, 10)
            ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _logo(context),
            _navButton(context, buttonWidth, buttonHeight, true),
            const SizedBox(),
            _navButton(context, buttonWidth, buttonHeight, false),
          ],
        ),
      ),
    );
  }
}
