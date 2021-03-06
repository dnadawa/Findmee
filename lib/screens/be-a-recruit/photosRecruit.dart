import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../../email.dart';
import '../../responsive.dart';

class Photos extends StatefulWidget {
  final PageController controller;

  const Photos({Key key, this.controller}) : super(key: key);
  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {

  File profileImage , selfie;
  final _scrollController = ScrollController();
  Future getImage(String type) async {
    final pickedFile = await ImagePicker().getImage(source: type=='profile'?ImageSource.gallery:ImageSource.camera,imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        if(type=='profile'){
          profileImage = File(pickedFile.path);
        }
        else{
          selfie = File(pickedFile.path);
        }
      } else {
        ToastBar(text: 'Intet billede valgt',color: Colors.red).show();
      }
    });
  }

  Uint8List profileImageData, selfieData;
  Future getImageWeb(String type) async {
    final pickedFile = await ImagePicker().getImage(source: type=='profile'?ImageSource.gallery:ImageSource.camera,imageQuality: 50);
    if (pickedFile != null) {
      if(type=='profile'){
        profileImageData = await pickedFile.readAsBytes();
      }
      else{
        selfieData = await pickedFile.readAsBytes();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    double width = MediaQuery.of(context).size.width;
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
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: ScreenUtil().setHeight(30),),
                      CustomText(text: 'Billeder',size: ScreenUtil().setSp(90),align: TextAlign.start,color: Color(0xff52575D)),
                      SizedBox(height: ScreenUtil().setHeight(70),),

                      ///pro pic
                      GestureDetector(
                        onTap: ()=>kIsWeb?getImageWeb('profile'):getImage('profile'),
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
                                    child: CustomText(text: 'Profilbillede',color: Colors.white,size: ScreenUtil().setSp(45),),
                                  ),
                                ),
                              ),

                              ///image
                              Padding(
                                padding: EdgeInsets.all(ScreenUtil().setWidth(80)),
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 60,
                                  backgroundImage: profileImage!=null||profileImageData!=null
                                      ?
                                  kIsWeb?MemoryImage(profileImageData):FileImage(profileImage)
                                      :
                                  AssetImage('assets/images/avatar.png'),
                                ),
                              ),

                              ///text
                              CustomText(
                                text: 'Vedh??ft profilbillede',
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
                        onTap: ()=>kIsWeb?getImageWeb('selfie'):getImage('selfie'),
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
                                  child: selfie!=null||selfieData!=null
                                      ?
                                  kIsWeb?Image.memory(selfieData):Image.file(selfie)
                                      :
                                  Image.asset('assets/images/selfie.png'),
                                ),
                              ),

                              ///text
                              CustomText(
                                text: 'Vedh??ft selfie',
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
                        child: Button(text: 'N??ste',padding: isTablet?width*0.025:10,onclick: () async {
                          if((profileImage!=null&&selfie!=null)||(profileImageData!=null&&selfieData!=null)){
                            SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                            pd.show(
                                message: 'Vent venligst',
                                type: SimpleFontelicoProgressDialogType.custom,
                                loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
                            );
                            try{
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              Map data = jsonDecode(prefs.getString('data'));

                              String email = data['email'];

                              ///upload images
                              ToastBar(text: 'Uploader profilbillede...',color: Colors.orange).show();
                              FirebaseStorage storage = FirebaseStorage.instance;
                              TaskSnapshot snap;
                              if(kIsWeb){
                                snap = await storage.ref('$email/profile.png').putData(profileImageData);
                              }
                              else{
                                snap = await storage.ref('$email/profile.png').putFile(profileImage);
                              }
                              String proPicUrl = await snap.ref.getDownloadURL();

                              ToastBar(text: 'Uploader selfie...',color: Colors.orange).show();
                              TaskSnapshot snap2;
                              if(kIsWeb){
                                snap2 = await storage.ref('$email/selfie.png').putData(selfieData);
                              }
                              else{
                                snap2 = await storage.ref('$email/selfie.png').putFile(selfie);
                              }
                              String selfieUrl = await snap2.ref.getDownloadURL();

                              data['profileImage'] = proPicUrl;
                              data['selfie'] = selfieUrl;
                              data['status'] = 'approved';
                              data['complete'] = true;

                              ///onesignal
                              String playerID = "";
                              if(!kIsWeb){
                                OSDeviceState status = await OneSignal.shared.getDeviceState();
                                playerID = status.userId;
                              }
                              data['playerID'] = playerID;

                              print(data);

                              ///add to db
                              await FirebaseFirestore.instance.collection('workers').doc(email).update(data);

                              ///send notification
                              if(!kIsWeb){
                                OneSignal.shared.postNotification(
                                    OSCreateNotification(
                                        playerIds: [playerID],
                                        content: 'Findmee har modtaget dine oplysninger.'
                                    )
                                );
                              }

                              await CustomEmail.sendEmail('Tak fordi du har oprettet en bruger hos os! Din bruger ville blive aktiveret, n??r en administrator har valideret din profil. Vi ville derefter kontakte dig telefonisk til en mere uddybende samtale.\n\n'
                                  'Tak fordi du valgte os!\n\n'
                                  'De bedste hilsner fra\n\nTeam Findme','Velkommen til FindMe', to: email);
                              await CustomEmail.sendEmail(
                                  'En ny bruger er registreret.',
                                  'Bruger registreret');

                              widget.controller.animateToPage(6,curve: Curves.ease,duration: Duration(milliseconds: 200));
                            }
                            catch(e){
                              print(e.toString());
                              ToastBar(text: 'Noget gik galt!',color: Colors.red).show();
                            }
                            pd.hide();
                          }
                          else{
                            ToastBar(text: 'Upload venligst et profilbillede og en selfie!',color: Colors.red).show();
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
      ),
    );
  }
}
