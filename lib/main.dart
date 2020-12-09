import 'package:babybilly/screens/charts_screen.dart';
import 'package:babybilly/screens/checklist_screen.dart';
import 'package:babybilly/screens/home_screen.dart';
import 'package:babybilly/screens/pregnant_screen.dart';
import 'package:babybilly/screens/settings_screen.dart';
import 'package:babybilly/utils/constants.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  List<Widget> _widgetOptions = <Widget>[
    ChartsScreen(),
    PregnantScreen(),
    HomeScreen(),
    ChecklistScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 75.0,
        items: <Widget>[
          Icon(Icons.pregnant_woman,
              size: 35, color: _page == 0 ? white : blue),
          Icon(Icons.show_chart, size: 35, color: _page == 1 ? white : blue),
          Icon(Icons.home, size: 35, color: _page == 2 ? white : blue),
          Icon(Icons.check_box, size: 35, color: _page == 3 ? white : blue),
          Icon(Icons.settings, size: 35, color: _page == 4 ? white : blue),
        ],
        color: pink,
        buttonBackgroundColor: blue,
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: _widgetOptions[_page],
    );
  }
}
