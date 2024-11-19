import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Repetition extends StatefulWidget {
  const Repetition({Key? key}) : super(key: key);

  @override
  State<Repetition> createState() => _RepetitionState();
}

class _RepetitionState extends State<Repetition> {
  List<Map<String, dynamic>> repetitionItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRepetitionItems();
  }

  Future<void> _loadRepetitionItems() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/repetition_items.json');

      if (await file.exists()) {
        final String contents = await file.readAsString();
        setState(() {
          repetitionItems = List<Map<String, dynamic>>.from(json.decode(contents));
          isLoading = false;
        });
      } else {
        // Create the file with an empty array if it doesn't exist
        await file.writeAsString('[]');
        setState(() {
          repetitionItems = [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading repetition items: $e');
      setState(() {
        repetitionItems = [];
        isLoading = false;
      });
    }
  }

  Future<void> _removeItem(int index) async {
    setState(() {
      repetitionItems.removeAt(index);
    });
    await _saveRepetitionItems();
  }

  Future<void> _clearAllItems() async {
    // Show confirmation dialog
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown[700],
          title: Text('Clear All Items', style: TextStyle(color: Colors.brown[200])),
          content: Text(
            'Are you sure you want to remove all items?',
            style: TextStyle(color: Colors.brown[200]),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('Cancel', style: TextStyle(color: Colors.brown[200])),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Clear', style: TextStyle(color: Colors.brown[200])),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      setState(() {
        repetitionItems.clear();
      });
      await _saveRepetitionItems();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All items cleared')),
        );
      }
    }
  }

  Future<void> _saveRepetitionItems() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/repetition_items.json');
    await file.writeAsString(json.encode(repetitionItems));
  }

  void _startPractice() {
    if (repetitionItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No items to practice!'))
      );
      return;
    }

    Navigator.pushNamed(context, '/repetitionQuestion', arguments: {
      'option': 1, // Default to English -> Spanish
      'questionNo': 0,
      'answered': 0,
      'score': 0,
      'wrong': [],
      'questionsRemaining': List.generate(repetitionItems.length - 1, (i) => i + 1),
      'maxQuestions': repetitionItems.length,
      'repetitionItems': repetitionItems,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Repetition Items'),
        centerTitle: true,
        backgroundColor: Colors.brown[800],
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        color: Colors.brown[900],
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
          children: [
            repetitionItems.isEmpty
                ? Center(
              child: Text(
                'No items to review',
                style: TextStyle(color: Colors.brown[200], fontSize: 20),
              ),
            )
                : ListView.builder(
              itemCount: repetitionItems.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Colors.brown[700],
                  child: ListTile(
                    title: Text(
                      '${repetitionItems[index]["esp"]} - ${repetitionItems[index]["eng"]}',
                      style: TextStyle(color: Colors.brown[200]),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      color: Colors.brown[200],
                      onPressed: () => _removeItem(index),
                    ),
                  ),
                );
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _clearAllItems,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[600],
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      'Clear All',
                      style: TextStyle(color: Colors.brown[200], fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _startPractice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[600],
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      'Practice',
                      style: TextStyle(color: Colors.brown[200], fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}