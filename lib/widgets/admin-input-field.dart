import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class AdminInputField extends StatefulWidget {

  final String hint;
  final TextEditingController controller;
  final int maxLines;

  const AdminInputField({Key key, this.hint, this.controller, this.maxLines=1}) : super(key: key);

  @override
  _AdminInputFieldState createState() => _AdminInputFieldState();
}

class _AdminInputFieldState extends State<AdminInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      enabled: false,
      maxLines: widget.maxLines,
      style: TextStyle(fontFamily: 'ComicSans'),
      decoration: InputDecoration(
          labelText: widget.hint,
          counterStyle: TextStyle(fontFamily: 'GoogleSans',fontWeight: FontWeight.bold),
          labelStyle: TextStyle(color: Color(0xff52575D),fontWeight: FontWeight.bold),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Colors.red,
                  width: 3
              )
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Colors.red,
                  width: 3
              )
          )
      ),
    );
  }
}