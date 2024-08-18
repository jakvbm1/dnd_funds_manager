import 'package:dnd_funds_manager/pages/character_select.dart';
import 'package:flutter/material.dart';
import 'package:dnd_funds_manager/pages/home.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'dnd funds manager',

      home: CharacterPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
