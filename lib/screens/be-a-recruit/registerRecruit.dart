import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecruitSignUp extends StatefulWidget {
  final PageController controller;

  const RecruitSignUp({Key key, this.controller}) : super(key: key);
  @override
  _RecruitSignUpState createState() => _RecruitSignUpState();
}

class _RecruitSignUpState extends State<RecruitSignUp> {

  TextEditingController name = TextEditingController();
  TextEditingController surname = TextEditingController();
  TextEditingController cpr = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  int wordCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
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
              padding: EdgeInsets.all(ScreenUtil().setWidth(65)),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    CustomText(text: 'Register your\naccount',size: ScreenUtil().setSp(90),align: TextAlign.start,color: Color(0xff52575D)),
                    Center(
                      child: SizedBox(
                          width: ScreenUtil().setHeight(600),
                          height: ScreenUtil().setWidth(600),
                          child: Image.asset('assets/images/register.png')),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(40),),
                    InputField(hint: 'Name',controller: name,),
                    InputField(hint: 'Surname',controller: surname),
                    InputField(hint: 'Contact Email',controller: email,type: TextInputType.emailAddress,),
                    InputField(hint: 'Mobile Phone',controller: phone,type: TextInputType.phone,),
                    InputField(hint: 'CPR Number',controller: cpr),
                    SizedBox(height: ScreenUtil().setHeight(80),),
                    TextField(
                      maxLines: null,
                      controller: experience,
                      style: TextStyle(fontFamily: 'GoogleSans'),
                      decoration: InputDecoration(
                          labelText: 'Experience (200 words min.)',
                          counterText: wordCount.toString(),
                          counterStyle: TextStyle(fontFamily: 'GoogleSans',fontWeight: FontWeight.bold),
                          labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 3
                              )
                          )
                      ),
                      onChanged: (text){
                        setState(() {
                          wordCount = text.split(' ').length;
                        });
                      },
                    ),
                    SizedBox(height: ScreenUtil().setHeight(40),),

                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                      child: Button(text: 'Next',onclick: () async {
                        if(wordCount<200){
                          ToastBar(text: 'Experience must be at least 200 words.',color: Colors.red).show();
                        }
                        else if(name.text.isNotEmpty && surname.text.isNotEmpty && cpr.text.isNotEmpty && experience.text.isNotEmpty){
                          ToastBar(text: 'Please wait...',color: Colors.orange).show();
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await FirebaseAuth.instance.signInAnonymously();
                          var sub = await FirebaseFirestore.instance.collection('workers').where('email', isEqualTo: email.text).get();
                          var user = sub.docs;

                          if(user.isEmpty){
                            Map reg = {
                              'name': name.text,
                              'surname': surname.text,
                              'cpr': cpr.text,
                              'experience': experience.text,
                              'phone': phone.text,
                              'email': email.text
                            };
                            prefs.setString('data', jsonEncode(reg));
                            widget.controller.animateToPage(1,curve: Curves.ease,duration: Duration(milliseconds: 200));
                          }
                          else{
                            prefs.setString('data', jsonEncode({'email': email.text}));
                            widget.controller.animateToPage(5,curve: Curves.ease,duration: Duration(milliseconds: 200));
                          }
                        }
                        else{
                          ToastBar(text: 'Please fill all fields',color: Colors.red).show();
                        }
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
