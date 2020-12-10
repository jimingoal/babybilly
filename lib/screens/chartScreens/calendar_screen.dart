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
    return Scaffold(
      body: Column(
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
                onPressed: () => _addEvent(
                    Event(title: _todoController.text, date: _selectedDate)),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          const SizedBox(height: 8.0),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('event').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              final documents = snapshot.data.docs;
              _events = {};
              DateTime dateTime;
              for (var doc in documents) {
                dateTime = doc['date'].toDate();
                List list = List();

                if (_events[dateTime] != null) list = _events[dateTime];
                print('list: $list');

                list.add(doc['title']);
                _events[dateTime] = list;
                // _events[dateTime].add(doc['title']);
                // list.add(doc['title']);
                print('now: ${DateTime.now()}');
                print('_event: $_events');
                print('_selectedDate: $_selectedDate');
                _selectedEvents = _events[_selectedDate.toLocal()] ?? [];

                // DateTime.parse(
                //       DateFormat('yyyy-MM-dd').format(_selectedDate))] ??
                //   [];
                print('_selectedEvents: $_selectedEvents');
              }
              return Expanded(child: _buildEventList());
            },
          ),
        ],
      ),
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return TableCalendar(
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
                  onDismissed: (direction) {
                    _deleteEvent(event.id);
                  },
                  key: Key(event),
                  background: slideLeftBackground(),
                  secondaryBackground: slideLeftBackground(),
                  child: ListTile(
                    title: Text(event.toString()),
                    onTap: () => print('$event tapped!'),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
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
  void _deleteEvent(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('event').doc(doc.id).delete();
  }
}
