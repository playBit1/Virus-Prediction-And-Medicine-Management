import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medicare/authenticate.dart';
import 'package:medicare/medication.dart';
import 'package:medicare/pages/add_update_medicine_page.dart';

class MedsPage extends StatefulWidget {
  const MedsPage({super.key});

  @override
  State<MedsPage> createState() => _MedsPageState();
}

class _MedsPageState extends State<MedsPage> {
  final uid = Authenticate().getUid();
  final rootRef = FirebaseDatabase.instance.ref();
  final String? userName = Authenticate().getCurrentUserName();
  late StreamSubscription _medicationDataStream;
  List<Medication> medicationList = [];
  List<String> medicationTimeList = [];
  TextEditingController _userName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getMedication();
  }

  Future<void> _signOut() async {
    _medicationDataStream.cancel();
    await Authenticate().signOut().then(
          (value) => {
            Navigator.popUntil(
              context,
              ModalRoute.withName("/"),
            ),
          },
        );
  }

  void _getMedication() {
    _medicationDataStream =
        rootRef.child('$uid/medication').onChildAdded.listen((data) {
      MedicationData medicationData =
          MedicationData.fromJson(data.snapshot.value as Map);

      Medication medication =
          Medication(key: data.snapshot.key, medicationData: medicationData);

      medicationList.add(medication);

      setState(() {});
    });
  }

  Widget _navbar() {
    return BottomNavigationBar(
      currentIndex: 1,
      items: const [
        BottomNavigationBarItem(
          label: 'Virus Predictor',
          icon: Icon(Icons.coronavirus),
        ),
        BottomNavigationBarItem(
          label: 'Medicine Manager',
          icon: Icon(Icons.medication),
        ),
      ],
    );
  }

  Widget _goToAddMedicationPage() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AddMedicine(),
          ),
        );
      },
    );
  }

  Widget _goToUpdateMedicationPage(Medication medication) {
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
    Medication delMedication,
  ) {
    return IconButton(
      onPressed: (() => showDialog(
            context: context,
            builder: ((BuildContext context) =>
                _deleteMedication(delMedication)),
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

  Widget _deleteMedication(
    Medication medication,
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

  Widget _changeUserName() {
    return Dialog(
      child: SizedBox(
        width: 220,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            const Text('Change Name'),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _userName,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 75),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Authenticate().updateUserName(_userName.text);
                      Navigator.pop(context);
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _userDialogBox() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))),
        alignment: Alignment.topRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              ),
            ),
            const SizedBox(
              width: 270,
              child: Divider(
                thickness: 1,
                color: Colors.black,
              ),
            ),
            TextButton(
              onPressed: () {
                //Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: ((BuildContext context) => _changeUserName()),
                );
              },
              child: const Text('Change Name'),
            ),
            const SizedBox(
              width: 270,
              child: Divider(
                thickness: 1,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: TextButton(
                onPressed: () {
                  _signOut();
                },
                child: const Text(
                  'Sign Out',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _displayMedication(
    BuildContext context,
    String imageId,
    Medication medication,
  ) {
    String name = medication.medicationData!.name!;
    String dailyIntake = medication.medicationData!.dailyIntake!;
    String beforeOrAfterMeal = medication.medicationData!.beforeOrAfterMeal!;
    String totalQty = medication.medicationData!.totalQty!;
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
                'assets/icons/pill_types/$imageId.png',
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
                        child: Text(
                          '$dailyIntake pill $beforeOrAfterMeal meal',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              _goToUpdateMedicationPage(medication),
              _goToDeleteMedicationPage(medication),
            ],
          ),
          const Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }

  Widget _topDesign() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xff1B4965),
          Color(0xff62B6CB),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 60),
            child: Text(
              'Hey, $userName!',
              style: const TextStyle(
                fontSize: 45,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Transform.scale(
                  scale: 1.5,
                  child: IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: ((BuildContext context) => _userDialogBox()),
                    ),
                    icon: Image.asset('assets/icons/user.png'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroud(
    String name,
  ) {
    return Stack(
      children: [
        Positioned(
          height: 180,
          width: MediaQuery.of(context).size.width,
          child: _topDesign(),
        ),
        Positioned.fill(
          top: 150,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Color.fromRGBO(254, 254, 253, 1),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (int i = 0; i < medicationList.length; i++)
                    _displayMedication(context, 'pill1', medicationList[i])
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _backgroud('Binul'),
      floatingActionButton: _goToAddMedicationPage(),
      bottomNavigationBar: _navbar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  void deactivate() {
    _medicationDataStream.cancel();
    super.deactivate();
  }
}
