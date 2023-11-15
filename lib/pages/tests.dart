import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Tests extends StatefulWidget {
  const Tests({Key? key}) : super(key: key);

  @override
  State<Tests> createState() => _TestsState();
}

class _TestsState extends State<Tests> {

  Map tests = {};

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
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spanish-Flutter'),
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
                      int randQuestion = Random.secure().nextInt(tests[testName]['data'].length) + 1;
                      List<int> allQuestionIndices = [];
                      for (var i = 1; i <= tests[testName]['data'].length; i++) {
                        allQuestionIndices.add(i);
                      }
                      allQuestionIndices.remove(randQuestion);

                      Navigator.pushNamed(context, '/question', arguments: {
                        'option': arguments['option'],
                        'testName': testName,
                        'questionNo': randQuestion,
                        'answered': 0,
                        'score': 0,
                        'wrong': [],
                        'questionsRemaining': allQuestionIndices
                      });
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
