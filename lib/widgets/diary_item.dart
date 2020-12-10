import 'dart:io';

import 'package:babybilly/models/diary_model.dart';
import 'package:babybilly/utils/constants.dart';
import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final Diary diary;

  ListItem(this.diary);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 135.0,
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: InkWell(
        onTap: () {
          // Navigator.pushNamed(context, NoteViewScreen.route, arguments: id);
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: white,
            boxShadow: shadow,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              color: grey,
              width: 1.0,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        diary.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: itemTitle,
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        diary.date,
                        overflow: TextOverflow.ellipsis,
                        style: itemDateStyle,
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Expanded(
                        child: Text(
                          diary.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: itemContentStyle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (diary.imagePath != null)
                Row(
                  children: [
                    SizedBox(
                      width: 12.0,
                    ),
                    Container(
                      width: 80.0,
                      height: 95.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        image: DecorationImage(
                          image: FileImage(
                            File(diary.imagePath),
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
