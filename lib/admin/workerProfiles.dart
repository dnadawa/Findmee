import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:findmee/widgets/admin-input-field.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../responsive.dart';

class WorkerProfiles extends StatefulWidget {
  @override
  _WorkerProfilesState createState() => _WorkerProfilesState();
}

class _WorkerProfilesState extends State<WorkerProfiles> {
  List<DocumentSnapshot> profiles;
  StreamSubscription<QuerySnapshot> subscription;

  getData(){
    subscription = FirebaseFirestore.instance.collection('workers').where('status', isEqualTo: 'pending').snapshots().listen((dataSnapshot) {
      setState(() {
        profiles = dataSnapshot.docs;
      });
    });
  }

  List<MultiSelectItem> buildCategories(List categoryList){
    List<MultiSelectItem> categories = [];
    categoryList.forEach((element) {
      categories.add(
          MultiSelectItem(element, element)
      );
    });
    return categories;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double width;
    bool isTablet = Responsive.isTablet(context);
    bool isDesktop = Responsive.isDesktop(context);
    if(isDesktop){
      width = MediaQuery.of(context).size.width*0.25;
    }
    else if(isTablet){
      width = MediaQuery.of(context).size.width*0.4;
    }
    else{
      width = MediaQuery.of(context).size.width;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: profiles!=null?GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop?4:isTablet?2:1,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            mainAxisExtent: width*3.3
          ),
        padding: EdgeInsets.all(width*0.05),
        itemCount: profiles.length,
        itemBuilder: (context, i){
            TextEditingController name = TextEditingController();
            TextEditingController surname = TextEditingController();
            TextEditingController email = TextEditingController();
            TextEditingController phone = TextEditingController();
            TextEditingController cvr = TextEditingController();
            TextEditingController experience = TextEditingController();
            List<MultiSelectItem> categories = buildCategories(profiles[i]['categories']);
            List<MultiSelectItem> cities = buildCategories(profiles[i]['cities']);
            String profileImage = profiles[i]['profileImage'];
            String selfie = profiles[i]['selfie'];
            name.text = profiles[i]['name'];
            surname.text = profiles[i]['surname'];
            email.text = profiles[i]['email'];
            phone.text = profiles[i]['phone'];
            cvr.text = profiles[i]['cpr'];
            experience.text = profiles[i]['experience'];

            return Container(
              decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: EdgeInsets.all(width*0.05),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      AdminInputField(hint: 'Navn',controller: name,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Efternavn',controller: surname,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Contact Email',controller: email,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Mobile Number',controller: phone,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'CVR Number',controller: cvr,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Experience',controller: experience,maxLines: null,),
                      SizedBox(height: width*0.05,),

                      ///categories
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          color: Colors.white,
                          elevation: 5,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width*0.01),
                            child: CustomText(
                              text: 'Kategori/ Kategorier',
                              color: Color(0xff52575D),
                              size: width*0.04,
                              align: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: width*0.01,),
                      AbsorbPointer(
                        absorbing: true,
                        child: MultiSelectChipField(
                          title: Text(
                            'Kategori/ Kategorier',
                            style: TextStyle(
                                color: Color(0xff52575D),
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          headerColor: Colors.white,
                          chipShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),side: BorderSide(color: Colors.black)),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent,width: 0),
                          ),
                          selectedChipColor: Color(0xff00C853),
                          selectedTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'GoogleSans'),
                          textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'GoogleSans'),
                          scroll: false,
                          showHeader: false,
                          items: categories,
                        ),
                      ),
                      SizedBox(height: width*0.05,),

                      ///cities
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          color: Colors.white,
                          elevation: 5,
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width*0.01),
                            child: CustomText(
                              text: 'By /Byer',
                              color: Color(0xff52575D),
                              size: width*0.04,
                              align: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: width*0.01,),
                      AbsorbPointer(
                        absorbing: true,
                        child: MultiSelectChipField(
                          title: Text(
                            'Kategori/ Kategorier',
                            style: TextStyle(
                                color: Color(0xff52575D),
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          headerColor: Colors.white,
                          chipShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),side: BorderSide(color: Colors.black)),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent,width: 0),
                          ),
                          selectedChipColor: Color(0xff00C853),
                          selectedTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'GoogleSans'),
                          textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'GoogleSans'),
                          scroll: false,
                          showHeader: false,
                          items: cities,
                        ),
                      ),
                      SizedBox(height: width*0.05,),

                      ///profile picture
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
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
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)
                                    )
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(width*0.025),
                                  child: CustomText(text: 'Profilbillede',color: Colors.white,size: width*0.04),),
                                ),
                              ),

                            ///image
                            Padding(
                              padding: EdgeInsets.all(width*0.02),
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                radius: 60,
                                backgroundImage: NetworkImage(profileImage),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: width*0.05,),

                      ///selfie
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
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
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)
                                    )
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(width*0.025),
                                  child: CustomText(text: 'Selfe',color: Colors.white,size: width*0.04),),
                              ),
                            ),

                            ///image
                            Padding(
                              padding: EdgeInsets.all(width*0.02),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                radius: 60,
                                child: Image.network(selfie),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: width*0.1,),

                      ///buttons
                      Row(
                        children: [
                          Expanded(
                            child: Button(
                              text: 'Approve',
                              color: Colors.green,
                              borderRadius: 10,
                              padding: isTablet?15:10,
                              onclick: () async {
                                SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                                pd.show(
                                    message: 'Please wait',
                                    hideText: true
                                );
                                await FirebaseFirestore.instance.collection('workers').doc(profiles[i].id).update({
                                  'status': 'approved'
                                });
                                pd.hide();
                                MessageDialog.show(context: context, text: 'Approved', type: CoolAlertType.success);
                              },
                            ),
                          ),
                          SizedBox(width: width*0.02,),
                          Expanded(
                            child: Button(
                              text: 'Ban',
                              borderRadius: 10,
                              color: Colors.red,
                              padding: isTablet?15:10,
                              onclick: () async {
                                SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                                pd.show(
                                    message: 'Please wait',
                                    hideText: true
                                );
                                await FirebaseFirestore.instance.collection('workers').doc(profiles[i].id).update({
                                  'status': 'ban'
                                });
                                pd.hide();
                                MessageDialog.show(context: context, text: 'Banned', type: CoolAlertType.success);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
        },
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}