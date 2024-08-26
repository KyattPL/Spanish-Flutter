import 'dart:convert';
import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Tests extends StatefulWidget {
  const Tests({Key? key}) : super(key: key);

  @override
  State<Tests> createState() => _TestsState();
}

class _TestsState extends State<Tests> {

  Map tests = {};

  Future<void> _loadOrCopyJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/tests_json.json';
    final file = File(filePath);

    if (await file.exists()) {
      // Load the JSON file if it exists
      String jsonData = await file.readAsString();
      setState(() {
        tests = json.decode(jsonData);
      });
    } else {
      // Copy the JSON from assets to the writable directory if it doesn't exist
      String assetData = await rootBundle.loadString('assets/tests_json.json');
      await file.writeAsString(assetData);
      setState(() {
        tests = json.decode(assetData);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadOrCopyJson();
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spanish-Book-Flutter'),
        centerTitle: true,
        backgroundColor: Colors.brown[800],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: Colors.brown[900],
        child: tests.isNotEmpty ? ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return TextButton(
                    onPressed: () {
                      String testName = tests.keys.elementAt(index);
                      List<int> learningQuestionIndices = [];

                      for (int i = 0; i < tests[testName]['data'].length; i++) {
                        if (tests[testName]['data'][i]['in_learning'] == true) {
                          learningQuestionIndices.add(i);
                        }
                      }

                      if (learningQuestionIndices.isNotEmpty) {
                        int maxQuestions = learningQuestionIndices.length;
                        int randIndex = Random.secure().nextInt(learningQuestionIndices.length);
                        int randQuestion = learningQuestionIndices[randIndex];
                        learningQuestionIndices.remove(randQuestion);

                        Navigator.pushNamed(context, '/question', arguments: {
                          'option': arguments['option'],
                          'testName': testName,
                          'questionNo': randQuestion,
                          'answered': 0,
                          'score': 0,
                          'wrong': [],
                          'questionsRemaining': learningQuestionIndices,
                          'maxQuestions': maxQuestions
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('No questions available in the learning pool.'))
                        );
                      }
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.brown[200]),
                    child: Text(tests.keys.elementAt(index), style: const TextStyle(fontSize: 24))
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(height: 20),
              itemCount: tests.length
        ) : Container(),
      ),
    );
  }
}
