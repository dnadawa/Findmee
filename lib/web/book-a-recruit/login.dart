import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginWebCompany extends StatefulWidget {
  final PageController controller;

  const LoginWebCompany({Key key, this.controller}) : super(key: key);
  @override
  _LoginWebCompanyState createState() => _LoginWebCompanyState();
}

class _LoginWebCompanyState extends State<LoginWebCompany> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
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
            CustomText(text: 'Log ind på\nFindme',size: ScreenUtil().setSp(80),align: TextAlign.start,color: Color(0xff52575D),),
            SizedBox(height: width*0.03,),

            InputField(hint: 'Email',controller: email,type: TextInputType.emailAddress,),
            InputField(hint: 'Adgangskode',ispassword: true,controller: password,),
            SizedBox(height: ScreenUtil().setHeight(70),),

            Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
              child: Button(
                text: 'Log ind',
                padding: width*0.01,
                onclick: ()=>widget.controller.animateToPage(2,curve: Curves.ease,duration: Duration(milliseconds: 200)),
            )
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                    onTap: (){
                      widget.controller.animateToPage(0,curve: Curves.ease,duration: Duration(milliseconds: 200));
                    },
                    child: CustomText(text: "Har du ikke allerede en konto? Tilmeld dig nu.",color: Colors.black, size: ScreenUtil().setSp(40),font: 'GoogleSans',)),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
