import 'package:babybilly/models/diary_model.dart';
import 'package:babybilly/utils/constants.dart';
import 'package:babybilly/widgets/diary_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DiaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('diary').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final documents = snapshot.data.docs;
          return Scaffold(
            body: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final item = documents[index];

                return ListItem(Diary(
                  item.id,
                  item.data()['title'],
                  item.data()['content'],
                  item.data()['imagePath'],
                  item.data()['date'],
                ));
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                goToNoteEditScreen(context);
              },
              child: Icon(Icons.add),
            ),
          );
        }
      },
    );
  }

  Widget noNotesUI(BuildContext context) {
    return Container(
      color: white,
      child: ListView(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Image.asset(
                  'baby.jpeg',
                  fit: BoxFit.cover,
                  width: 200.0,
                  height: 200.0,
                ),
              ),
              RichText(
                text: TextSpan(style: noNotesStyle, children: [
                  TextSpan(text: ' 앗, 아직 일기가 없어요.\n "'),
                  TextSpan(
                      text: '+',
                      style: boldPlus,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          goToNoteEditScreen(context);
                        }),
                  TextSpan(text: '" 눌러 일기를 작성해 보세요.')
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void goToNoteEditScreen(BuildContext context) {
    // Navigator.of(context).pushNamed(NoteEditScreen.route);
  }
}
