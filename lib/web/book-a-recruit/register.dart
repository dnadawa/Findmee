import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:findmee/widgets/toast.dart';
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
  TextEditingController username = TextEditingController();

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
            InputField(hint: 'Fimanavn',controller: businessName,),
            InputField(hint: 'Email',controller: email,type: TextInputType.emailAddress,),
            InputField(hint: 'Mobiltelefon',type: TextInputType.phone,controller: phone),
            InputField(hint: 'CVR',controller: cvr,),
            InputField(hint: 'Brugernavn',controller: username,),
            InputField(hint: 'Adgangskode',ispassword: true,controller: password,),
            SizedBox(height: ScreenUtil().setHeight(40),),

            Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(40)),
              child: Button(
                text: 'Tilmeld',
                onclick: ()=>widget.controller.animateToPage(1,curve: Curves.ease,duration: Duration(milliseconds: 200)),
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
