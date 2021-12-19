import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.fromLTRB(width*0.05,width*0.04,width*0.1,0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: ScreenUtil().setHeight(30),),
          CustomText(text: 'Tilmeld dig nu',size: ScreenUtil().setSp(100),align: TextAlign.start,color: Color(0xff52575D),),
          SizedBox(height: height*0.03,),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              controller: _scrollController,
              child: ListView(
                controller: _scrollController,
                children: [
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
                ],
              ),
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(30),),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20), vertical: ScreenUtil().setWidth(20)),
            child: Button(
              text: 'Næste',
              color: Colors.red,
              padding: width*0.013,
              onclick: () async {
                if(name.text.isNotEmpty && surname.text.isNotEmpty && experience.text.isNotEmpty && password.text.isNotEmpty){
                  SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                  pd.show(
                      message: 'Vent venligst',
                      type: SimpleFontelicoProgressDialogType.custom,
                      loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
                  );
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email.text.trim(),
                        password: password.text.trim()
                    );
                    await FirebaseFirestore.instance.collection('workers').doc(email.text.trim()).set({
                      'name': name.text.trim(),
                      'surname': surname.text.trim(),
                      'cpr': cpr.text.trim(),
                      'experience': experience.text.trim(),
                      'phone': phone.text.trim(),
                      'email': email.text.trim(),
                      'complete': false
                    });
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
                  } catch (e) {
                    pd.hide();
                    MessageDialog.show(
                      context: context,
                      text: 'Noget gik galt',
                    );
                  }
                }
                else{
                  MessageDialog.show(
                    context: context,
                    text: 'Udfyld venligst alle felter',
                  );
                }
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(80)),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    onTap: (){
                      widget.controller.animateToPage(1,curve: Curves.ease,duration: Duration(milliseconds: 200));
                    },
                    child: CustomText(text: "Er du allerede tilmeldt? Log ind her",color: Theme.of(context).primaryColor, size: ScreenUtil().setSp(50),font: 'GoogleSans',)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
