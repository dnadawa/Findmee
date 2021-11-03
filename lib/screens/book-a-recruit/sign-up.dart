import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/email.dart';
import 'package:findmee/responsive.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/inputfield.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SignUp extends StatefulWidget {
  final PageController controller;

  const SignUp({Key key, this.controller}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController businessName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController cvr = TextEditingController();
  TextEditingController password = TextEditingController();

  signUp() async {
    if(businessName.text.isNotEmpty && phone.text.isNotEmpty && cvr.text.isNotEmpty &&  email.text.isNotEmpty &&password.text.isNotEmpty){
      SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
      pd.show(
          message: 'Please wait',
          type: SimpleFontelicoProgressDialogType.custom,
          loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
      );
      ///auth
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email.text.trim(),
            password: password.text.trim()
        );

        ///onesignal
        String playerID = "";
        if(!kIsWeb){
          OSDeviceState status = await OneSignal.shared.getDeviceState();
          playerID = status.userId;
        }

        ///save details
        await FirebaseFirestore.instance.collection('companies').doc(email.text.trim()).set({
          'name': businessName.text.trim(),
          'email': email.text.trim(),
          'phone': phone.text.trim(),
          'cvr': cvr.text.trim(),
          'status': 'approved',
          'playerID': playerID
        });

        ///send notification
        if(!kIsWeb) {
          OneSignal.shared.postNotification(
              OSCreateNotification(
                  playerIds: [playerID],
                  content: 'Findmee has received your details.'
              )
          );
        }
        await CustomEmail.sendEmail(
            'Tak fordi du har oprettet en bruger hos os!\n\nVi ser frem til et stærkt og professionelt fremadrettet samarbejde med jer og den rette vikarservice. ',
            'Velkommen til FindMe', to: email.text.trim());

        await CustomEmail.sendEmail(
            'A new user has registered.',
            'User Registered');
        pd.hide();
        ToastBar(text: 'User registered!',color: Colors.green).show();
        widget.controller.animateToPage(1,curve: Curves.ease,duration: Duration(milliseconds: 200));

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ToastBar(text: 'The password provided is too weak',color: Colors.red).show();
        } else if (e.code == 'email-already-in-use') {
          ToastBar(text: 'The account already exists for that email',color: Colors.red).show();
        }
        else if (e.code == 'invalid-email') {
          ToastBar(text: 'Please enter a email address', color: Colors.red).show();
        }
        else{
          ToastBar(text: e.toString(), color: Colors.red).show();
        }
      } catch (e) {
        print(e.toString());
        ToastBar(text: e.toString(),color: Colors.red).show();
      }
      pd.hide();
    }
    else{
      ToastBar(text: 'Please fill all fields',color: Colors.red).show();
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
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(65)),
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: ScreenUtil().setHeight(30),),
                          CustomText(text: 'Tilmeld dig nu',size: ScreenUtil().setSp(80),align: TextAlign.start,color: Color(0xff52575D),),
                          Center(
                            child: SizedBox(
                                width: isTablet?width*0.3:ScreenUtil().setHeight(600),
                                height: isTablet?width*0.3:ScreenUtil().setWidth(600),
                                child: Image.asset('assets/images/register.png')),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(40),),
                          InputField(hint: 'Firmanavn',controller: businessName,),
                          InputField(hint: 'Email',controller: email,type: TextInputType.emailAddress,),
                          InputField(hint: 'Mobiltelefon',type: TextInputType.phone,controller: phone),
                          InputField(hint: 'CVR',controller: cvr,),
                          InputField(hint: 'Adgangskode',ispassword: true,controller: password,),
                          SizedBox(height: ScreenUtil().setHeight(40),),

                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                            child: Button(text: 'Tilmeld',padding: isTablet?width*0.025:10,onclick: ()=>signUp()),
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
                      widget.controller.animateToPage(1,curve: Curves.ease,duration: Duration(milliseconds: 200));
                    },
                    child: CustomText(text: "Er du allerede tilmeldt? Log ind her",color: Colors.white, size: ScreenUtil().setSp(40),font: 'GoogleSans',)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
