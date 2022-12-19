import 'Pages/mainPage.dart';
import 'Pages/searchPage.dart';
import 'Pages/basketPage.dart';
import 'package:flutter/material.dart';

import 'global.dart' as globals;

class Home extends StatefulWidget {
  final String way;
  const Home({Key? key, this.way = '/'}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _selectedPage = 0;

  @override
  void initState() {
    switch (widget.way) {
      case '/':
        _selectedPage = 0;
        break;
      case '/search':
        _selectedPage = 1;
        break;
      case '/basket':
        _selectedPage = 2;
        break;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70, // Set this height
        flexibleSpace: Container(
          color: Colors.deepPurple,
          child: Column(
            children: const [
              Spacer(
                flex: 8,
              ),
              Text(
                'N Market',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(
                flex: 3,
              ),
            ],
          ),
        ),
      ),
      body: [MainPage(), SearchPage(), const BasketPage()]
          .elementAt(_selectedPage),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 40,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search, size: 40),
            label: '',
          ),
        ],
        currentIndex: _selectedPage,
        selectedItemColor: Colors.deepPurple,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
    );
  }
}
