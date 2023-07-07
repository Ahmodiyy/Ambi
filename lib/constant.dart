import 'package:flutter/material.dart';

const whiteColor = Colors.white;
const blackColor = Colors.black;
const constantTextFieldDecoration = InputDecoration(
  fillColor: Color(0xffF4F5FB),
  filled: true,
  hintText: 'Enter',
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(
      15,
    )),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(
      15,
    )),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff121312), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(
      15,
    )),
  ),
);
