import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class LogIn extends StatefulWidget {
  final PageController controller;

  const LogIn({Key key, this.controller}) : super(key: key);
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  logIn() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
      pd.show(
        message: 'Please wait',
        type: SimpleFontelicoProgressDialogType.custom,
        loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
      );
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text, password: password.text);

        var sub = await FirebaseFirestore.instance
            .collection('companies')
            .where('email', isEqualTo: email.text)
            .get();
        var user = sub.docs;

        if(user[0]['status'] == 'ban'){
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  insetPadding: EdgeInsets.symmetric(vertical: 24,horizontal: 10),
                  scrollable: true,
                  backgroundColor: Colors.white,
                  content: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        ///banned image
                        Container(
                          width: ScreenUtil().setHeight(500),
                          height: ScreenUtil().setHeight(500),
                          child: Image.asset('assets/images/banned.png'),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(100),),

                        ///text
                        CustomText(
                          text: 'Your Account is Banned',
                          font: 'ComicSans',
                          size: ScreenUtil().setSp(55),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(100),),

                        ///buttons
                        Button(
                          text: 'Create a new account',
                          onclick: (){
                            Navigator.pop(context);
                            widget.controller.animateToPage(0,curve: Curves.ease,duration: Duration(milliseconds: 200));
                          },
                        )
                      ],
                    ),
                  ),
                );
          });
        }
        else if(user[0]['status'] == 'pending'){
          showDialog(
              context: context,
              builder: (BuildContext context){
                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  insetPadding: EdgeInsets.symmetric(vertical: 24,horizontal: 10),
                  scrollable: true,
                  backgroundColor: Colors.white,
                  content: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        ///pending logo
                        Container(
                          width: ScreenUtil().setHeight(500),
                          height: ScreenUtil().setHeight(500),
                          child: Image.asset('assets/images/waiting.png'),
                        ),
                        SizedBox(height: ScreenUtil().setWidth(100),),

                        ///text
                        CustomText(
                          text: 'Waiting for Approval',
                          font: 'ComicSans',
                          size: ScreenUtil().setSp(55),
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
        else{
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('companyEmail', email.text);

          ///onesignal
          OSDeviceState status = await OneSignal.shared.getDeviceState();
          String playerID = status.userId;
          await FirebaseFirestore.instance.collection('companies').doc(user[0].id).update({
            'playerID': playerID
          });

          widget.controller.animateToPage(2,curve: Curves.ease,duration: Duration(milliseconds: 200));
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ToastBar(text: 'No user found for that email', color: Colors.red)
              .show();
        } else if (e.code == 'wrong-password') {
          ToastBar(text: 'Password incorrect', color: Colors.red).show();
        }
      }
      pd.hide();
    } else {
      ToastBar(text: 'Please fill all fields', color: Colors.red).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(40),ScreenUtil().setWidth(40),ScreenUtil().setWidth(40),0),
        child: Column(
          children: [
            Expanded(
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
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: ScreenUtil().setHeight(30),),
                        CustomText(text: 'Log ind på\nFindme',size: ScreenUtil().setSp(80),align: TextAlign.start,color: Color(0xff52575D),),
                        Center(
                          child: SizedBox(
                              width: ScreenUtil().setHeight(1200),
                              height: ScreenUtil().setWidth(800),
                              child: Image.asset('assets/images/login.png')),
                        ),

                        InputField(hint: 'Email',controller: email,type: TextInputType.emailAddress,),
                        InputField(hint: 'Adgangskode',ispassword: true,controller: password,),
                        SizedBox(height: ScreenUtil().setHeight(70),),

                        Padding(
                          padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                          child: Button(text: 'Log ind',onclick: ()=>logIn()),
                        )

                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(40),),
            Padding(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(0),ScreenUtil().setWidth(50),ScreenUtil().setWidth(50),ScreenUtil().setWidth(60)),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                    onTap: (){
                      widget.controller.animateToPage(0,curve: Curves.ease,duration: Duration(milliseconds: 200));
                    },
                    child: CustomText(text: "Har du ikke allerede en konto? Tilmeld dig nu.",color: Colors.white, size: ScreenUtil().setSp(40),font: 'GoogleSans',)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
