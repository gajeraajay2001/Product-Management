import 'package:flutter/material.dart';
import 'package:practicle_interview/screens/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => HomeScreen(),
      },
    ),
  );
}
