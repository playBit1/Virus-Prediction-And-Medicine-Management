import 'package:flutter/material.dart';
import 'package:medicare/rest_api/api_service.dart';

class ResultsPage extends StatefulWidget {
  final bool isCovid;
  final List userData;
  const ResultsPage({super.key, required this.isCovid, required this.userData});

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  Widget _backButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          padding: const EdgeInsets.only(left: 10, top: 20),
          onPressed: () => Navigator.pop(context),
          icon: Image.asset('assets/icons/backArrow.png'),
          iconSize: 50,
        ),
        IconButton(
          padding: const EdgeInsets.only(top: 10, right: 15),
          onPressed: (() {}),
          icon: Image.asset('assets/icons/logo.png'),
          iconSize: 75,
        ),
      ],
    );
  }

  Widget _safeorNotSafeImage(int prediction, String risk, String virusName) {
    String displayedVirus = '';
    widget.isCovid
        ? displayedVirus = 'COVID 19'
        : displayedVirus = 'Monkey Pox';
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 40),
          alignment: Alignment.center,
          child: Image.asset(
            prediction == 1
                ? 'assets/icons/notSafe.png'
                : 'assets/icons/safe.png',
            scale: 1.2,
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Text(
            prediction == 1
                ? 'You Have A Chance of\nContracting $displayedVirus!'
                : 'You are Safe from $displayedVirus',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: prediction == 1
                  ? const Color.fromARGB(255, 236, 166, 161)
                  : Colors.green,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            color: risk == 'High'
                ? Colors.red
                : risk == 'Medium'
                    ? Colors.yellow
                    : Colors.green,
          ),
          width: 200,
          alignment: Alignment.center,
          child: Text(
            risk == '' ? 'Safe' : risk,
            style: const TextStyle(fontSize: 30, color: Colors.black),
          ),
        ),
      ],
    );
  }

  Widget _showResults(int prediction, String risk, String virusName) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(246, 14, 59, 90),
            Color.fromARGB(246, 75, 130, 160)
          ],
        ),
      ),
      child: Stack(children: [
        _backButton(),
        _safeorNotSafeImage(prediction, risk, virusName),
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          alignment: Alignment.bottomCenter,
          child: const Text(
            '*Disclaimer this is not professional medical advice\nPlease Contact a Medical Professional for\nmore information',
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    String name = widget.isCovid ? 'covid' : 'monkeypox';
    return Scaffold(
      body: FutureBuilder(
        future: ApiService.postQuestions(name, widget.userData),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _showResults(
              snapshot.data['model_prediction'],
              snapshot.data['risk_probability'],
              name,
            );
          }
        },
      ),
    );
  }
}
