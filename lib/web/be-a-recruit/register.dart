import 'dart:convert';

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

class RegisterWebWorker extends StatefulWidget {
  final PageController controller;

  const RegisterWebWorker({Key key, this.controller}) : super(key: key);
  @override
  _RegisterWebWorkerState createState() => _RegisterWebWorkerState();
}

class _RegisterWebWorkerState extends State<RegisterWebWorker> {
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
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.all(width*0.075),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(30),),
            CustomText(text: 'Tilmeld dig nu',size: ScreenUtil().setSp(80),align: TextAlign.start,color: Color(0xff52575D),),
            SizedBox(height: width*0.03,),
            InputField(hint: 'Name',controller: name,),
            InputField(hint: 'Surname',controller: surname),
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
              padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
              child: Button(
                text: 'Næste',
                onclick: () async {
                  if(name.text.isNotEmpty && surname.text.isNotEmpty && cpr.text.isNotEmpty && experience.text.isNotEmpty && password.text.isNotEmpty){
                    SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                    pd.show(
                        message: 'Please wait',
                        type: SimpleFontelicoProgressDialogType.custom,
                        loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
                    );
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    try {
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: email.text,
                          password: password.text
                      );
                      Map reg = {
                        'name': name.text,
                        'surname': surname.text,
                        'cpr': cpr.text,
                        'experience': experience.text,
                        'phone': phone.text,
                        'email': email.text
                      };
                      prefs.setString('data', jsonEncode(reg));
                      pd.hide();
                      widget.controller.animateToPage(1,curve: Curves.ease,duration: Duration(milliseconds: 200));

                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        pd.hide();
                        MessageDialog.show(
                          context: context,
                          text: 'The password provided is too weak',
                        );
                      } else if (e.code == 'email-already-in-use') {
                        pd.hide();
                        MessageDialog.show(
                          context: context,
                          text: 'The account already exists for that email',
                        );
                      }
                    } catch (e) {
                      pd.hide();
                      MessageDialog.show(
                        context: context,
                        text: 'Something went wrong',
                      );
                    }
                  }
                  else{
                    MessageDialog.show(
                      context: context,
                      text: 'Please fill all fields',
                    );
                  }
                },
                padding: width*0.01,
              ),
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    onTap: (){
                      widget.controller.animateToPage(1,curve: Curves.ease,duration: Duration(milliseconds: 200));
                    },
                    child: CustomText(text: "Er du allerede tilmeldt? Log ind her",color: Colors.black, size: ScreenUtil().setSp(40),font: 'GoogleSans',)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}