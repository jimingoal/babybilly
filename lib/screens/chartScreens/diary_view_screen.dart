import 'dart:io';

import 'package:babybilly/models/diary_model.dart';
import 'package:babybilly/screens/chartScreens/diary_edit_screen.dart';
import 'package:babybilly/utils/constants.dart';
import 'package:babybilly/widgets/diary_delete_popup.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DiaryViewScreen extends StatefulWidget {
  final Diary diary;

  DiaryViewScreen({this.diary});

  @override
  _DiaryViewScreenState createState() => _DiaryViewScreenState();
}

class _DiaryViewScreenState extends State<DiaryViewScreen> {
  Diary selectedDiary;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedDiary = widget.diary;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: black,
            ),
            onPressed: () => _showDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                selectedDiary?.title,
                style: viewTitleStyle,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.access_time,
                    size: 24,
                  ),
                ),
                Text(
                  '${DateFormat('yyyy-MM-dd hh:mm a').format(selectedDiary?.date)}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )
              ],
            ),
            if (selectedDiary.imagePath != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.file(
                  File(selectedDiary.imagePath),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                selectedDiary.content,
                style: viewContentStyle,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DiaryEditScreen(diary: widget.diary),
              ));
          // Navigator.pushNamed(context, DiaryEditScreen.route);
        },
        child: Icon(Icons.edit),
      ),
    );
  }

  _showDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return DiaryDeletePopUp(selectedDiary);
        });
  }
}
