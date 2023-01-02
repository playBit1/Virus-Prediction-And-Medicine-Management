import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medicare/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:medicare/pages/medicine_manager_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final User? user = Authenticate().currentUser;

  Future<void> signOut() async {
    await Authenticate().signOut();
  }

  Widget _title() {
    return const Text('Firebase Auth');
  }

  Widget _userUid() {
    return Text(user?.email ?? 'User email');
  }

  Widget _goToMeds(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MedsPage(),
          ),
        );
      },
      child: const Text('Display Meds!'),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _goToMeds(context),
            _userUid(),
            _signOutButton(),
          ],
        ),
      ),
    );
  }
}
