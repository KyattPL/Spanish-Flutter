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

    // Delete the existing file
    if (await file.exists()) {
      await file.delete();
    }

    // Copy the original JSON from assets
    String assetData = await rootBundle.loadString('assets/tests_json.json');
    await file.writeAsString(assetData);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data has been reset to the original version.'))
      );
    }
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
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () { Navigator.pushNamed(context, '/tests', arguments: { 'option': 1 }); },
                      fillColor: Colors.brown[700],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                            child: Row(
                              children: [
                                Expanded(child: Image.asset('assets/english.png')),
                                const Expanded(child: Icon(Icons.arrow_right, size: 72,)),
                                Expanded(child: Image.asset('assets/spanish.png'))
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('ENG', style: TextStyle(color: Colors.brown[200], fontSize: 64)),
                              Text('ESP', style: TextStyle(color: Colors.brown[200], fontSize: 64)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () { Navigator.pushNamed(context, '/tests', arguments: { 'option': 2 }); },
                      fillColor: Colors.brown[700],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                            child: Row(
                              children: [
                                Expanded(child: Image.asset('assets/spanish.png')),
                                const Expanded(child: Icon(Icons.arrow_right, size: 72,)),
                                Expanded(child: Image.asset('assets/english.png'))
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('ESP', style: TextStyle(color: Colors.brown[200], fontSize: 64)),
                              Text('ENG', style: TextStyle(color: Colors.brown[200], fontSize: 64)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: () { Navigator.pushNamed(context, '/browser'); },
                      fillColor: Colors.brown[700],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                            child: Row(
                              children: const [
                                Expanded(child: Icon(Icons.book, size: 72,)),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Learn', style: TextStyle(color: Colors.brown[200], fontSize: 64)),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _resetJsonFile(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button color
              ),
              child: const Text('Reset Data'),
            ),
          ],
        ),
      ),
    );
  }
}
