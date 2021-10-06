import 'package:flutter/material.dart';
import 'package:quiz_on/Controller/page_controller.dart';
import 'package:quiz_on/Screens/Dashboard/dashboard.dart';
import 'package:quiz_on/Screens/Score%20Board/score_board.dart';
import 'package:quiz_on/constants.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MyPageController controller = MyPageController();
  int _currentIndex = 0;
  List pages = [Dashboard(), ScoreBoard()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: yellow,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.score),
            label: 'Score Board',
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
