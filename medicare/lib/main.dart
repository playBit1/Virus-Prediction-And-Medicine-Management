import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medicare/widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MediCare());
}

class MediCare extends StatelessWidget {
  const MediCare({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const WidgetTree(),
    );
  }
}
