import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/responsive.dart';
import 'package:findmee/screens/be-a-recruit/offers.dart';
import 'package:findmee/web/be-a-recruit/offers.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'editDates.dart';

class ApprovalWeb extends StatefulWidget {
  final PageController controller;

  const ApprovalWeb({Key key, this.controller}) : super(key: key);
  @override
  _ApprovalWebState createState() => _ApprovalWebState();
}

class _ApprovalWebState extends State<ApprovalWeb> {
  String status = 'pending';
  String email;
  getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = jsonDecode(prefs.getString('data'))['email'];
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
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffFA1E0E).withOpacity(0.05),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(status=='approved'?width*0.03:width*0.09),
          child: Container(
            width: width*0.3,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30))
                  ),
                    child: Padding(
                      padding: EdgeInsets.all(width*0.01),
                      child: CustomText(text: 'Godkendelse',size: ScreenUtil().setSp(90),color: Colors.white,),
                    )
                ),
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
                    padding: EdgeInsets.all(width*0.03),
                    child: Button(
                      text: 'Opret en ny konto',
                      padding: width*0.01,
                      onclick: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.remove('data');
                        widget.controller.animateToPage(0,curve: Curves.ease,duration: Duration(milliseconds: 200));
                      },
                    ),
                  ),
                if(status=='approved')
                  Padding(
                    padding: EdgeInsets.all(width*0.03),
                    child: Button(
                      text: 'Næste',
                      padding: width*0.01,
                      onclick: () async {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => Responsive(mobile: Offers(), tablet: Offers(), desktop: OffersWeb())),
                        );
                      },
                    ),
                  ),
                if(status=='approved')
                  Padding(
                    padding: EdgeInsets.fromLTRB(width*0.03,0,width*0.03,width*0.03),
                    child: Button(
                      text: 'Edit Available Dates',
                      padding: width*0.01,
                      color: Colors.red,
                      onclick: () async {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => EditDatesWeb(email: email,)),
                        );
                      },
                    ),
                  ),
                if(status=='pending')
                  SizedBox(height: width*0.03,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
