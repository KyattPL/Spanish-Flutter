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
  bool isLoading = true;
  String? error;

  // Track expanded states
  Set<String> expandedSections = {};
  Set<String> expandedSubsections = {};

  Future<void> _loadOrCopyJson() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/tests_json.json';
      final file = File(filePath);

      if (await file.exists()) {
        String jsonData = await file.readAsString();
        setState(() {
          tests = json.decode(jsonData);
          isLoading = false;
        });
      } else {
        String assetData = await rootBundle.loadString('assets/tests_json.json');
        await file.writeAsString(assetData);
        setState(() {
          tests = json.decode(assetData);
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadOrCopyJson();
  }

  // Get unique main sections (LEARNING I, LEARNING II, etc.)
  List<String> get mainSections {
    final sections = tests.keys
        .map((key) => key.toString().split('_').take(2).join(' '))
        .toSet()
        .toList();
    return sections..sort();
  }

  // Get subsections for a main section (LEARNING_I_1, LEARNING_I_2, etc.)
  List<String> getSubsections(String mainSection) {
    final normalizedMainSection = mainSection.replaceAll(' ', '_');
    return tests.keys
        .where((key) => key.toString().startsWith(normalizedMainSection))
        .map((key) => key.toString().split('_').take(3).join('_'))
        .toSet()
        .toList()
      ..sort();
  }

  // Get parts for a subsection (learning_I_1_part1, learning_I_1_part2, etc.)
  List getParts(String subsection) {
    return tests.keys
        .where((key) => key.toString().startsWith(subsection))
        .toList()
      ..sort();
  }

  void _handleTestSelection(BuildContext context, String testName, Map arguments) async {
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
        child: _buildContent(context, arguments),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map arguments) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.brown,
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Error loading data',
              style: TextStyle(color: Colors.brown[200], fontSize: 20),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                setState(() {
                  error = null;
                  isLoading = true;
                });
                _loadOrCopyJson();
              },
              child: Text(
                'Retry',
                style: TextStyle(color: Colors.brown[200]),
              ),
            ),
          ],
        ),
      );
    }

    if (tests.isEmpty) {
      return Center(
        child: Text(
          'No tests available',
          style: TextStyle(color: Colors.brown[200], fontSize: 20),
        ),
      );
    }

    return ListView.builder(
      itemCount: mainSections.length,
      itemBuilder: (context, mainIndex) {
        final mainSection = mainSections[mainIndex];
        final isMainExpanded = expandedSections.contains(mainSection);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  if (isMainExpanded) {
                    expandedSections.remove(mainSection);
                    expandedSubsections.removeWhere(
                          (sub) => sub.startsWith(mainSection.replaceAll(' ', '_')),
                    );
                  } else {
                    expandedSections.add(mainSection);
                  }
                });
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.brown[200],
                padding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
              child: Row(
                children: [
                  Icon(
                    isMainExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.brown[200],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    mainSection,
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            if (isMainExpanded) ...[
              ...getSubsections(mainSection).map((subsection) {
                final isSubExpanded = expandedSubsections.contains(subsection);
                return Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            if (isSubExpanded) {
                              expandedSubsections.remove(subsection);
                            } else {
                              expandedSubsections.add(subsection);
                            }
                          });
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.brown[200],
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSubExpanded ? Icons.expand_less : Icons.expand_more,
                              color: Colors.brown[200],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              subsection,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      if (isSubExpanded)
                        ...getParts(subsection).map((part) => Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: TextButton(
                            onPressed: () => _handleTestSelection(context, part, arguments),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.brown[200],
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                part,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        )),
                    ],
                  ),
                );
              }),
            ],
            const Divider(height: 20, color: Colors.brown),
          ],
        );
      },
    );
  }
}