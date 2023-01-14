import 'package:flutter/material.dart';
import 'package:medicare/pages/virus_predictor_pages/virus_results_page.dart';
import 'package:medicare/rest_api/api_service.dart';

class MonkeyQuestionare extends StatefulWidget {
  const MonkeyQuestionare({super.key});

  @override
  State<MonkeyQuestionare> createState() => _MonkeyQuestionareState();
}

class _MonkeyQuestionareState extends State<MonkeyQuestionare> {
  double progressValue = 0;
  String currentQuestion = 'illness';
  bool isEnd = false;

  List<List> monkeyIllnessList = [
    ['Continued High Fever', false],
    ['Swollen Lymph Nodes', false],
    ['Muscle Aches And Pain', false],
  ];

  List<List> monkeySymptomList = [
    ['Rectal Pain', false],
    ['Penile Oedema', false],
    ['Oral Lesions', false],
    ['Solitary Lesions', false],
    ['Swollen Tonsils', false],
    ['HIV Infection', false],
    ['Sexually Transmitted Infection', false],
  ];

  List<List> monkeySliderList = [
    ['sore throat', 0],
  ];

  List monkeyCompletedQuestionList = [];

  void packageMonkeyQuestions() {
    List illnessValue = [0];

    if (monkeyIllnessList[0][1]) {
      illnessValue = [1];
    }
    if (monkeyIllnessList[1][1]) {
      illnessValue = [2];
    }
    if (monkeyIllnessList[2][1]) {
      illnessValue = [3];
    }

    monkeyCompletedQuestionList = [
      illnessValue,
      monkeySymptomList[0][1],
      monkeySliderList[0][1].round(),
      monkeySymptomList[1][1],
      monkeySymptomList[2][1],
      monkeySymptomList[3][1],
      monkeySymptomList[4][1],
      monkeySymptomList[5][1],
      monkeySymptomList[6][1],
    ];
  }

  Widget _sliderQuestions() {
    return Container(
      padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Column(
        children: [
          const Text(
            'If Present, On A Scale Of 1 To 10 How Severe Is Your Condition',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 15,
          ),
          for (int i = 0; i < monkeySliderList.length; i++)
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(bottom: 5, left: 10),
                    child: Text(
                      monkeySliderList[i][0],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  SliderTheme(
                    data:
                        const SliderThemeData(valueIndicatorColor: Colors.cyan),
                    child: Slider(
                      value: monkeySliderList[i][1].toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: monkeySliderList[i][1].round().toString(),
                      onChanged: ((value) {
                        setState(() {
                          monkeySliderList[i][1] = value;
                        });
                      }),
                    ),
                  )
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _boolQuestions(bool isSymptom) {
    String question = isSymptom
        ? 'Select All Your Current Health Conditions'
        : 'Select all The Symptoms You Experienced Recently';

    List tempList = isSymptom ? monkeyIllnessList : monkeySymptomList;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
          child: Text(
            question,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Container(
          padding: const EdgeInsets.only(left: 15.5, right: 15.5),
          child: Wrap(
            spacing: 15,
            runSpacing: 20,
            children: [
              for (int i = 0; i < tempList.length; i++)
                InkWell(
                  onTap: () {
                    tempList[i][1]
                        ? tempList[i][1] = false
                        : tempList[i][1] = true;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: tempList[i][1]
                          ? const Color.fromARGB(255, 3, 133, 151)
                          : Colors.cyan,
                    ),
                    child: Text(
                      tempList[i][0],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
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
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(
                  height: 80,
                ),
                const Text(
                  'Virus Predictor',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 60, right: 60),
                  child: LinearProgressIndicator(
                    value: progressValue,
                    minHeight: 8,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroud() {
    double currentWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
          height: 250,
          width: currentWidth,
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
            child: Stack(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                if (currentQuestion == 'illness')
                  Positioned(
                    child: Visibility(
                      visible: true,
                      child: _boolQuestions(true),
                    ),
                  ),
                if (currentQuestion == 'symptom')
                  Positioned(
                    child: Visibility(
                      visible: true,
                      child: _boolQuestions(false),
                    ),
                  ),
                if (currentQuestion == 'slider')
                  Positioned(
                    child: Visibility(
                      visible: true,
                      child: _sliderQuestions(),
                    ),
                  ),
                Container(
                  alignment: Alignment.bottomRight,
                  padding: const EdgeInsets.only(bottom: 35, right: 30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(120, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (currentQuestion == 'illness') {
                        currentQuestion = 'symptom';
                      } else if (currentQuestion == 'symptom') {
                        currentQuestion = 'slider';
                        isEnd = true;
                      } else {
                        packageMonkeyQuestions();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ResultsPage(
                              isCovid: false,
                              userData: monkeyCompletedQuestionList,
                            ),
                          ),
                        );
                      }
                      progressValue += 0.35;
                      setState(() {});
                    },
                    child: Text(
                      isEnd ? 'Finish' : 'Next',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
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
