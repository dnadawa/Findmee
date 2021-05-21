import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/screens/book-a-recruit/sign-up.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      ToastBar(text: 'Please wait', color: Colors.orange).show();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('companyEmail', email.text);

        widget.controller.animateToPage(1,curve: Curves.ease,duration: Duration(milliseconds: 200));

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ToastBar(text: 'No user found for that email', color: Colors.red)
              .show();
        } else if (e.code == 'wrong-password') {
          ToastBar(text: 'Password incorrect', color: Colors.red).show();
        }
      }
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
                          CustomText(text: 'Log into your\naccount',size: ScreenUtil().setSp(60),align: TextAlign.start,),
                          Center(
                            child: SizedBox(
                                width: ScreenUtil().setHeight(300),
                                height: ScreenUtil().setWidth(300),
                                child: Image.asset('assets/images/login.jpg')),
                          ),

                          InputField(hint: 'Email',controller: email,type: TextInputType.emailAddress,),
                          InputField(hint: 'Password',ispassword: true,controller: password,),
                          SizedBox(height: ScreenUtil().setHeight(40),),

                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                            child: Button(text: 'Log in',onclick: ()=>logIn()),
                          )

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(50)),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: CustomText(text: "Don't you have an account? Sign Up",color: Colors.white, size: ScreenUtil().setSp(40),font: 'GoogleSans',)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
