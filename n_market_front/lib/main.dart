import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => const Home(way: '/'),
        '/search': (context) => const Home(way: '/search'),
        '/basket': (context) => const Home(way: '/basket'),
      },
      title: 'N Market',
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const Home(),
    );
  }
}
