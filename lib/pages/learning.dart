import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Learning extends StatefulWidget {
  const Learning({Key? key}) : super(key: key);

  @override
  State<Learning> createState() => _LearningState();
}

class _LearningState extends State<Learning> {

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
    String browseName = arguments['testName'];
    List learnData = tests.isNotEmpty ? tests[browseName]["data"] : [];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Spanish-Flutter'),
          centerTitle: true,
          backgroundColor: Colors.brown[800],
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          color: Colors.brown[900],
          child: learnData.isNotEmpty ? ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.brown[600],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: Image.asset('assets/spanish.png')),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 9,
                              child: Text('${learnData[index]["esp"]}',
                                style: TextStyle(color: Colors.brown[100], fontSize: 24),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(child: Image.asset('assets/english.png')),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 9,
                              child: Text('${learnData[index]["eng"]}',
                                style: TextStyle(color: Colors.brown[100], fontSize: 24),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(height: 20),
              itemCount: learnData.length) : Container()
        )
    );
  }
}
