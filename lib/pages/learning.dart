import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Learning extends StatefulWidget {
  const Learning({Key? key}) : super(key: key);

  @override
  State<Learning> createState() => _LearningState();
}

class _LearningState extends State<Learning> {

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

  Future<void> saveJson() async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/tests_json.json';
    final file = File(filePath);

    // Convert the modified data back to JSON and save it
    String jsonData = json.encode(tests);
    await file.writeAsString(jsonData);
  }

  @override
  void initState() {
    super.initState();
    _loadOrCopyJson();
  }

  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    String browseName = arguments['testName'];
    List learnData = tests.isNotEmpty ? tests[browseName]["data"] : [];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Spanish-Book-Flutter'),
          centerTitle: true,
          backgroundColor: Colors.brown[800],
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          color: Colors.brown[900],
          child: learnData.isNotEmpty ? ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                Map item = learnData[index];
                bool inLearning = item['in_learning'];

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
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              inLearning
                                  ? 'In Learning: Yes'
                                  : 'In Learning: No',
                              style: TextStyle(
                                color: inLearning
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Switch(
                              value: inLearning,
                              onChanged: (bool newValue) {
                                setState(() {
                                  item['in_learning'] = newValue;
                                  saveJson();
                                });
                              },
                            ),
                          ],
                        ),
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
