import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../../responsive.dart';

class RecruitLogIn extends StatefulWidget {
  final PageController controller;

  const RecruitLogIn({Key key, this.controller}) : super(key: key);
  @override
  _RecruitLogInState createState() => _RecruitLogInState();
}

class _RecruitLogInState extends State<RecruitLogIn> {

  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  final _scrollController = ScrollController();

  logIn() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
      pd.show(
          message: 'Vent gerne',
          type: SimpleFontelicoProgressDialogType.custom,
          loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
      );
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
          Map data = {
            'name': user[0]['name'],
            'surname': user[0]['surname'],
            'cpr': user[0]['cpr'],
            'experience': user[0]['experience'],
            'phone': user[0]['phone'],
            'email': user[0]['email'],
          };
          prefs.setString('data', jsonEncode(data));
          if(user[0]['complete']){
            ///onesignal
            if(!kIsWeb){
              OSDeviceState status = await OneSignal.shared.getDeviceState();
              String playerID = status.userId;
              await FirebaseFirestore.instance.collection('workers').doc(user[0].id).update({
                'playerID': playerID
              });
            }

            widget.controller.animateToPage(6,curve: Curves.ease,duration: Duration(milliseconds: 200));
          }
          else{
            widget.controller.animateToPage(2,curve: Curves.ease,duration: Duration(milliseconds: 200));
          }
        }
        else{
          pd.hide();
          ToastBar(text: 'Der blev ikke fundet nogen medarbejder til den e-mail', color: Colors.red).show();
        }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ToastBar(text: 'Ingen bruger fundet til den e-mail', color: Colors.red)
              .show();
        } else if (e.code == 'wrong-password') {
          ToastBar(text: 'Adgangskoden er forkert', color: Colors.red).show();
        }
        else if (e.code == 'invalid-email') {
          ToastBar(text: 'Indtast venligst e-mailadresse', color: Colors.red).show();
        }
        else{
          ToastBar(text: e.toString(), color: Colors.red).show();
        }
      }
      pd.hide();
    }
    else {
      ToastBar(text: 'Udfyld venligst alle felter', color: Colors.red).show();
    }
  }

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
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(65)),
                  child: Scrollbar(
                    isAlwaysShown: true,
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: ScreenUtil().setHeight(30),),
                          CustomText(text: 'Log ind på\nFindme',size: ScreenUtil().setSp(80),align: TextAlign.start,color: Color(0xff52575D),),
                          Center(
                            child: SizedBox(
                                width: isTablet?width*0.3:ScreenUtil().setHeight(1200),
                                height: isTablet?width*0.3:ScreenUtil().setWidth(800),
                                child: Image.asset('assets/images/login.png')),
                          ),

                          InputField(hint: 'Email',controller: email,type: TextInputType.emailAddress,),
                          InputField(hint: 'Adgangskode',ispassword: true,controller: password,),
                          SizedBox(height: ScreenUtil().setHeight(80),),
                          GestureDetector(
                              onTap: () async {
                                SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                                pd.show(
                                    message: 'Vent gerne',
                                    type: SimpleFontelicoProgressDialogType.custom,
                                    loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
                                );
                                try{
                                  if(email.text.isNotEmpty) {
                                    FirebaseAuth auth = FirebaseAuth.instance;
                                    await auth.sendPasswordResetEmail(email: email.text);
                                    pd.hide();
                                    ToastBar(text: 'Link til nulstilling af adgangskode sendt til din e-mail!',color: Colors.green).show();
                                  }
                                  else{
                                    pd.hide();
                                    ToastBar(text: 'Udfyld venligst e-mail',color: Colors.red).show();
                                  }
                                }
                                on FirebaseAuthException catch(e){
                                  if (e.code == 'user-not-found') {
                                    pd.hide();
                                    ToastBar(text: 'Ingen bruger fundet til den e-mail',color: Colors.red).show();
                                  }
                                  else{
                                    pd.hide();
                                    ToastBar(text: 'Noget gik galt!',color: Colors.red).show();
                                  }
                                }
                              },
                              child: CustomText(text: "glem kode",color: Theme.of(context).primaryColor,align: TextAlign.center, size: ScreenUtil().setSp(40),font: 'GoogleSans',)
                          ),
                          SizedBox(height: ScreenUtil().setHeight(70),),

                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                            child: Button(text: 'Log ind',padding: isTablet?width*0.025:10,onclick: ()=>logIn()),
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
