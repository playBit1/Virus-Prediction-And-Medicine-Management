import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medicare/database/medication.dart';
import 'package:medicare/widgets/delete_medication_widget.dart';
import 'package:medicare/pages/medicine_manager_pages/add_update_medicine_page.dart';
import 'package:medicare/pages/medicine_manager_pages/medicine_manager_page.dart';

Widget displayMedication(
  BuildContext context,
  Medication medication,
  DatabaseReference rootRef,
  String? uid,
) {
  String name = medication.medicationData!.name!;
  int dailyIntake = int.parse(medication.medicationData!.dailyIntake!);
  String beforeOrAfterMeal = medication.medicationData!.beforeOrAfterMeal!;
  String totalQty = medication.medicationData!.totalQty!;
  String imageName = medication.medicationData!.imageName!;
  String intakeTime = medication.medicationData!.intakeTime!;
  return Padding(
    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          intakeTime,
          style: const TextStyle(fontSize: 20),
        ),
        const Divider(
          color: Colors.black,
        ),
        Row(
          children: [
            Image.asset(
              'assets/icons/pill_types/$imageName.png',
              height: 40,
              width: 60,
            ),
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 3),
                      child: Text(
                        name,
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: dailyIntake <= 1
                          ? Text(
                              '$dailyIntake Pill $beforeOrAfterMeal',
                              style: const TextStyle(fontSize: 15),
                            )
                          : Text(
                              '$dailyIntake Pills $beforeOrAfterMeal',
                              style: const TextStyle(fontSize: 15),
                            ),
                    ),
                  )
                ],
              ),
            ),
            _goToUpdateMedicationPage(context, medication),
            _goToDeleteMedicationPage(context, medication, rootRef, uid),
          ],
        ),
        const Divider(
          color: Colors.black,
        ),
      ],
    ),
  );
}

Widget _goToUpdateMedicationPage(BuildContext context, Medication medication) {
  return IconButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddMedicine(isAdd: false, medication: medication),
        ),
      ).then((value) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const MedsPage(),
          ),
        );
      });
    },
    icon: Image.asset('assets/icons/update.png'),
    iconSize: 20,
  );
}

Widget _goToDeleteMedicationPage(
  BuildContext context,
  Medication delMedication,
  DatabaseReference rootRef,
  String? uid,
) {
  return IconButton(
    onPressed: (() => showDialog(
          context: context,
          builder: ((BuildContext context) =>
              deleteMedication(context, delMedication, rootRef, uid)),
        ).then(
          (value) {
            if (value == 'OK') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const MedsPage(),
                ),
              );
            }
          },
        )),
    icon: Image.asset('assets/icons/delete.png'),
    iconSize: 40,
    color: Colors.white10,
  );
}
