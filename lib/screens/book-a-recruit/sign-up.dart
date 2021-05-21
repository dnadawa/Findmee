import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController businessName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController cvr = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController username = TextEditingController();

  signUp() async {
    if(businessName.text.isNotEmpty && phone.text.isNotEmpty && email.text.isNotEmpty &&password.text.isNotEmpty && cvr.text.isNotEmpty && username.text.isNotEmpty){
      ToastBar(text: 'Please wait',color: Colors.orange).show();
      ///auth
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.text,
            password: password.text
        );

        ///save details
        await FirebaseFirestore.instance.collection('companies').doc(email.text).set({
          'name': businessName.text,
          'email': email.text,
          'phone': phone.text,
          'cvr': cvr.text,
          'username': username.text,
        });

        ToastBar(text: 'User registered!',color: Colors.green).show();
        Navigator.pop(context);

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ToastBar(text: 'The password provided is too weak',color: Colors.red).show();
        } else if (e.code == 'email-already-in-use') {
          ToastBar(text: 'The account already exists for that email',color: Colors.red).show();
        }
      } catch (e) {
        ToastBar(text: 'Something went wrong',color: Colors.red).show();
      }
    }
    else{
      ToastBar(text: 'Please fill all fields',color: Colors.red).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
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
                          InputField(hint: 'Business Name',controller: businessName,),
                          InputField(hint: 'Contact email',controller: email,type: TextInputType.emailAddress,),
                          InputField(hint: 'Mobile Phone',type: TextInputType.phone,controller: phone),
                          InputField(hint: 'CVR Number',controller: cvr,),
                          InputField(hint: 'Username',controller: username,),
                          InputField(hint: 'Password',ispassword: true,controller: password,),
                          SizedBox(height: ScreenUtil().setHeight(40),),

                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                            child: Button(text: 'Register',onclick: ()=>signUp()),
                          )

                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(50)),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: CustomText(text: "Do you have an account? Log in",color: Colors.white, size: ScreenUtil().setSp(40),font: 'GoogleSans',)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
