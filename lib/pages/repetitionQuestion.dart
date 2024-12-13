import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class RepetitionQuestion extends StatefulWidget {
  const RepetitionQuestion({Key? key}) : super(key: key);

  @override
  State<RepetitionQuestion> createState() => _RepetitionQuestionState();
}

class _RepetitionQuestionState extends State<RepetitionQuestion> {

  // Map tests = {};
  TextEditingController inputController = TextEditingController();

  // Future<void> _loadOrCopyJson() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final filePath = '${directory.path}/tests_json.json';
  //   final file = File(filePath);
  //
  //   if (await file.exists()) {
  //     // Load the JSON file if it exists
  //     String jsonData = await file.readAsString();
  //     setState(() {
  //       tests = json.decode(jsonData);
  //     });
  //   } else {
  //     // Copy the JSON from assets to the writable directory if it doesn't exist
  //     String assetData = await rootBundle.loadString('assets/tests_json.json');
  //     await file.writeAsString(assetData);
  //     setState(() {
  //       tests = json.decode(assetData);
  //     });
  //   }
  // }

  Future<void> _updateRepetitionItems(bool isCorrect, int questionNo) async {
    if (isCorrect) {
      // Remove correctly answered item from repetition list
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/repetition_items.json');
      List<Map<String, dynamic>> repItems = List<Map<String, dynamic>>.from(json.decode(await file.readAsString()));
      repItems.removeAt(questionNo);
      await file.writeAsString(json.encode(repItems));
    }
  }

  @override
  void initState() {
    super.initState();
    // _loadOrCopyJson();
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
    String whichToShow = arguments['option'] == 1 ? 'eng' : 'esp';
    int questionNo = arguments['questionNo'];
    int score = arguments['score'];
    List wrong = arguments['wrong'];
    int answered = arguments['answered'];
    List questionsRemaining = arguments['questionsRemaining'];
    int maxQuestions = arguments['maxQuestions'];

    List tests = arguments['repetitionItems'];
    List testData = tests.isNotEmpty ? tests : [];

    void submitAnswer() {
      bool isCorrect = isCorrectAnswer(testData[questionNo], whichToShow);
      isCorrect ? null : wrong.add(testData[questionNo]);

      _updateRepetitionItems(isCorrect, questionNo);

      int scoreIncrement = isCorrect ? 1 : 0;
      answered += 1;

      if (answered == maxQuestions) {
        Navigator.pushReplacementNamed(context, '/repetitionResults', arguments: {
          'score': score + scoreIncrement,
          'maxScore': maxQuestions,
          'wrong': wrong
        });
      } else {
        int randQuestion = Random.secure().nextInt(questionsRemaining.length);
        int nextQuestion = questionsRemaining[randQuestion];
        questionsRemaining.removeAt(randQuestion);

        Navigator.pushReplacementNamed(context, '/repetitionQuestion', arguments: {
          'option': arguments['option'],
          'repetitionItems': arguments['repetitionItems'],
          'score': score + scoreIncrement,
          'questionNo': nextQuestion,
          'answered': answered,
          'wrong': wrong,
          'questionsRemaining': questionsRemaining,
          'maxQuestions': maxQuestions
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spanish-Book-Flutter'),
        centerTitle: true,
        backgroundColor: Colors.brown[800],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: Colors.brown[900],
        child: tests.isNotEmpty ? Column(
          children: [
            Text('${testData[questionNo][whichToShow]}', style: TextStyle(
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