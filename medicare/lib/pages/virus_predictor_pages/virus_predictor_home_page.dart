import 'package:flutter/material.dart';
import 'package:medicare/pages/medicine_manager_pages/medicine_manager_page.dart';
import 'package:medicare/pages/virus_predictor_pages/covid_questions_page.dart';
import 'package:medicare/pages/virus_predictor_pages/monkeyp_questions_page.dart';
import 'package:medicare/widgets/user_dialog_widget.dart';

class VirusHomePage extends StatefulWidget {
  const VirusHomePage({super.key});

  @override
  State<VirusHomePage> createState() => _VirusHomePageState();
}

class _VirusHomePageState extends State<VirusHomePage> {
  int currentIndex = 0;
  final TextEditingController _userName = TextEditingController();

  Widget _designerButton(
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
                  builder: (_) => const MonkeyQuestionare(),
                ));
      }),
      style: ElevatedButton.styleFrom(
        fixedSize: const Size(300, 180),
        backgroundColor:
            isCovid ? const Color(0xff62B6CB) : const Color(0xff30859A),
        elevation: 10,
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Image.asset(
            isCovid ? 'assets/icons/covid.png' : 'assets/icons/monkeypox.png',
            width: 130,
          )
        ],
      ),
    );
  }

  Widget _logo(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      padding: const EdgeInsets.only(right: 25, top: 20),
      child: IconButton(
        onPressed: () => showDialog(
          context: context,
          builder: ((BuildContext context) => userDialogBoxMenu(
                context,
                _userName,
              )),
        ),
        icon: Transform.scale(
          scale: 2,
          child: Image.asset(
            'assets/icons/logo.png',
            //alignment: Alignment.topRight,
            width: 100,
            height: 100,
          ),
        ),
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
          Positioned(child: _logo(context)),
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
                  'Choose you Predictor',
                  style: TextStyle(fontSize: 35),
                ),
                const SizedBox(height: 15),
                _designerButton(true),
                const SizedBox(height: 30),
                _designerButton(false),
              ],
            ),
          ),
        ),
      ],
    );
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
                  const MedsPage()),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _backgroud(),
      bottomNavigationBar: _navbar(),
    );
  }
}
