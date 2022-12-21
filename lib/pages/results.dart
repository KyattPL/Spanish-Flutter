import 'package:flutter/material.dart';

class Results extends StatefulWidget {
  const Results({Key? key}) : super(key: key);

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    String testName = arguments['testName'];
    int score = arguments['score'];
    int maxScore = arguments['maxScore'];
    List wrong = arguments['wrong'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spanish-Flutter'),
        centerTitle: true,
        backgroundColor: Colors.brown[800],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: Colors.brown[900],
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(testName, style: TextStyle(
                    color: Colors.brown[200],
                    fontSize: 32
                  )),
                  Text('Your score was: $score / $maxScore', style: TextStyle(
                    color: Colors.brown[200],
                    fontSize: 16
                  )),
                  TextButton(onPressed: () {
                    Navigator.pop(context);
                  },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.brown[200],
                        backgroundColor: Colors.brown[400],
                        textStyle: const TextStyle(fontSize: 16)
                      ),
                      child: const Text('Continue')
                  ),
                  Column(
                    children: wrong.isNotEmpty ? wrong.map((inc) => Text(
                      '${inc["esp"]} - ${inc["eng"]}',
                      style: TextStyle(color: Colors.brown[400]),
                    )).toList() : [],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
