import 'package:flutter/material.dart';

class DairyDeletePopUp extends StatelessWidget {
  // final Note selectedNote;
  //
  // DeletePopUp(this.selectedNote);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: Text('Delete?'),
      content: Text('Do you want to delete the note?'),
      actions: [
        TextButton(
          child: Text('Yes'),
          onPressed: () {
            // Provider.of<NoteProvider>(context, listen: false)
            //     .deleteNote(selectedNote.id);
            // Navigator.popUntil(context, ModalRoute.withName('/'));
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
