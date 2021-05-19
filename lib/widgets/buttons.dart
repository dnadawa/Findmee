import 'package:flutter/material.dart';

import 'custom-text.dart';

class Button extends StatelessWidget {

  final onclick;
  final String text;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final double textSize;

  const Button({Key key, this.onclick, this.text, this.color: Colors.black, this.borderRadius=40, this.textColor=Colors.white, this.textSize=18,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onclick,
          style: ElevatedButton.styleFrom(
            primary: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius)
            ),
            padding: EdgeInsets.all(10),
          ),
          child: CustomText(text: text,size: textSize,color: textColor,),
        )
    );
  }
}