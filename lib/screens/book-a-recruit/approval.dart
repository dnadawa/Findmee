import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/screens/book-a-recruit/profiles.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../email.dart';
import '../../responsive.dart';

class Approval extends StatefulWidget {
  @override
  _ApprovalState createState() => _ApprovalState();
}

class _ApprovalState extends State<Approval> {
  final _scrollController = ScrollController();

  sendEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = prefs.getString('companyEmail');

    var sub = await FirebaseFirestore.instance.collection('companies').where('email', isEqualTo: email).get();
    var user = sub.docs;
    bool isSent;
    if(user.isNotEmpty){
      try{
        isSent = user[0]['emailSent'];
      }
      catch(e){
        isSent = false;
      }
    }

    if(!isSent){
      await CustomEmail.sendEmail(
          'Tak fordi du har oprettet en bruger hos os!\n\nVi ser frem til et stærkt og professionelt fremadrettet samarbejde med jer og den rette vikarservice. ',
          'Velkommen til FindMe', to: email);

      await FirebaseFirestore.instance.collection('companies').doc(email).update({'emailSent': true});
    }
    else{
      print("Email already sent!");
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendEmail();
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

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomText(
                          text: 'Tak for oprettelsen hos FindMe. Din profil er nu under behandling og du ville snarest hører fra vores team!',
                          font: 'ComicSans',
                          size: ScreenUtil().setSp(60),
                          isBold: false,
                        ),
                      ),

                      Padding(
                          padding: EdgeInsets.only(top: ScreenUtil().setHeight(200),bottom: ScreenUtil().setHeight(50)),
                          child: Button(
                            text: 'Næste',
                            padding: isTablet?width*0.025:10,
                            onclick: () async {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => Profiles()),
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
