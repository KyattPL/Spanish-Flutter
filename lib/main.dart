import 'package:flutter/material.dart';
import 'package:spanish_app/pages/browser.dart';
import 'package:spanish_app/pages/home.dart';
import 'package:spanish_app/pages/learning.dart';
import 'package:spanish_app/pages/results.dart';
import 'package:spanish_app/pages/tests.dart';
import 'package:spanish_app/pages/question.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => const Home(),
      '/tests': (context) => const Tests(),
      '/question': (context) => const Question(),
      '/results': (context) => const Results(),
      '/browser': (context) => const Browser(),
      '/learning': (context) => const Learning()
    },
  ));
}