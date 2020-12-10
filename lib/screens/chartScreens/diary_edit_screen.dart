import 'dart:io';

import 'package:babybilly/models/diary_model.dart';
import 'package:babybilly/screens/chartScreens/diary_screen.dart';
import 'package:babybilly/utils/constants.dart';
import 'package:babybilly/widgets/diary_delete_popup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DiaryEditScreen extends StatefulWidget {
  final Diary diary;

  DiaryEditScreen({this.diary});

  @override
  _DiaryEditScreenState createState() => _DiaryEditScreenState();
}

class _DiaryEditScreenState extends State<DiaryEditScreen> {
  final DateFormat _dateFormatter = DateFormat("yyyy-MM-dd");
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  File _image;

  final picker = ImagePicker();

  Diary selectedDiary;

  @override
  void initState() {
    super.initState();
    selectedDiary = widget.diary;
    _titleController.text = selectedDiary?.title;
    _contentController.text = selectedDiary?.content;
    _dateController.text = _dateFormatter.format(_selectedDate);

    if (selectedDiary?.imagePath != null) {
      _image = File(selectedDiary.imagePath);
    }
  }

  _handleDatePicker(BuildContext context) async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null && date != _selectedDate) {
      setState(() {
        _selectedDate = date;
      });
      _dateController.text = _dateFormatter.format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0.7,
        backgroundColor: white,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back),
          color: black,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_camera),
            color: black,
            onPressed: () {
              getImage(ImageSource.camera);
            },
          ),
          IconButton(
            icon: Icon(Icons.insert_photo),
            color: black,
            onPressed: () {
              getImage(ImageSource.gallery);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: black,
            onPressed: () {
              if (widget.diary != null) {
                _showDialog();
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 5.0, top: 5.0),
                child: TextFormField(
                  readOnly: true,
                  controller: _dateController,
                  onTap: () {
                    _handleDatePicker(context);
                  },
                  style: createTitle,
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0, right: 5.0, bottom: 5.0),
              child: TextField(
                controller: _titleController,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                style: createTitle,
                decoration: InputDecoration(
                    hintText: '제목을 입력해 주세요.', border: InputBorder.none),
              ),
            ),
            if (_image != null)
              Container(
                padding: EdgeInsets.all(10.0),
                width: MediaQuery.of(context).size.width,
                height: 300.0,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        image: DecorationImage(
                          image: FileImage(_image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _image = null;
                              });
                            },
                            child: Icon(
                              Icons.cancel_outlined,
                              size: 18.0,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 10.0, bottom: 5.0),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                style: createContent,
                decoration: InputDecoration(
                  hintText: '내용을 입력해주세요....',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: () {
          if (_titleController.text.isEmpty)
            _titleController.text = 'Untitled Note';

          saveDiary();
        },
        child: Icon(Icons.save),
      ),
    );
  }

  getImage(ImageSource imageSource) async {
    PickedFile imageFile = await picker.getImage(source: imageSource);

    if (imageFile == null) return;

    File tmpFile = File(imageFile.path);

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = basename(imageFile.path);

    tmpFile = await tmpFile.copy('${appDir.path}/$fileName');

    setState(() {
      _image = tmpFile;
    });
  }

  void saveDiary() {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    String imagePath = _image != null ? _image.path : null;

    //update
    if (widget.diary != null) {
      print('update');
      FirebaseFirestore.instance
          .collection('diary')
          .doc(widget.diary.id)
          .update({
        'title': title,
        'content': content,
        'imagePath': imagePath,
        'date': _selectedDate,
      });
      Navigator.pushReplacement(
          this.context,
          MaterialPageRoute(
            builder: (context) => DiaryScreen(),
          ));
    } else {
      //add
      print('add');
      FirebaseFirestore.instance.collection('diary').add({
        'title': title,
        'content': content,
        'imagePath': imagePath,
        'date': _selectedDate,
      });
      Navigator.pushReplacement(
          this.context,
          MaterialPageRoute(
            builder: (context) => DiaryScreen(),
          ));
    }
  }

  void _showDialog() {
    showDialog(
        context: this.context,
        builder: (context) {
          return DiaryDeletePopUp(selectedDiary);
        });
  }
}
