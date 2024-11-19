import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _resetJsonFile(BuildContext context) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/tests_json.json';
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }

    String assetData = await rootBundle.loadString('assets/tests_json.json');
    await file.writeAsString(assetData);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data has been reset to the original version.'))
      );
    }
  }

  Widget _buildButton({
    required VoidCallback onPressed,
    required Widget content,
    required double height,
    Color? color,
  }) {
    return Container(
      height: height,
      margin: const EdgeInsets.only(bottom: 8),
      child: RawMaterialButton(
        onPressed: onPressed,
        fillColor: color ?? Colors.brown[700],
        child: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final availableHeight = screenHeight -
        MediaQuery.of(context).padding.top -
        AppBar().preferredSize.height -
        16; // Total padding

    final largeButtonHeight = availableHeight * 0.25; // 25% of available height
    final smallButtonHeight = availableHeight * 0.2;  // 20% of available height
    final resetButtonHeight = 36.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Spanish-Book-Flutter'),
        centerTitle: true,
        backgroundColor: Colors.brown[800],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        color: Colors.brown[900],
        child: ListView(
          children: [
            _buildButton(
              height: largeButtonHeight,
              onPressed: () {
                Navigator.pushNamed(context, '/tests', arguments: {'option': 1});
              },
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                    child: Row(
                      children: [
                        Expanded(child: Image.asset('assets/english.png')),
                        const Expanded(child: Icon(Icons.arrow_right, size: 64)),
                        Expanded(child: Image.asset('assets/spanish.png'))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('ENG', style: TextStyle(color: Colors.brown[200], fontSize: 42)),
                      Text('ESP', style: TextStyle(color: Colors.brown[200], fontSize: 42)),
                    ],
                  )
                ],
              ),
            ),
            _buildButton(
              height: largeButtonHeight,
              onPressed: () {
                Navigator.pushNamed(context, '/tests', arguments: {'option': 2});
              },
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 32),
                    child: Row(
                      children: [
                        Expanded(child: Image.asset('assets/spanish.png')),
                        const Expanded(child: Icon(Icons.arrow_right, size: 64)),
                        Expanded(child: Image.asset('assets/english.png'))
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('ESP', style: TextStyle(color: Colors.brown[200], fontSize: 42)),
                      Text('ENG', style: TextStyle(color: Colors.brown[200], fontSize: 42)),
                    ],
                  )
                ],
              ),
            ),
            _buildButton(
              height: smallButtonHeight,
              onPressed: () {
                Navigator.pushNamed(context, '/browser');
              },
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.book, size: 64),
                  Text('Learn', style: TextStyle(color: Colors.brown[200], fontSize: 42)),
                ],
              ),
            ),
            _buildButton(
              height: smallButtonHeight,
              onPressed: () {
                Navigator.pushNamed(context, '/repetition');
              },
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.repeat, size: 64),
                  Text('Repetition', style: TextStyle(color: Colors.brown[200], fontSize: 42)),
                ],
              ),
            ),
            SizedBox(
              height: resetButtonHeight,
              child: ElevatedButton(
                onPressed: () async {
                  await _resetJsonFile(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Reset Data'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}