import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class InputField extends StatefulWidget {

  final String hint;
  final TextInputType type;
  final bool ispassword;
  final TextEditingController controller;
  final int length;


  const InputField({Key key, this.hint, this.type, this.ispassword=false, this.controller, this.length}) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _isPassword;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isPassword = widget.ispassword;
  }
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontFamily: 'ComicSans'
    );
    return Padding(
      padding:  EdgeInsets.only(top: widget.ispassword?0:20),
      child: TextField(
        style: textStyle,
        maxLength: widget.length,
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: widget.type,
        controller: widget.controller,
        obscureText: _isPassword,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: textStyle,
          enabledBorder:UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 5),
          ),
          suffix: widget.ispassword?IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: (){
              setState(() {
                _isPassword = !_isPassword;
              });
            },
          ):null
        ),
      ),
    );
  }
}