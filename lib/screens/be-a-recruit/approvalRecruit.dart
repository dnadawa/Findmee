import 'package:findmee/screens/be-a-recruit/stepperRecruit.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Approval extends StatefulWidget {
  final PageController controller;

  const Approval({Key key, this.controller}) : super(key: key);
  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(45)),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(45)),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(text: 'Approval',size: ScreenUtil().setSp(60),align: TextAlign.start,)),
                    SizedBox(height: ScreenUtil().setHeight(70),),

                    Container(
                      height: ScreenUtil().setHeight(500),
                      width: ScreenUtil().setHeight(500),
                      color: Colors.red,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(100),),

                    CustomText(
                      text: 'Waiting for Approval',
                      font: 'ComicSans',
                      size: ScreenUtil().setSp(60),
                      isBold: false,
                    ),


                    SizedBox(height: ScreenUtil().setHeight(40),),

                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                      child: Button(text: 'Next',onclick: () async {
                        widget.controller.animateToPage(3,curve: Curves.ease,duration: Duration(milliseconds: 200));
                      }),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
