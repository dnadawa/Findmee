import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/pop-ups/profile-pop-up.dart';
import 'package:findmee/pop-ups/recieved-pop-up.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profiles extends StatefulWidget {
  @override
  _ProfilesState createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {

  var profiles = [];
  List selectedCategories, selectedCities;
  getProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedCategories = prefs.getStringList('companyCategories');
    selectedCities = prefs.getStringList('companyCities');
    List dates = prefs.getStringList('companyDates');
    List shifts = prefs.getStringList('companyShifts');
    List datesAndShifts = [];

    ///creating datesAndShifts array
    dates.forEach((element) {
      DateTime date = DateTime.parse(element);
      shifts.forEach((shift) {
        datesAndShifts.add(date.weekday.toString()+shift);
      });
    });

    ///get from firestore
    // subscription = FirebaseFirestore.instance.collection('workers')
    //     .where('categories', arrayContainsAny: categories)
    //     .where('cities', arrayContainsAny: cities)
    //     .where('datesAndShifts', arrayContainsAny: datesAndShifts)
    //     .where('status', isEqualTo: 'approved')
    //     .snapshots().listen((datasnapshot){
    //   setState(() {
    //     profiles = datasnapshot.docs;
    //   });
    // });

    print(selectedCategories);
    print(selectedCities);
    print(datesAndShifts);
    var sub1 = await FirebaseFirestore.instance.collection('workers').where('categories', arrayContainsAny: selectedCategories).where('status', isEqualTo: 'approved').get();
    var sub2 = await FirebaseFirestore.instance.collection('workers').where('cities', arrayContainsAny: selectedCities).where('status', isEqualTo: 'approved').get();
    var sub3 = await FirebaseFirestore.instance.collection('workers').where('datesAndShifts', arrayContainsAny: datesAndShifts).where('status', isEqualTo: 'approved').get();

    var catProfiles = sub1.docs;
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
                  child: profiles.isNotEmpty?ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, i){
                      String name = profiles[i]['name'];
                      String profileImage = profiles[i]['profileImage'];
                      String experience = profiles[i]['experience'];
                      List categories = profiles[i]['categories'];
                      List cities = profiles[i]['cities'];
                      List datesAndShifts = profiles[i]['datesAndShifts'];

                      return Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
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
                                  radius: 45,
                                  backgroundImage: NetworkImage(profileImage),
                                ),
                                SizedBox(width: ScreenUtil().setWidth(40),),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: name,
                                        font: 'GoogleSans',
                                        align: TextAlign.start,
                                        size: ScreenUtil().setSp(50),
                                      ),
                                      SizedBox(height: ScreenUtil().setWidth(40),),
                                      Button(
                                        text: 'View my profile',
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
                                                );
                                              });
                                        },
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
                  ):Center(child: CircularProgressIndicator(),),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setHeight(80)),
              child: Button(
                text: 'Finish',
                onclick: (){
                  getProfiles();
                  // showDialog(
                  //     context: context,
                  //     builder: (BuildContext context){
                  //       return ReceivedPopUp();
                  //     });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
