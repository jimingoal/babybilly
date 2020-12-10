import 'package:babybilly/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CalendarAddScreen extends StatelessWidget {
  final DateTime _selectedDate;

  CalendarAddScreen(this._selectedDate);

  @override
  Widget build(BuildContext context) {
    String newTaskTitle;

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              '일정 추가하기',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
                color: blue,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                newTaskTitle = newText;
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(
                color: blue,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: FlatButton(
                minWidth: 10,
                child: Text(
                  '추가',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('event')
                      .add({'title': newTaskTitle, 'date': _selectedDate});
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
