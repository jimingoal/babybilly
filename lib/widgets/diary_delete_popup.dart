import 'package:babybilly/models/diary_model.dart';
import 'package:babybilly/screens/chartScreens/diary_screen.dart';
import 'package:babybilly/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DiaryDeletePopUp extends StatelessWidget {
  final Diary selectedDairy;

  DiaryDeletePopUp(this.selectedDairy);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Text(
        '삭제?',
        style: largeBold,
      ),
      content: Text('정말로 이 일기를 삭제하시겠습니까?', style: mediumBold),
      actions: [
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            FirebaseFirestore.instance
                .collection('diary')
                .doc(selectedDairy.id)
                .delete();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DiaryScreen(),
                ));
          },
        ),
        TextButton(
          child: Text('No'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
