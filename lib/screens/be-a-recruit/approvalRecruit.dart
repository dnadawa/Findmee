import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../responsive.dart';
import 'offers.dart';

class Approval extends StatefulWidget {
  final PageController controller;

  const Approval({Key key, this.controller}) : super(key: key);
  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  String status = 'pending';
  getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = jsonDecode(prefs.getString('data'))['email'];
    var sub = await FirebaseFirestore.instance.collection('workers').where('email', isEqualTo: email).get();
    var user = sub.docs;
    setState(() {
      status = user[0]['status'];
    });
  }

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
            height: ScreenUtil().setHeight(1500),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )
            ),
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(65)),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(text: 'Godkendelse',size: ScreenUtil().setSp(90),align: TextAlign.start,color: Color(0xff52575D))),
                    SizedBox(height: ScreenUtil().setHeight(150),),

                    Container(
                      height: ScreenUtil().setHeight(500),
                      width: ScreenUtil().setHeight(500),
                      child: Image.asset('assets/images/${status=='pending'?'waiting':status=='ban'?'banned':'approved'}.png'),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(100),),

                    CustomText(
                      text: status=='pending'?'Venter på godkendelse':status=='ban'?'Din profil er ikke godkendt.':'Din profil er godkendt.',
                      font: 'ComicSans',
                      size: ScreenUtil().setSp(60),
                      isBold: false,
                    ),

                    if(status=='ban')
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(200)),
                        child: Button(
                          text: 'Opret en ny konto',
                          padding: isTablet?width*0.025:10,
                          onclick: () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.remove('data');
                            widget.controller.animateToPage(0,curve: Curves.ease,duration: Duration(milliseconds: 200));
                          },
                        ),
                      ),
                    if(status=='approved')
                      Padding(
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(200)),
                        child: Button(
                          text: 'Næste',
                          padding: isTablet?width*0.025:10,
                          onclick: () async {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context) => Offers()),
                            );
                          },
                        ),
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
