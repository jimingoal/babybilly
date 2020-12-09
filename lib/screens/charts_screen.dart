import 'package:babybilly/utils/constants.dart';
import 'package:flutter/material.dart';

class ChartsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      // 탭의 수 설정
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: white,
          flexibleSpace: SafeArea(
            child: TabBar(
              indicatorColor: blue,
              indicatorWeight: 3,
              labelColor: blue,
              labelStyle: headerStyle,
              labelPadding: EdgeInsets.all(5.0),
              unselectedLabelColor: Colors.black,
              unselectedLabelStyle: TextStyle(),
              tabs: [
                Text('검사\n&증상'),
                Text('체크\n리스트'),
                Text('몸무게\n기록'),
                Text('캘린더'),
                Text('다이\n어리'),
              ],
            ),
          ),
        ),
        // TabVarView 구현. 각 탭에 해당하는 컨텐트 구성
        body: TabBarView(
          children: [
            Container(color: Colors.red),
            Container(color: Colors.orange),
            Container(color: Colors.yellow),
            Container(color: Colors.green),
            Container(color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
