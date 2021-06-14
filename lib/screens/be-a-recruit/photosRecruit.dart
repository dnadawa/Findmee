import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../email.dart';

class Photos extends StatefulWidget {
  final PageController controller;

  const Photos({Key key, this.controller}) : super(key: key);
  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {

  File profileImage , selfie;
  Future getImage(String type) async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery,imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        if(type=='profile'){
          profileImage = File(pickedFile.path);
        }
        else{
          selfie = File(pickedFile.path);
        }
      } else {
        ToastBar(text: 'No image selected',color: Colors.red).show();
      }
    });
  }

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
              padding: EdgeInsets.all(ScreenUtil().setWidth(65)),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    CustomText(text: 'Photos',size: ScreenUtil().setSp(90),align: TextAlign.start,color: Color(0xff52575D)),
                    SizedBox(height: ScreenUtil().setHeight(70),),

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
                                  padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                                  child: CustomText(text: 'Profile Picture',color: Colors.white,size: ScreenUtil().setSp(45),),
                                ),
                              ),
                            ),

                            ///image
                            Padding(
                              padding: EdgeInsets.all(ScreenUtil().setWidth(80)),
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 60,
                                backgroundImage: profileImage!=null?FileImage(profileImage):AssetImage('assets/images/avatar.png'),
                              ),
                            ),

                            ///text
                            CustomText(
                              text: 'Click here to upload your profile picture',
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
                                  padding: EdgeInsets.all(ScreenUtil().setWidth(30)),
                                  child: CustomText(text: 'Selfie',color: Colors.white,size: ScreenUtil().setSp(45),),
                                ),
                              ),
                            ),

                            ///image
                            Padding(
                              padding: EdgeInsets.all(ScreenUtil().setWidth(80)),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 60,
                                child: selfie!=null?Image.file(selfie):Image.asset('assets/images/selfie.png'),
                              ),
                            ),

                            ///text
                            CustomText(
                              text: 'Click here to upload a selfie of yours',
                              font: 'GoogleSans',
                              size: ScreenUtil().setSp(40),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(60),)
                          ],
                        ),
                      ),
                    ),


                    SizedBox(height: ScreenUtil().setHeight(40),),

                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                      child: Button(text: 'Next',onclick: () async {
                        if(profileImage!=null&&selfie!=null){
                          ToastBar(text: 'Please wait...',color: Colors.orange).show();
                          try{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            Map data = jsonDecode(prefs.getString('data'));

                            String email = data['email'];

                            ///upload images
                            ToastBar(text: 'Uploading profile picture...',color: Colors.orange).show();
                            FirebaseStorage storage = FirebaseStorage.instance;
                            TaskSnapshot snap = await storage.ref('$email/profile.png').putFile(profileImage);
                            String proPicUrl = await snap.ref.getDownloadURL();

                            ToastBar(text: 'Uploading selfie...',color: Colors.orange).show();
                            TaskSnapshot snap2 = await storage.ref('$email/selfie.png').putFile(selfie);
                            String selfieUrl = await snap2.ref.getDownloadURL();

                            data['profileImage'] = proPicUrl;
                            data['selfie'] = selfieUrl;
                            data['status'] = 'pending';

                            ///onesignal
                            OSDeviceState status = await OneSignal.shared.getDeviceState();
                            String playerID = status.userId;
                            data['playerID'] = playerID;


                            print(data);

                            ///add to db
                            await FirebaseFirestore.instance.collection('workers').doc(email).set(data);

                            ToastBar(text: 'Sending notifications...',color: Colors.orange).show();
                            ///send notification
                            OneSignal.shared.postNotification(
                                OSCreateNotification(
                                    playerIds: [playerID],
                                    content: 'Findmee has received your details, please wait to be approved from team'
                                )
                            );

                            await Email.sendEmail('Findmee has received your details, please wait to be approved from team','Welcome to Findmee', to: email);

                            widget.controller.animateToPage(6,curve: Curves.ease,duration: Duration(milliseconds: 200));
                          }
                          catch(e){
                            print(e.toString());
                            ToastBar(text: 'Something went wrong!',color: Colors.red).show();
                          }
                        }
                        else{
                          ToastBar(text: 'Please upload a profile picture and a selfie!',color: Colors.red).show();
                        }
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
