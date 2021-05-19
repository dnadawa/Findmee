import 'package:findmee/screens/be-a-recruit/stepperRecruit.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  int wordCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(45)),
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
              padding: EdgeInsets.all(ScreenUtil().setWidth(45)),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    CustomText(text: 'Register your account',size: ScreenUtil().setSp(60),align: TextAlign.start,),
                    Center(
                      child: SizedBox(
                          width: ScreenUtil().setHeight(300),
                          height: ScreenUtil().setWidth(300),
                          child: Image.asset('assets/images/register.jpg')),
                    ),
                    InputField(hint: 'Name',controller: name,),
                    InputField(hint: 'Surname',controller: surname),
                    InputField(hint: 'CPR Number',controller: cpr),
                    SizedBox(height: ScreenUtil().setHeight(80),),
                    TextField(
                      maxLines: null,
                      controller: experience,
                      style: TextStyle(fontFamily: 'GoogleSans'),
                      decoration: InputDecoration(
                          labelText: 'Experience',
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
                        widget.controller.animateToPage(1,curve: Curves.ease,duration: Duration(milliseconds: 200));
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
