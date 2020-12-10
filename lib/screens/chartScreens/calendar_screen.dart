import 'package:babybilly/models/event_model.dart';
import 'package:babybilly/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CalendarScreen>
    with TickerProviderStateMixin {
  Map<DateTime, List> _events;
  List _selectedEvents;
  DateTime _selectedDate;

  AnimationController _animationController;
  CalendarController _calendarController;
  final DateFormat _dateFormatter = DateFormat("yyyy-MM-dd");

  var _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    // _events = {};
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    _todoController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      // _selectedEvents = events;
      _selectedDate = day;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('event').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final documents = snapshot.data.docs;
          final DateFormat _dateFormatter = DateFormat("yyyy-MM-dd");
          print('documents: $documents');

          _events = {};
          DateTime dateTime;
          for (var doc in documents) {
            // print('doc: ${doc.id}');
            // print('title: ${doc.data()['title']}');
            // print('date: ${doc.data()['date'].toDate()}');
            dateTime = DateTime.parse(
                _dateFormatter.format(doc.data()['date'].toDate()));
            List list = List();

            if (_events[dateTime] != null) list = _events[dateTime];
            print('list: $list');

            print(
                'Event(id: ${doc.id}, title: ${doc.data()['title']}, date: ${DateTime.parse(_dateFormatter.format(doc.data()['date'].toDate()))})');

            list.add(Event(
              id: doc.id,
              title: doc.data()['title'],
              date: doc.data()['date'].toDate(),
            ));
            _events[dateTime] = list;
            // _events[dateTime].add(doc['title']);
            // list.add(doc['title']);
            print('now: ${DateTime.now()}');
            print('_event: $_events');
            print(
                '_selectedDate: ${DateTime.parse(_dateFormatter.format(_selectedDate))}');
            _selectedEvents =
                _events[DateTime.parse(_dateFormatter.format(_selectedDate))] ??
                    [];
            print('_selectedEvents: $_selectedEvents');
          }
          return SafeArea(
            child: Container(
              height: size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _buildTableCalendar(),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _todoController,
                        ),
                      ),
                      RaisedButton(
                        child: Text('추가'),
                        onPressed: () => _addEvent(Event(
                            title: _todoController.text, date: _selectedDate)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(child: _buildEventList()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
      rowHeight: MediaQuery.of(context).size.height * 0.08,
      calendarController: _calendarController,
      events: _events,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      calendarStyle: CalendarStyle(
        selectedColor: blue,
        todayColor: pink,
        markersColor: Colors.red,
        outsideDaysVisible: false,
      ),
      headerStyle: HeaderStyle(
        formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
        formatButtonDecoration: BoxDecoration(
          color: pink,
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onDaySelected: _onDaySelected,
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Dismissible(
                  direction: DismissDirection.endToStart,
                  key: Key(event.id),
                  onDismissed: (direction) {
                    _deleteEvent(event);
                  },
                  background: slideLeftBackground(),
                  child: ListTile(
                    title: Text(event.title),
                    onTap: () => print('{$event.title} tapped!'),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.8),
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.red,
      ),
      // color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  // 할 일 추가 메서드
  void _addEvent(Event event) {
    print('title: ${event.title}, date: ${event.date}');
    FirebaseFirestore.instance
        .collection('event')
        .add({'title': event.title, 'date': event.date});
    _todoController.text = '';
  }

  // 할 일 삭제 메서드
  void _deleteEvent(Event event) {
    FirebaseFirestore.instance.collection('event').doc(event.id).delete();
  }
}
