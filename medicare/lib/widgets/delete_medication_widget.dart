import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medicare/database/medication.dart';

Widget deleteMedication(
  BuildContext context,
  Medication medication,
  DatabaseReference rootRef,
  String? uid,
) {
  String name = medication.medicationData!.name!;
  String key = medication.key!;
  return AlertDialog(
    title: const Text('Delete Medication'),
    content: Text('Do you wish to delete $name?'),
    actions: [
      TextButton(
        onPressed: () {
          rootRef.child('$uid/medication/$key').remove();
          Navigator.pop(context, 'OK');
        },
        child: const Text('Yes'),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context, 'Cancel');
        },
        child: const Text('No'),
      ),
    ],
  );
}
