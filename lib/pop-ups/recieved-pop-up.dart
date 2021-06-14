import 'dart:io';

import 'package:findmee/screens/book-a-recruit/stepper.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              text: 'Offer successfully sent to selected recruiters. You will receive an email and a notification when they are respond to the offer.',
              font: 'ComicSans',
              isBold: false,
              size: ScreenUtil().setSp(55),
            ),
            SizedBox(height: ScreenUtil().setWidth(100),),

            ///buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: ScreenUtil().setHeight(230),
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(builder: (context) =>
                                StepperPage()), (Route<dynamic> route) => false);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff00C853),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      child: CustomText(text: 'Jeg skal ansætte flere vikarer',size: 18,color: Colors.white,),
                    ),
                  ),
                ),
                if(Platform.isAndroid)
                SizedBox(width: ScreenUtil().setWidth(50),),
                if(Platform.isAndroid)
                Expanded(
                  child: SizedBox(
                    height: ScreenUtil().setHeight(230),
                    child: ElevatedButton(
                      onPressed: (){
                        SystemNavigator.pop(animated: true);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xffFA1E0E),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      child: CustomText(text: "Jeg er færdig",size: 18,color: Colors.white,),
                    ),
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
