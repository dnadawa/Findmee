import 'package:findmee/widgets/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'be-a-recruit/stepperRecruit.dart';
import 'book-a-recruit/stepper.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/back.png')),
        ),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: ScreenUtil().setHeight(200),),
            ///logo
            Container(
              width: ScreenUtil().setHeight(500),
              height: ScreenUtil().setHeight(500),
              child: Image.asset('assets/images/logo.png'),
            ),

            SizedBox(height: ScreenUtil().setHeight(250),),
            ///book a recruit
            Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width*0.1),
                child: SizedBox(
                  height: 70,
                  child: Button(
                    onclick: (){
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => StepperPage()),
                      );
                    },
                    text: 'Book a recruit',
                    borderRadius: 20,
                    textSize: ScreenUtil().setSp(60),
                    color: Colors.white,
                    textColor: Colors.black,
                  ),
                ),
              ),
            ///be a recruit
            Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.1),
              child: SizedBox(
                height: 70,
                child: Button(
                  onclick: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => RecruitStepperPage()),
                    );
                  },
                  text: 'Be a recruit',
                  borderRadius: 20,
                  textSize: ScreenUtil().setSp(60),
                  color: Colors.white,
                  textColor: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
