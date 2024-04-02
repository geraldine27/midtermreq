import 'package:flutter/material.dart';
import 'package:midterm_req_word_guess/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Word Guess',
      color: Colors.grey.shade900,
      darkTheme: ThemeData(
        // fontFamily: 'Quiapo',
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,
      home: HomePage(),
    );
  }
}
