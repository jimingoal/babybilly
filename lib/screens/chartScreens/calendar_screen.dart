import 'package:babybilly/models/event_model.dart';
import 'package:babybilly/screens/chartScreens/calendar_add_screen.dart';
import 'package:babybilly/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
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

  List colors = [
    Color(0xFFCBD2F7),
    Color(0xFFCBE8DE),
    Color(0xFFFDE9B9),
  ];

  TimeOfDay _time = TimeOfDay.now().replacing(minute: 30);
  bool iosStyle = true;

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _time = newTime;
    });
  }

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
              alarm: doc.data()['alarm'] == null
                  ? null
                  : doc.data()['alarm'].toDate(),
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
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: _selectedEvents.isNotEmpty
                          ? Expanded(child: _buildEventList())
                          : Center(
                              child: Text(
                                '오늘 일정이 없습니다.',
                                style: TextStyle(
                                  color: blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: blue,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                      child: Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: CalendarAddScreen(_selectedDate),
                  )));
        },
        child: Icon(Icons.add),
      ),
    );
  }

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
      children: _selectedEvents.map((event) {
        return Container(
          decoration: BoxDecoration(
            color: Color(0xFFCBD2F7),
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Dismissible(
            direction: DismissDirection.endToStart,
            key: Key(event.id),
            onDismissed: (direction) {
              _deleteEvent(event);
            },
            background: slideLeftBackground(),
            child: ListTile(
              title: Row(
                children: [
                  Container(
                    width: 190,
                    child: Text(
                      event.title,
                      style: mediumBold,
                    ),
                  ),
                  event.alarm != null
                      ? Expanded(
                          child: Text(
                            '알람: ${DateFormat('hh:mm a').format(event.alarm)}',
                            // '알람: ${event.alarm}',
                            style: mediumBold,
                          ),
                        )
                      : Container(),
                ],
              ),
              onTap: () => print('${event.id} tapped!'),
              trailing: IconButton(
                icon: Icon(Icons.alarm),
                onPressed: () {
                  Navigator.of(context).push(
                    showPicker(
                        context: context,
                        value: _time,
                        onChange: onTimeChanged,
                        onChangeDateTime: (DateTime dateTime) {
                          FirebaseFirestore.instance
                              .collection('event')
                              .doc(event.id)
                              .update({
                            'alarm': dateTime,
                          });
                        }),
                  );
                },
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.red[200],
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
