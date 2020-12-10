import 'package:babybilly/models/diary_model.dart';
import 'package:babybilly/screens/chartScreens/diary_edit_screen.dart';
import 'package:babybilly/utils/constants.dart';
import 'package:babybilly/widgets/diary_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class DiaryScreen extends StatelessWidget {
  final DateFormat _dateFormatter = DateFormat("yyyy-MM-dd");

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
          List _elements = [];

          for (var doc in documents) {
            _elements.add(Diary(
              doc.id,
              doc.data()['title'],
              doc.data()['content'],
              doc.data()['imagePath'],
              doc.data()['date'].toDate(),
              (doc.data()['date'].toDate()).month.toString(),
            ));
          }

          for (var element in _elements) {
            print('element: ${element.title}');
          }

          return Scaffold(
              body: GroupedListView<dynamic, String>(
                elements: _elements,
                groupBy: (element) => element.group,
                groupComparator: (value1, value2) => value1.compareTo(value2),
                itemComparator: (item1, item2) =>
                    item1.title.compareTo(item2.title),
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                groupSeparatorBuilder: (String value) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '$value월',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                ),
                itemBuilder: (c, element) {
                  return ListItem(
                    element.id,
                    element.title,
                    element.content,
                    element.imagePath,
                    DateTime.parse(_dateFormatter.format(element.date)),
                  );
                },
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DiaryEditScreen()),
                  );
                },
                child: Icon(Icons.add),
              ));
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiaryEditScreen()),
                          );
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
}
