import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/home_page.dart';
import 'pages/stock_page.dart';
import 'pages/swapping_page.dart';
import 'pages/expenses_page.dart';
import 'pages/notes_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swaps Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/stock': (context) => StockPage(),
        '/expenses': (context) => ExpensesPage(),
        '/note': (context) => NotesPage(),
        '/swapping': (context) => SwappingPage(),
      },
    );
  }
}
