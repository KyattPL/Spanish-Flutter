import 'package:flutter/material.dart';
import 'package:spanish_app/pages/home.dart';

void main() {
  runApp(MaterialApp(
    routes: {
      '/': (context) => const Home()
    },
  ));
}