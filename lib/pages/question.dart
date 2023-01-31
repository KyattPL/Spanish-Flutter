import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Question extends StatefulWidget {
  const Question({Key? key}) : super(key: key);

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {

  Map tests = {};
  TextEditingController inputController = TextEditingController();

  void readJson() async {
    String data = await rootBundle.loadString('assets/tests_json.json');
    final decoded = await json.decode(data);
    setState(() {
      tests = decoded;
    });
  }

  @override
  void initState() {
    super.initState();
    readJson();
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  bool isCorrectAnswer(dynamic questionObj, String shownLang) {
    if (shownLang == 'eng' && questionObj['esp'].toLowerCase() == inputController.text.toLowerCase()) {
      return true;
    } else if (shownLang == 'esp' && questionObj['eng'].toLowerCase() == inputController.text.toLowerCase()) {
      return true;
    } else {
      return false;
    }
  }



  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    String testName = arguments['testName'];
    String whichToShow = arguments['option'] == 1 ? 'eng' : 'esp';
    int questionNo = arguments['questionNo'];
    int score = arguments['score'];
    List wrong = arguments['wrong'];

    List testData = tests.isNotEmpty ? tests[testName]["data"] : [];

    void submitAnswer() {
      bool isCorrect = isCorrectAnswer(testData[questionNo - 1], whichToShow);
      isCorrect ? null : wrong.add(testData[questionNo - 1]);
      int scoreIncrement = isCorrect ? 1 : 0;
      if (questionNo == testData.length) {
        Navigator.pushReplacementNamed(context, '/results', arguments: {
          'testName': testName,
          'score': score + scoreIncrement,
          'maxScore': testData.length,
          'wrong': wrong
        });
      } else {
        Navigator.pushReplacementNamed(context, '/question', arguments: {
          'option': arguments['option'],
          'testName': testName,
          'score': score + scoreIncrement,
          'questionNo': questionNo + 1,
          'wrong': wrong
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spanish-Flutter'),
        centerTitle: true,
        backgroundColor: Colors.brown[800],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: Colors.brown[900],
        child: tests.isNotEmpty ? Column(
          children: [
            Text('${testData[questionNo - 1][whichToShow]}', style: TextStyle(
              color: Colors.brown[200],
              fontSize: 24
            )),
            TextField(
              autofocus: true,
              controller: inputController,
              cursorColor: Colors.brown[400],
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.brown[500] as Color)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.brown[400] as Color))
              ),
              textInputAction: TextInputAction.go,
              onSubmitted: (String _) => submitAnswer(),
              style: TextStyle(color: Colors.brown[200], fontSize: 24),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20.0),
              child: TextButton(onPressed: submitAnswer,
                  style: TextButton.styleFrom(
                    minimumSize: const Size(160, 40),
                    foregroundColor: Colors.brown[200],
                    backgroundColor: Colors.brown[400],
                    textStyle: const TextStyle(fontSize: 24)
                  ), child: const Text('Next')),
            )
          ],
        ) : Container(),
      ),
    );
  }
}
