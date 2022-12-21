import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Browser extends StatefulWidget {
  const Browser({Key? key}) : super(key: key);

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> {

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
