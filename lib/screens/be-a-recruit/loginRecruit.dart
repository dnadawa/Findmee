import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecruitLogIn extends StatefulWidget {
  final PageController controller;

  const RecruitLogIn({Key key, this.controller}) : super(key: key);
  @override
  _RecruitLogInState createState() => _RecruitLogInState();
}

class _RecruitLogInState extends State<RecruitLogIn> {

  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();

  logIn() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      ToastBar(text: 'Please wait', color: Colors.orange).show();
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text, password: password.text);

        var sub = await FirebaseFirestore.instance
            .collection('workers')
            .where('email', isEqualTo: email.text)
            .get();
        var user = sub.docs;

        if(user.isNotEmpty){
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('data', jsonEncode({'email': email.text}));
          widget.controller.animateToPage(6,curve: Curves.ease,duration: Duration(milliseconds: 200));
        }
        else{
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
    }
    else {
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
                        CustomText(text: 'Log into your\naccount',size: ScreenUtil().setSp(80),align: TextAlign.start,color: Color(0xff52575D),),
                        Center(
                          child: SizedBox(
                              width: ScreenUtil().setHeight(1200),
                              height: ScreenUtil().setWidth(800),
                              child: Image.asset('assets/images/login.png')),
                        ),

                        InputField(hint: 'Email',controller: email,type: TextInputType.emailAddress,),
                        InputField(hint: 'Password',ispassword: true,controller: password,),
                        SizedBox(height: ScreenUtil().setHeight(70),),

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
            SizedBox(height: ScreenUtil().setHeight(40),),
            Padding(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(0),ScreenUtil().setWidth(50),ScreenUtil().setWidth(50),ScreenUtil().setWidth(60)),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                    onTap: (){
                      widget.controller.animateToPage(0,curve: Curves.ease,duration: Duration(milliseconds: 200));
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
