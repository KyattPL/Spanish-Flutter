import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Browser extends StatefulWidget {
  const Browser({Key? key}) : super(key: key);

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {

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
                    Navigator.pushNamed(context, '/learning', arguments: {
                      'testName': tests.keys.elementAt(index),
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
