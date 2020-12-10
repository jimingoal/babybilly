class Diary {
  String _id;
  String _title;
  String _content;
  String _imagePath;
  DateTime _date;
  String _group;

  Diary(this._id, this._title, this._content, this._imagePath, this._date,
      this._group);

  String get id => _id;

  String get title => _title;

  String get content => _content;

  String get imagePath => _imagePath;

  DateTime get date => _date;

  String get group => _group;
}
