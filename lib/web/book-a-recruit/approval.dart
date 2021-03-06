import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/web/book-a-recruit/profiles.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../email.dart';

class ApprovalWeb extends StatefulWidget {
  @override
  _ApprovalWebState createState() => _ApprovalWebState();
}

class _ApprovalWebState extends State<ApprovalWeb> {

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

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomText(
                    text: 'Tak for oprettelsen hos FindMe. Din profil er nu under behandling og du ville snarest hører fra vores team!',
                    font: 'ComicSans',
                    size: ScreenUtil().setSp(60),
                    isBold: false,
                  ),
                ),

                Padding(
                    padding: EdgeInsets.all(width*0.03),
                    child: Button(
                      text: 'Næste',
                      padding: width*0.01,
                      onclick: () async {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => ProfilesWeb()),
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
