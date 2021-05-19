import 'package:findmee/screens/be-a-recruit/stepperRecruit.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Photos extends StatefulWidget {
  final PageController controller;

  const Photos({Key key, this.controller}) : super(key: key);
  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    CustomText(text: 'Photos',size: ScreenUtil().setSp(60),align: TextAlign.start,),
                    SizedBox(height: ScreenUtil().setHeight(70),),

                    ///pro pic
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xfff5f5f5),
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///header
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)
                                )
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                                child: CustomText(text: 'Profile Picture',color: Colors.white,size: ScreenUtil().setSp(45),),
                              ),
                            ),
                          ),

                          ///image
                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(80)),
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 60,
                            ),
                          ),

                          ///text
                          CustomText(
                            text: 'Click here to upload your profile picture',
                            font: 'GoogleSans',
                            size: ScreenUtil().setSp(40),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(60),)
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(60),),

                    ///selfie
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color(0xfff5f5f5),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///header
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)
                                  )
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                                child: CustomText(text: 'Selfie',color: Colors.white,size: ScreenUtil().setSp(45),),
                              ),
                            ),
                          ),

                          ///image
                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(80)),
                            child: CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 60,
                            ),
                          ),

                          ///text
                          CustomText(
                            text: 'Click here to upload a selfie of yours',
                            font: 'GoogleSans',
                            size: ScreenUtil().setSp(40),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(60),)
                        ],
                      ),
                    ),


                    SizedBox(height: ScreenUtil().setHeight(40),),

                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                      child: Button(text: 'Next',onclick: () async {
                        widget.controller.animateToPage(2,curve: Curves.ease,duration: Duration(milliseconds: 200));
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
