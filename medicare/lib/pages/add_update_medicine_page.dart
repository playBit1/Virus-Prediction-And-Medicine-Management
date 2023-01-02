import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medicare/authenticate.dart';
import 'package:medicare/medication.dart';

class AddMedicine extends StatefulWidget {
  final bool isAdd;
  final Medication? medication;
  const AddMedicine({super.key, this.isAdd = true, this.medication});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  final uid = Authenticate().getUid();
  final rootRef = FirebaseDatabase.instance.ref();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDailyIntake = TextEditingController();
  final TextEditingController _controllerBeforeOrAfterMeal =
      TextEditingController();
  final TextEditingController _controllerTotalQty = TextEditingController();
  final TextEditingController _controllerIntakeTime = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.isAdd) {
      _controllerName.text = widget.medication!.medicationData!.name!;
      _controllerDailyIntake.text =
          widget.medication!.medicationData!.dailyIntake!;
      _controllerBeforeOrAfterMeal.text =
          widget.medication!.medicationData!.beforeOrAfterMeal!;
      _controllerTotalQty.text = widget.medication!.medicationData!.totalQty!;
      _controllerIntakeTime.text =
          widget.medication!.medicationData!.intakeTime!;
    }
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
  ) {
    if (!widget.isAdd) {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
        ),
      );
    } else {
      return TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
        ),
      );
    }
  }

  Widget _backButton() {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: Image.asset('assets/icons/backArrow.png'),
      iconSize: 50,
    );
  }

  Widget _addButton() {
    return ElevatedButton(
      onPressed: () {
        Map<String, dynamic> data = {
          'name': _controllerName.text.toString(),
          'dailyIntake': _controllerDailyIntake.text.toString(),
          'beforeOrAfterMeal': _controllerBeforeOrAfterMeal.text.toString(),
          'totalQty': _controllerTotalQty.text.toString(),
          'intakeTime': _controllerIntakeTime.text.toString()
        };

        if (widget.isAdd) {
          rootRef.child('$uid/medication').push().set(data).then((value) {
            Navigator.of(context).pop();
          });
        } else {
          String key = widget.medication!.key!;
          rootRef.child('$uid/medication/$key').update(data).then((value) {
            Navigator.of(context).pop();
          });
        }
      },
      child: Text(widget.isAdd ? 'Add Medication' : 'Update Medication'),
    );
  }

  Widget _backgroud() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: Container(
              alignment: Alignment.bottomLeft,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
                  Color(0xff1B4965),
                  Color(0xff62B6CB),
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Image.asset('assets/icons/pillManager.png'),
              ),
            ),
          ),
          Positioned(
            top: 220,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _entryField('Name', _controllerName),
                    _entryField('Daily Intake', _controllerDailyIntake),
                    _entryField('How To Use', _controllerBeforeOrAfterMeal),
                    _entryField('Total Pill Amount', _controllerTotalQty),
                    _entryField('Intake Time', _controllerIntakeTime),
                    const SizedBox(height: 50),
                    _addButton(),
                  ],
                ),
              ),
            ),
          ),
          _backButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _backgroud(),
    );
  }
}
