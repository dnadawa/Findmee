import 'dart:convert';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';

class ApprovalWorkerWeb extends StatefulWidget {
  @override
  _ApprovalWorkerWebState createState() => _ApprovalWorkerWebState();
}

class _ApprovalWorkerWebState extends State<ApprovalWorkerWeb> {
  String email;
  getStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = jsonDecode(prefs.getString('data'))['email'];
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
          padding: EdgeInsets.all(width*0.03),
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
                      child: CustomText(text: 'Velkommen',size: ScreenUtil().setSp(90),color: Colors.white,),
                    )
                ),
                SizedBox(height: ScreenUtil().setHeight(150),),

                Container(
                  height: ScreenUtil().setHeight(400),
                  width: ScreenUtil().setHeight(400),
                  child: Image.asset('assets/images/logo-red.png'),
                ),
                SizedBox(height: ScreenUtil().setHeight(200),),

                CustomText(
                  text: 'Tak for oprettelsen hos FindMe. Din profil er nu under behandling og du ville snarest hører fra vores team!',
                  font: 'ComicSans',
                  size: ScreenUtil().setSp(60),
                  isBold: false,
                ),

                Padding(
                    padding: EdgeInsets.all(width*0.03),
                    child: Button(
                      text: 'Næste',
                      padding: width*0.01,
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
    );
  }
}
