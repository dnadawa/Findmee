import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'custom-text.dart';

class ToggleButton extends StatefulWidget {
  final String text;
  final bool isSelected;
  final Function onclick;

  const ToggleButton({Key key, this.text, this.isSelected, this.onclick}) : super(key: key);
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onclick,
        child: Container(
          width: ScreenUtil().setWidth(400),
          height: ScreenUtil().setHeight(150),
          decoration: BoxDecoration(
              color: widget.isSelected?Color(0xffFA1E0E):Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(10)
          ),
          child: Center(
            child: CustomText(
              text: widget.text,
              font: 'GoogleSans',
              color: widget.isSelected?Colors.white:Colors.black,
              size: ScreenUtil().setSp(45),
            ),
          ),
        ),
      ),
    );
  }
}
