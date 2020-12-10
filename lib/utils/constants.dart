import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const pink = Color(0xFFF6D5C3);
const blue = Color(0xFF5C8FC6);
const white = Colors.white;
const black = Colors.black;
const black2 = Color(0xFF424242);
const grey = Color(0xFFEAEAEA);
const grey2 = Color(0xFF6D6D6D);

var headerStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    color: white,
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
  ),
);

var bodyStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  ),
);

var noNotesStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    fontSize: 22.0,
    color: black2,
    fontWeight: FontWeight.w600,
  ),
);
var boldPlus = GoogleFonts.roboto(
  textStyle: TextStyle(
    fontSize: 30.0,
    color: Colors.blueAccent,
    fontWeight: FontWeight.bold,
  ),
);

var itemTitle = GoogleFonts.roboto(
  textStyle: TextStyle(
    fontSize: 18.0,
    color: black,
    fontWeight: FontWeight.bold,
  ),
);
var itemDateStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    fontSize: 11.0,
    color: grey2,
  ),
);
var itemContentStyle = GoogleFonts.roboto(
  textStyle: TextStyle(
    fontSize: 15.0,
    color: grey2,
  ),
);

var createTitle = GoogleFonts.roboto(
    textStyle: TextStyle(
  fontSize: 28.0,
  fontWeight: FontWeight.w900,
));
var createContent = GoogleFonts.roboto(
  textStyle: TextStyle(
    letterSpacing: 1.0,
    fontSize: 20.0,
    height: 1.5,
    fontWeight: FontWeight.w400,
  ),
);

var shadow = [
  BoxShadow(
    color: Colors.grey[300],
    blurRadius: 30,
    offset: Offset(0, 10),
  )
];
