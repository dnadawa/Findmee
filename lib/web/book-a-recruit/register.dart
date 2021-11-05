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

import '../../email.dart';

class RegisterWebCompany extends StatefulWidget {
  final PageController controller;

  const RegisterWebCompany({Key key, this.controller}) : super(key: key);
  @override
  _RegisterWebCompanyState createState() => _RegisterWebCompanyState();
}

class _RegisterWebCompanyState extends State<RegisterWebCompany> {
  TextEditingController businessName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController cvr = TextEditingController();
  TextEditingController password = TextEditingController();
  final _scrollController = ScrollController();

  signUp() async {
    if(businessName.text.isNotEmpty && phone.text.isNotEmpty && cvr.text.isNotEmpty && email.text.isNotEmpty &&password.text.isNotEmpty){
      SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
      pd.show(
          message: 'Vent gerne',
          type: SimpleFontelicoProgressDialogType.custom,
          loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
      );
      ///auth
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim()
        );

        ///save details
        await FirebaseFirestore.instance.collection('companies').doc(email.text.trim()).set({
          'name': businessName.text.trim(),
          'email': email.text.trim(),
          'phone': phone.text.trim(),
          'cvr': cvr.text.trim(),
          'status': 'approved',
          'playerID': ''
        });

        ///send notification
        await CustomEmail.sendEmail(
            'Tak fordi du har oprettet en bruger hos os!\n\nVi ser frem til et stærkt og professionelt fremadrettet samarbejde med jer og den rette vikarservice. ',
            'Velkommen til FindMe', to: email.text.trim());
        await CustomEmail.sendEmail(
            'En ny bruger er registreret.',
            'Bruger registreret');
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
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scrollbar(
      isAlwaysShown: true,
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: EdgeInsets.fromLTRB(width*0.05,height*0.12,width*0.1,height*0.010),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(30),),
              CustomText(text: 'Tilmeld dig nu',size: ScreenUtil().setSp(100),align: TextAlign.start,color: Color(0xff52575D),isBold: true,),
              SizedBox(height: width*0.03,),
              InputField(hint: 'Firmanavn',controller: businessName,),
              InputField(hint: 'Email',controller: email,type: TextInputType.emailAddress,),
              InputField(hint: 'Mobiltelefon',type: TextInputType.phone,controller: phone),
              InputField(hint: 'CVR',controller: cvr,),
              InputField(hint: 'Adgangskode',ispassword: true,controller: password,),
              SizedBox(height: ScreenUtil().setHeight(40),),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20), vertical: ScreenUtil().setWidth(40)),
                child: Button(
                  text: 'Tilmeld',
                  onclick: ()=>signUp(),
                  color: Colors.red,
                  padding: width*0.013,
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
                      child: CustomText(text: "Er du allerede tilmeldt? Log ind her",color: Theme.of(context).primaryColor, size: ScreenUtil().setSp(50),font: 'GoogleSans',)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
