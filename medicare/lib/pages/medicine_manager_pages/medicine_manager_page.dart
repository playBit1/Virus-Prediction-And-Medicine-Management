import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:medicare/database/authenticate.dart';
import 'package:medicare/database/medication.dart';
import 'package:medicare/pages/virus_predictor_pages/virus_predictor_home_page.dart';
import 'package:medicare/widgets/user_dialog_widget.dart';
import 'package:medicare/pages/medicine_manager_pages/add_update_medicine_page.dart';
import 'package:medicare/widgets/view_medication_widget.dart';

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
  final TextEditingController _userName = TextEditingController();
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _getMedication();
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
      currentIndex: currentIndex,
      onTap: (value) {
        if (value != currentIndex) {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: ((context, animation, secondaryAnimation) =>
                  const VirusHomePage()),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        }
      },
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

  Widget _topDesign() {
    return Container(
      alignment: Alignment.bottomLeft,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xff1B4965),
          Color(0xff62B6CB),
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Stack(
        children: [
          Positioned(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.only(left: 20, bottom: 2),
              alignment: Alignment.bottomLeft,
              child: Text(
                'Hey, $userName!',
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Container(
              alignment: Alignment.topRight,
              padding: const EdgeInsets.only(top: 20, right: 25),
              child: Transform.scale(
                scale: 2,
                child: IconButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: ((BuildContext context) => userDialogBox(
                          context,
                          _userName,
                          _medicationDataStream,
                        )),
                  ),
                  icon: Image.asset('assets/icons/logo.png'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroud() {
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
                  if (medicationList.isEmpty)
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 150, left: 25),
                          child: Image.asset(
                            'assets/icons/pills-bottle.png',
                            height: 200,
                            opacity: const AlwaysStoppedAnimation(.5),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 200),
                          child: Text(
                            'No Medication Avaiable',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.black.withOpacity(0.5)),
                          ),
                        )
                      ],
                    ),
                  for (int i = 0; i < medicationList.length; i++)
                    displayMedication(
                      context,
                      medicationList[i],
                      rootRef,
                      uid,
                    ),
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
      body: _backgroud(),
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
