import 'package:babybilly/utils/constants.dart';
import 'package:flutter/material.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '앗, 방지민님은 아직 체크리스트가 없어요.',
                  style: bodyStyle,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.asset(
                    'baby.jpeg',
                    fit: BoxFit.cover,
                    width: 200.0,
                    height: 200.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  height: 55.0,
                  width: 350.0,
                  decoration: BoxDecoration(
                    color: blue,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: FlatButton(
                    child: Text(
                      '지금 내 체크리스트 만들기 ➔',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Container();
    //   Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       Text(
    //         '앗, 방지민님은 아직 체크리스트가 없어요.',
    //         style: bodyStyle,
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.only(top: 10.0),
    //         child: Image.asset(
    //           'baby.jpeg',
    //           fit: BoxFit.cover,
    //           width: 200.0,
    //           height: 200.0,
    //         ),
    //       ),
    //       Container(
    //         margin: EdgeInsets.symmetric(vertical: 20.0),
    //         height: 55.0,
    //         width: 350.0,
    //         decoration: BoxDecoration(
    //           color: blue,
    //           borderRadius: BorderRadius.circular(30.0),
    //         ),
    //         child: FlatButton(
    //           child: Text(
    //             '지금 내 체크리스트 만들기 ➔',
    //             style: TextStyle(
    //                 color: Colors.white,
    //                 fontSize: 18.0,
    //                 fontWeight: FontWeight.bold),
    //           ),
    //           onPressed: () {
    //             setState(() {
    //               _fabHeight = 100 * (_panelHeightOpen - _panelHeightClosed) +
    //                   _initFabHeight;
    //             });
    //           },
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
