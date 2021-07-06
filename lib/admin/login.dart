import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/admin/home.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../responsive.dart';

class AdminLogin extends StatefulWidget {
  @override
  _AdminLoginState createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width;
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    if(isMobile){
      width = MediaQuery.of(context).size.width*2;
    }
    else{
      width = MediaQuery.of(context).size.width;
    }

    return Scaffold(
      backgroundColor: Color(0xffFA1E0E).withOpacity(0.05),
      body: Column(
        children: [
          ///logo
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                height: isMobile?width*0.1:isTablet?width*0.15:width*0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                  color: Theme.of(context).primaryColor,
                ),
                child: Image.asset('assets/images/logo.png')
            ),
          ),

          Expanded(child: Container()),
          Container(
            width: width*0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white
            ),
            child: Column(
              children: [
                ///header
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    color: Theme.of(context).primaryColor
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(width*0.01),
                    child: CustomText(
                      text: 'Login',
                      color: Colors.white,
                      size: width*0.03,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width*0.02, vertical: width*0.01),
                  child: InputField(
                    hint: 'Email',
                    controller: email,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width*0.02),
                  child: InputField(
                    hint: 'Password',
                    controller: password,
                    ispassword: true,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(width*0.03),
                  child: Button(
                    text: 'Log ind',
                    color: Colors.red,
                    padding: width*0.012,
                    onclick: () async {
                      if(email.text.isEmpty && password.text.isEmpty){
                        MessageDialog.show(
                            context: context,
                            text: 'Please fill all fields',
                        );
                      }
                      else{
                        SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                        pd.show(
                            message: 'Please wait',
                            hideText: true
                        );
                        try {
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                              email: email.text,
                              password: password.text
                          );
                          var sub = await FirebaseFirestore.instance.collection('admin').where('email', isEqualTo: email.text).get();
                          var admin = sub.docs;
                          if(admin.isNotEmpty){
                            pd.hide();
                            Navigator.push(
                              context,
                              CupertinoPageRoute(builder: (context) => AdminHome()),
                            );
                          }
                          else{
                            throw FirebaseAuthException(code: 'user-not-found');
                          }

                        } on FirebaseAuthException catch (e) {
                          pd.hide();
                          if (e.code == 'user-not-found') {
                            MessageDialog.show(
                                context: context,
                                text: 'No user found',
                            );
                          } else if (e.code == 'wrong-password') {
                            MessageDialog.show(
                                context: context,
                                text: 'Password is wrong',
                            );
                          }
                        }
                      }
                    },
                  ),
                ),

              ],
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
