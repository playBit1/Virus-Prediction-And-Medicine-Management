import 'package:flutter/material.dart';
import 'package:medicare/pages/covid_pages/covid_questions_page.dart';

class VirusHomePage extends StatefulWidget {
  const VirusHomePage({super.key});

  @override
  State<VirusHomePage> createState() => _VirusHomePageState();
}

class _VirusHomePageState extends State<VirusHomePage> {
  Widget _DesignerButton(
    bool isCovid,
  ) {
    String name;
    isCovid ? name = 'Covid-19' : name = 'Monkey Pox';
    return ElevatedButton(
      onPressed: (() {
        isCovid
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CovidQuestionare(),
                ))
            : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CovidQuestionare(),
                ));
      }),
      style: ElevatedButton.styleFrom(fixedSize: const Size(250, 150)),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(name),
          const SizedBox(height: 10),
          Image.asset(
            'assets/icons/covid.png',
            width: 100,
          )
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
      child: Stack(
        children: [
          Positioned(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Container(
              //padding: const EdgeInsets.only(left: 20, bottom: 2),
              alignment: Alignment.bottomCenter,
              child: const Text(
                'Virus Predictor',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
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
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: _topDesign(),
        ),
        Positioned.fill(
          top: 220,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Color.fromRGBO(254, 254, 253, 1),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Select Virus",
                  style: TextStyle(fontSize: 35),
                ),
                const SizedBox(height: 30),
                _DesignerButton(false),
                const SizedBox(height: 50),
                _DesignerButton(true),
              ],
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
    );
  }
}
