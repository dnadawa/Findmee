import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class LoginWebWorker extends StatefulWidget {
  final PageController controller;

  const LoginWebWorker({Key key, this.controller}) : super(key: key);
  @override
  _LoginWebWorkerState createState() => _LoginWebWorkerState();
}

class _LoginWebWorkerState extends State<LoginWebWorker> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _scrollController = ScrollController();

  logIn() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
      pd.show(
          message: 'Vent venligst',
          type: SimpleFontelicoProgressDialogType.custom,
          loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
      );
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text.trim(), password: password.text.trim());

        var sub = await FirebaseFirestore.instance
            .collection('workers')
            .where('email', isEqualTo: email.text.trim())
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
            ///notifications

            pd.hide();
            widget.controller.animateToPage(6,curve: Curves.ease,duration: Duration(milliseconds: 200));
          }
          else{
            pd.hide();
            widget.controller.animateToPage(2,curve: Curves.ease,duration: Duration(milliseconds: 200));
          }
        }
        else{
          pd.hide();
          MessageDialog.show(
            context: context,
            text: 'Der blev ikke fundet nogen medarbejder til den e-mail',
          );
        }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          pd.hide();
          MessageDialog.show(
            context: context,
            text: 'Der blev ikke fundet nogen medarbejder til den e-mail',
          );
        } else if (e.code == 'wrong-password') {
          pd.hide();
          MessageDialog.show(
            context: context,
            text: 'Adgangskoden er forkert',
          );
        }
        else if (e.code == 'invalid-email') {
          pd.hide();
          MessageDialog.show(
            context: context,
            text: 'Indtast venligst e-mailadresse',
          );
        }
        else{
          pd.hide();
          MessageDialog.show(
            context: context,
            text: e.toString(),
          );
        }
      }
    }
    else {
      MessageDialog.show(
        text: 'Udfyld venligst alle felter',
        context: context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scrollbar(
      isAlwaysShown: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(width*0.05,width*0.075,width*0.1,width*0.075),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(30),),
              CustomText(text: 'Log ind p??\nFindme',size: ScreenUtil().setSp(100),align: TextAlign.start,color: Color(0xff52575D),),
              SizedBox(height: width*0.03,),

              InputField(hint: 'Email',controller: email,type: TextInputType.emailAddress,),
              InputField(hint: 'Adgangskode',ispassword: true,controller: password,),
              SizedBox(height: ScreenUtil().setHeight(100),),
              MouseRegion(
                child: GestureDetector(
                    onTap: () async {
                      SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                      pd.show(
                          message: 'Vent venligst',
                          type: SimpleFontelicoProgressDialogType.custom,
                          loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
                      );
                      try{
                        if(email.text.isNotEmpty) {
                          FirebaseAuth auth = FirebaseAuth.instance;
                          await auth.sendPasswordResetEmail(email: email.text.trim());
                          pd.hide();
                          MessageDialog.show(context: context, text: 'Link til nulstilling af adgangskode sendt til din e-mail!', type: CoolAlertType.success);
                        }
                        else{
                          pd.hide();
                          MessageDialog.show(context: context, text: 'Udfyld venligst e-mail');
                        }
                      }
                      on FirebaseAuthException catch(e){
                        if (e.code == 'user-not-found') {
                          pd.hide();
                          MessageDialog.show(context: context, text: 'Ingen bruger fundet til den e-mail');
                        }
                        else{
                          pd.hide();
                          MessageDialog.show(context: context, text: 'Noget gik galt!');
                        }
                      }
                    },
                    child: CustomText(text: "Glemt kode",color: Theme.of(context).primaryColor,align: TextAlign.center, size: ScreenUtil().setSp(50),font: 'GoogleSans',)
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(70),),

              Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20), vertical: ScreenUtil().setWidth(60)),
                  child: Button(
                    text: 'Log ind',
                    color: Colors.red,
                    padding: width*0.013,
                    onclick: ()=>logIn(),
                  )
              ),


              SizedBox(height: width*0.09,),
              Align(
                alignment: Alignment.bottomLeft,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                      onTap: (){
                        widget.controller.animateToPage(0,curve: Curves.ease,duration: Duration(milliseconds: 200));
                      },
                      child: CustomText(text: "Har du ikke allerede en konto? Tilmeld dig nu.",color: Theme.of(context).primaryColor, size: ScreenUtil().setSp(50),font: 'GoogleSans',)),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
