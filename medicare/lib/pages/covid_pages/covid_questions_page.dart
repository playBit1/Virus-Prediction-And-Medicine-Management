import 'package:flutter/material.dart';

class CovidQuestionare extends StatefulWidget {
  const CovidQuestionare({super.key});

  @override
  State<CovidQuestionare> createState() => _CovidQuestionareState();
}

class _CovidQuestionareState extends State<CovidQuestionare> {
  double progressValue = 0;
  String currentQuestion = 'simple';
  bool conditionQuestionsOver = false;
  bool travelQuestionsOver = false;
  bool pageTwoOver = false;
  List<List> covidScaleQuestionList1 = [
    ['Breathing Problems', 0],
    ['Fever', 0],
    ['Dry Cough', 0],
    ['Sore Throat', 0],
  ];

  List<List> covidScaleQuestionList2 = [
    ['Running Nose', 0],
    ['Headache', 0],
    ['Fatigue', 0],
  ];

  List<List> simpleCovidBoolQuestions = [
    ['Asthma', false],
    ['Heart Diseases', false],
    ['Diabetes', false],
    ['Hypertension', false],
    ['Gastrointestinal Diseases', false],
    ['Chronic Lung Diseases', false],
  ];

  List<List> simpleCovidBoolQuestionsCompleted = [];

  List advCovidBoolQuestions = [
    ['Traveled Abroad', false],
    ['Wore A Mask In Public Spaces', false],
    ['Attend Large Gatherings', false],
    ['Visited Public Places', false],
    ['Have Family Members Working In Public Places', false],
    ['Used Sanitization', false],
    ['Contact With A Covid Patient', false],
  ];

  Widget _sliderQuestions(bool isFirstList) {
    List tempList =
        isFirstList ? covidScaleQuestionList1 : covidScaleQuestionList2;
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
          for (int i = 0; i < tempList.length; i++)
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(bottom: 5, left: 10),
                    child: Text(
                      tempList[i][0],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  SliderTheme(
                    data:
                        const SliderThemeData(valueIndicatorColor: Colors.cyan),
                    child: Slider(
                      value: tempList[i][1].toDouble(),
                      min: 0,
                      max: 10,
                      divisions: 10,
                      label: tempList[i][1].round().toString(),
                      onChanged: ((value) {
                        setState(() {
                          tempList[i][1] = value;
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

  Widget _boolQuestions(bool isCondition) {
    String question = isCondition
        ? 'Select All Your Currently Diagnosed Health Conditions'
        : 'Select all The Choices You Experienced Recently';

    List tempList =
        isCondition ? simpleCovidBoolQuestions : advCovidBoolQuestions;

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
                if (currentQuestion == 'simple')
                  Positioned(
                    child: Visibility(
                      visible: true,
                      child: _boolQuestions(true),
                    ),
                  ),
                if (currentQuestion == 'advanced')
                  Positioned(
                    child: Visibility(
                      visible: true,
                      child: _boolQuestions(false),
                    ),
                  ),
                if (currentQuestion == 'slider1')
                  Positioned(
                    child: Visibility(
                      visible: true,
                      child: _sliderQuestions(true),
                    ),
                  ),
                if (currentQuestion == 'slider2')
                  Positioned(
                    child: Visibility(
                      visible: true,
                      child: _sliderQuestions(false),
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
                      if (currentQuestion == 'simple') {
                        currentQuestion = 'advanced';
                      } else if (currentQuestion == 'advanced') {
                        currentQuestion = 'slider1';
                      } else {
                        currentQuestion = 'slider2';
                      }
                      progressValue += 0.335;
                      setState(() {});
                    },
                    child: const Text(
                      'Next',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
