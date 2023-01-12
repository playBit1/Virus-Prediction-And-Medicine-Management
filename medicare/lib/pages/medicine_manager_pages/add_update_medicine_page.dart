import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medicare/database/authenticate.dart';
import 'package:medicare/database/medication.dart';

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

  // ignore: prefer_final_fields
  String? _beforeOrAfterMealFirstValue = 'Before Meal';
  // ignore: prefer_final_fields
  String? _displayPillFirstValue = 'Tablet';

  final List<String> _beforeOrAfterMealOptions = <String>[
    'Before Meal',
    'After Meal'
  ];
  final List<String> _displayPillOptions = <String>[
    'Tablet',
    'Capsule',
    'Bottle',
  ];

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerDailyIntake = TextEditingController();
  final TextEditingController _controllerBeforeOrAfterMeal =
      TextEditingController();
  final TextEditingController _controllerTotalQty = TextEditingController();
  final TextEditingController _controllerIntakeTime = TextEditingController();
  final TextEditingController _controllerImageName = TextEditingController();

  String errorMessage = '';

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
      _controllerImageName.text = widget.medication!.medicationData!.imageName!;
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
        if (_controllerName.text.isEmpty ||
            _controllerDailyIntake.text.isEmpty ||
            _controllerTotalQty.text.isEmpty ||
            _controllerIntakeTime.text.isEmpty) {
          setState(() {
            errorMessage = "Please Enter Values For Every Field";
          });
        } else {
          Map<String, dynamic> data = {
            'name': _controllerName.text.toString(),
            'dailyIntake': _controllerDailyIntake.text.toString(),
            'beforeOrAfterMeal': _controllerBeforeOrAfterMeal.text.toString(),
            'totalQty': _controllerTotalQty.text.toString(),
            'intakeTime': _controllerIntakeTime.text.toString(),
            'imageName': _controllerImageName.text.toString()
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
        }
      },
      child: Text(widget.isAdd ? 'Add Medication' : 'Update Medication'),
    );
  }

  Widget _formFields(
    bool isTextField,
    TextEditingController controller,
    String imageName,
    String message, [
    bool isAmount = false,
    bool isTime = false,
    List<String> dropOptions = const [],
    String? firstOption,
  ]) {
    return Container(
      width: 300,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/field_images/$imageName.png',
              height: 30,
              width: 30,
            ),
            const VerticalDivider(
              color: Colors.black87,
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(
              width: 230,
              child: isTextField
                  ? _entryField(
                      message,
                      controller,
                      isAmount,
                    )
                  : isTime
                      ? _timeField(
                          message,
                          controller,
                        )
                      : _dropDownFields(
                          dropOptions,
                          firstOption,
                          controller,
                          imageName,
                          message,
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeField(
    String title,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        //counterText: '',
      ),
      readOnly: true,
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
            initialTime: TimeOfDay.now(), context: context);

        if (pickedTime != null) {
          // ignore: use_build_context_synchronously
          controller.text = pickedTime.format(context).toString();
        }
      },
    );
  }

  Widget _entryField(
    String title,
    TextEditingController controller,
    bool isAmount,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: title,
        counterText: '',
      ),
      keyboardType: isAmount ? TextInputType.number : TextInputType.text,
      maxLength: isAmount ? 4 : 25,
    );
  }

  Widget _dropDownFields(
    List<String> dropOptions,
    String? firstOption,
    TextEditingController controller,
    String imageName,
    String message,
  ) {
    widget.isAdd ? '' : firstOption = controller.text;
    controller.text == '' ? controller.text = firstOption! : '';

    return DropdownButtonHideUnderline(
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(labelText: message),
        value: firstOption,
        items: dropOptions.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: ((value) => setState(
              (() {
                firstOption = value;
                controller.text = value!;
              }),
            )),
      ),
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
                    Text(_controllerImageName.text),
                    Text(errorMessage),
                    _formFields(
                      true,
                      _controllerName,
                      'nameDisplay',
                      'Medication Name',
                    ),
                    const SizedBox(height: 10),
                    _formFields(
                      false,
                      _controllerImageName,
                      'imageDisplay',
                      'Pill Type',
                      false,
                      false,
                      _displayPillOptions,
                      _displayPillFirstValue,
                    ),
                    const SizedBox(height: 10),
                    _formFields(
                      true,
                      _controllerDailyIntake,
                      'intakeDisplay',
                      'Daily Intake',
                      true,
                    ),
                    const SizedBox(height: 10),
                    _formFields(
                      true,
                      _controllerTotalQty,
                      'qtyDisplay',
                      'Total Pill Amount',
                      true,
                    ),
                    const SizedBox(height: 10),
                    _formFields(
                      false,
                      _controllerBeforeOrAfterMeal,
                      'whenDisplay',
                      'When to Take',
                      false,
                      false,
                      _beforeOrAfterMealOptions,
                      _beforeOrAfterMealFirstValue,
                    ),
                    const SizedBox(height: 10),
                    _formFields(
                      false,
                      _controllerIntakeTime,
                      'timeDisplay',
                      'Intake Time',
                      false,
                      true,
                    ),
                    const SizedBox(height: 30),
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
