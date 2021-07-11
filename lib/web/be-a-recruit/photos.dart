import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

class PhotosWeb extends StatefulWidget {
  final PageController controller;

  const PhotosWeb({Key key, this.controller}) : super(key: key);

  @override
  _PhotosWebState createState() => _PhotosWebState();
}

class _PhotosWebState extends State<PhotosWeb> {
  Uint8List profileImage, selfie;
  Future getImage(String type) async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera,imageQuality: 50);
     if (pickedFile != null) {
        if(type=='profile'){
          profileImage = await pickedFile.readAsBytes();
        }
        else{
          selfie = await pickedFile.readAsBytes();
        }
      }
     setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scrollbar(
      isAlwaysShown: true,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(width*0.05,width*0.04,width*0.1,0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(30),),
              CustomText(text: 'Billeder',size: ScreenUtil().setSp(100),align: TextAlign.start,color: Color(0xff52575D)),
              SizedBox(height: width*0.03,),

              ///pro pic
              GestureDetector(
                onTap: ()=>getImage('profile'),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ///header
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)
                              )
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width*0.01),
                            child: CustomText(text: 'Profilbillede',color: Colors.white,size: ScreenUtil().setSp(45),),
                          ),
                        ),
                      ),

                      ///image
                      Padding(
                        padding: EdgeInsets.all(width*0.02),
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 60,
                          backgroundImage: profileImage!=null?MemoryImage(profileImage):AssetImage('assets/images/avatar.png'),
                        ),
                      ),

                      ///text
                      CustomText(
                        text: 'Klik gerne her for at uploade din profilbillede',
                        font: 'GoogleSans',
                        size: ScreenUtil().setSp(40),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(60),)
                    ],
                  ),
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(60),),

              ///selfie
              GestureDetector(
                onTap: ()=>getImage('selfie'),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ///header
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)
                              )
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width*0.01),
                            child: CustomText(text: 'Selfe',color: Colors.white,size: ScreenUtil().setSp(45),),
                          ),
                        ),
                      ),

                      ///image
                      Padding(
                        padding: EdgeInsets.all(width*0.02),
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 60,
                          child: selfie!=null?Image.memory(selfie):Image.asset('assets/images/selfie.png'),
                        ),
                      ),

                      ///text
                      CustomText(
                        text: 'Klik gerne ger for at uploade selfie af dig',
                        font: 'GoogleSans',
                        size: ScreenUtil().setSp(40),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(60),)
                    ],
                  ),
                ),
              ),

              SizedBox(height: ScreenUtil().setHeight(120),),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20), vertical: ScreenUtil().setWidth(40)),
                child: Button(text: 'Næste',padding: width*0.01,color: Colors.red,onclick: () async {
                  if(profileImage!=null&&selfie!=null){
                    SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                    pd.show(
                        message: 'Please wait',
                        type: SimpleFontelicoProgressDialogType.custom,
                        loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
                    );
                    try{
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      Map data = jsonDecode(prefs.getString('data'));

                      String email = data['email'];

                      ///upload images
                      FirebaseStorage storage = FirebaseStorage.instance;
                      TaskSnapshot snap = await storage.ref('$email/profile.png').putData(profileImage);
                      String proPicUrl = await snap.ref.getDownloadURL();

                      TaskSnapshot snap2 = await storage.ref('$email/selfie.png').putData(selfie);
                      String selfieUrl = await snap2.ref.getDownloadURL();

                      data['profileImage'] = proPicUrl;
                      data['selfie'] = selfieUrl;
                      data['status'] = 'approved';
                      //todo: change approved to pending

                      ///onesignal
                      data['playerID'] = "";

                      ///add to db
                      await FirebaseFirestore.instance.collection('workers').doc(email).set(data);

                      ///send notification

                      pd.hide();
                      widget.controller.animateToPage(6,curve: Curves.ease,duration: Duration(milliseconds: 200));
                    }
                    catch(e){
                      pd.hide();
                      MessageDialog.show(
                        context: context,
                        text: 'Something went wrong!',
                      );
                    }
                  }
                  else{
                    MessageDialog.show(
                      context: context,
                      text: 'Please upload a profile picture and a selfie!',
                    );
                  }
                }
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
