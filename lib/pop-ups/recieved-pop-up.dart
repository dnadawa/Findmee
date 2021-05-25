import 'dart:io';

import 'package:findmee/screens/book-a-recruit/stepper.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ReceivedPopUp extends StatefulWidget {
  @override
  _ReceivedPopUpState createState() => _ReceivedPopUpState();
}

class _ReceivedPopUpState extends State<ReceivedPopUp> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: EdgeInsets.symmetric(vertical: 24,horizontal: 10),
      contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 24),
      scrollable: true,
      backgroundColor: Colors.white,
      content: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            ///check mark
            Container(
              width: ScreenUtil().setHeight(800),
              height: ScreenUtil().setHeight(800),
              child: Center(child: Image.asset('assets/images/tick.gif')),
            ),


            ///text
            CustomText(
              text: 'We have received your request. One of our team member will contact you soon',
              font: 'ComicSans',
              isBold: false,
              size: ScreenUtil().setSp(55),
            ),
            SizedBox(height: ScreenUtil().setWidth(100),),

            ///buttons
            Row(
              children: [
                Expanded(
                  child: Button(
                    text: 'I need to hire recruiters again',
                    borderRadius: 10,
                    color: Color(0xff00C853),
                    onclick: (){
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => StepperPage()),
                      );
                    },
                  ),
                ),
                if(Platform.isAndroid)
                SizedBox(width: ScreenUtil().setWidth(50),),
                if(Platform.isAndroid)
                Expanded(
                  child: Button(
                    text: "I’m done for today",
                    borderRadius: 10,
                    color: Color(0xffFA1E0E),
                    onclick: (){
                      SystemNavigator.pop(animated: true);
                    },
                  ),
                )
              ],
            )


          ],
        ),
      ),
    );
  }
}
