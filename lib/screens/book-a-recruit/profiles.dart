import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/pop-ups/profile-pop-up.dart';
import 'package:findmee/pop-ups/recieved-pop-up.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profiles extends StatefulWidget {
  @override
  _ProfilesState createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {

  var profiles = [];
  var catProfiles;
  List selectedCategories, selectedCities;
  getProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedCategories = prefs.getStringList('companyCategories');
    selectedCities = prefs.getStringList('companyCities');
    List dates = prefs.getStringList('companyDates');
    // List shifts = prefs.getStringList('companyShifts');
    List datesAndShifts = prefs.getStringList('companyDatesAndShifts');

    // ///creating datesAndShifts array
    // dates.forEach((element) {
    //   DateTime date = DateTime.parse(element);
    //   shifts.forEach((shift) {
    //     datesAndShifts.add(date.weekday.toString()+shift);
    //   });
    // });
    
    print(selectedCategories);
    print(selectedCities);
    print(datesAndShifts);
    var sub1 = await FirebaseFirestore.instance.collection('workers').where('categories', arrayContainsAny: selectedCategories).where('status', isEqualTo: 'approved').get();
    var sub2 = await FirebaseFirestore.instance.collection('workers').where('cities', arrayContainsAny: selectedCities).where('status', isEqualTo: 'approved').get();
    var sub3 = await FirebaseFirestore.instance.collection('workers').where('datesAndShifts', arrayContainsAny: datesAndShifts).where('status', isEqualTo: 'approved').get();

    catProfiles = sub1.docs;
    var citProfiles = sub2.docs;
    var datProfiles = sub3.docs;
    var allProfiles = [];
    allProfiles.addAll(catProfiles);
    allProfiles.addAll(citProfiles);
    allProfiles.addAll(datProfiles);
    var catIDs = [];
    var citIDs = [];
    var datIDs = [];

    catProfiles.forEach((element)=>catIDs.add(element.id));
    citProfiles.forEach((element)=>citIDs.add(element.id));
    datProfiles.forEach((element)=>datIDs.add(element.id));

    catIDs.removeWhere((item) => !citIDs.contains(item));
    catIDs.removeWhere((item) => !datIDs.contains(item));

    catIDs.forEach((element) {
       profiles.add(allProfiles[allProfiles.indexWhere((x) => x.id == element)]);
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor
                  ),
                  child: catProfiles!=null?
                      profiles.isEmpty?Center(child: CustomText(text: 'No profiles found!',color: Colors.white,)):
                  ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, i){
                      String name = profiles[i]['name'];
                      String profileImage = profiles[i]['profileImage'];
                      String experience = profiles[i]['experience'];
                      String email = profiles[i]['email'];
                      List categories = profiles[i]['categories'];
                      List cities = profiles[i]['cities'];
                      List datesAndShifts = profiles[i]['datesAndShifts'];

                      return Padding(
                        padding: EdgeInsets.fromLTRB(ScreenUtil().setHeight(30),ScreenUtil().setHeight(30),ScreenUtil().setHeight(30),ScreenUtil().setHeight(20)),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 50,
                                  backgroundImage: CachedNetworkImageProvider(profileImage),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(50),),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: name+" "+profiles[i]['surname'][0]+".",
                                        font: 'GoogleSans',
                                        align: TextAlign.start,
                                        size: ScreenUtil().setSp(60),
                                      ),
                                      SizedBox(height: ScreenUtil().setWidth(120),),
                                      SizedBox(
                                        height: ScreenUtil().setHeight(90),
                                        child: Button(
                                          text: 'View my profile',
                                          image: 'viewProfile.png',
                                          padding: 2,
                                          textSize: ScreenUtil().setSp(40),
                                          color: Color(0xffFA1E0E),
                                          onclick: (){
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context){
                                                  return ProfilePopUp(
                                                    categories: categories,
                                                    cities: cities,
                                                    experience: experience,
                                                    userDatesAndShifts: datesAndShifts,
                                                    selectedCategories: selectedCategories,
                                                    selectedCities: selectedCities,
                                                    email: email,
                                                  );
                                                });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ):Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setHeight(80)),
              child: Button(
                text: 'Finish',
                onclick: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  List cart = prefs.getStringList('cart');
                  String businessName = prefs.getString('name');
                  if(cart==null){
                    ToastBar(text: 'No one in the list!',color: Colors.red).show();
                  }
                  else{
                    ToastBar(text: 'Sending Email...',color: Colors.orange).show();

                    String username = 'findmee.db@gmail.com';
                    String password = 'Findmee@123';
                    String email = "$businessName wants to hire $cart";

                    final smtpServer = gmail(username, password);
                    final message = Message()
                      ..from = Address(username, 'Findmee')
                      ..recipients.add('dulajnadawa@gmail.com')
                      ..subject = 'Workers'
                      ..text = email;
                    try {
                      final sendReport = await send(message, smtpServer);
                      print('Message sent: ' + sendReport.toString());
                      prefs.remove('cart');
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return ReceivedPopUp();
                     });
                    } on MailerException catch (e) {
                      for (var p in e.problems) {
                        print('Problem: ${p.code}: ${p.msg}');
                        ToastBar(text: 'Email not sent! ${p.msg}',color: Colors.red).show();
                      }
                    }
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
