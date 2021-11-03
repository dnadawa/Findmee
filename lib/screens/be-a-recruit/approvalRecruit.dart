import 'dart:convert';
import 'package:findmee/web/be-a-recruit/dashboard.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../responsive.dart';

class ApprovalRecruit extends StatefulWidget {
  @override
  _ApprovalRecruitState createState() => _ApprovalRecruitState();
}

class _ApprovalRecruitState extends State<ApprovalRecruit> {
  String email;
  getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = jsonDecode(prefs.getString('data'))['email'];
  }

  final _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatus();
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(45)),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )
            ),
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(65)),
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: ScreenUtil().setHeight(30),),
                      Align(
                          alignment: Alignment.topLeft,
                          child: CustomText(text: 'Velkommen',size: ScreenUtil().setSp(90),align: TextAlign.start,color: Color(0xff52575D))),
                      SizedBox(height: ScreenUtil().setHeight(150),),

                      Container(
                        height: ScreenUtil().setHeight(400),
                        width: ScreenUtil().setHeight(400),
                        child: Image.asset('assets/images/logo-red.png'),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(200),),

                      CustomText(
                        text: 'Din profil er godkendt.',
                        font: 'ComicSans',
                        size: ScreenUtil().setSp(60),
                        isBold: false,
                      ),

                      Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(200),bottom: ScreenUtil().setHeight(50)),
                          child: Button(
                            text: 'Næste',
                            padding: isTablet?width*0.025:10,
                            onclick: () async {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => Dashboard(email: email)),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
