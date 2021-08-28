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
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../../responsive.dart';

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
  TextEditingController password = TextEditingController();
  int wordCount = 0;

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    double width = MediaQuery.of(context).size.width;
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
                    padding: EdgeInsets.all(ScreenUtil().setWidth(65)),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: ScreenUtil().setHeight(30),),
                          CustomText(text: 'Tilmeld dig nu',size: ScreenUtil().setSp(90),align: TextAlign.start,color: Color(0xff52575D)),
                          Center(
                            child: SizedBox(
                                width: isTablet?width*0.3:ScreenUtil().setHeight(600),
                                height: isTablet?width*0.3:ScreenUtil().setWidth(600),
                                child: Image.asset('assets/images/register.png')),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(40),),
                          InputField(hint: 'Navn',controller: name,),
                          InputField(hint: 'Efternavn',controller: surname),
                          InputField(hint: 'Email',controller: email,type: TextInputType.emailAddress,),
                          InputField(hint: 'Mobiltelefon',controller: phone,type: TextInputType.phone,),
                          InputField(hint: 'CPR',controller: cpr),
                          InputField(hint: 'Adgangskode',controller: password,ispassword: true,),
                          SizedBox(height: ScreenUtil().setHeight(80),),
                          TextField(
                            maxLines: null,
                            controller: experience,
                            style: TextStyle(fontFamily: 'ComicSans'),
                            decoration: InputDecoration(
                                labelText: 'Erfaring',
                                counterText: wordCount.toString(),
                                counterStyle: TextStyle(fontFamily: 'GoogleSans',fontWeight: FontWeight.bold),
                                labelStyle: TextStyle(color: Color(0xff52575D),fontWeight: FontWeight.bold),
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
                            child: Button(text: 'Næste',padding: isTablet?width*0.025:10,onclick: () async {
                              if(name.text.isNotEmpty && surname.text.isNotEmpty && cpr.text.isNotEmpty && experience.text.isNotEmpty && password.text.isNotEmpty){
                                SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                                pd.show(
                                    message: 'Please wait',
                                    type: SimpleFontelicoProgressDialogType.custom,
                                    loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
                                );
                                try {
                                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: email.text,
                                      password: password.text
                                  );

                                  await FirebaseFirestore.instance.collection('workers').doc(email.text).set({
                                    'name': name.text,
                                    'surname': surname.text,
                                    'cpr': cpr.text,
                                    'experience': experience.text,
                                    'phone': phone.text,
                                    'email': email.text,
                                    'complete': false
                                  });
                                  widget.controller.animateToPage(1,curve: Curves.ease,duration: Duration(milliseconds: 200));

                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    ToastBar(text: 'Password is too weak',color: Colors.red).show();
                                  } else if (e.code == 'email-already-in-use') {
                                    ToastBar(text: 'Account already exists',color: Colors.red).show();
                                  }
                                } catch (e) {
                                  print(e);
                                  ToastBar(text: 'Something went wrong',color: Colors.red).show();
                                }
                               pd.hide();
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
            SizedBox(height: ScreenUtil().setHeight(40),),
            Padding(
              padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(0),ScreenUtil().setWidth(50),ScreenUtil().setWidth(50),ScreenUtil().setWidth(60)),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                    onTap: (){
                      widget.controller.animateToPage(1,curve: Curves.ease,duration: Duration(milliseconds: 200));
                    },
                    child: CustomText(text: "Er du allerede tilmeldt? Log ind her",color: Colors.white, size: ScreenUtil().setSp(40),font: 'GoogleSans',)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
