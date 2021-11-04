import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:findmee/widgets/admin-input-field.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../responsive.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  List<DocumentSnapshot> entries;
  StreamSubscription<QuerySnapshot> subscription;
  final _scrollController = ScrollController();

  getData(){
    subscription = FirebaseFirestore.instance.collection('overview').orderBy('time', descending: true).snapshots().listen((dataSnapshot) {
      setState(() {
        entries = dataSnapshot.docs;
      });
    });
  }

  getItemList(List categories){
    List<MultiSelectItem> items = [];
    categories.forEach((element) {
      items.add(
          MultiSelectItem(element, element)
      );
    });
    return items;
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
    body: entries!=null?Scrollbar(
      isAlwaysShown: true,
      controller: _scrollController,
      child: StaggeredGridView.countBuilder(
          controller: _scrollController,
          staggeredTileBuilder: (index)=> StaggeredTile.fit(1),
          crossAxisCount: isDesktop?4:isTablet?2:1,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          padding: EdgeInsets.all(width*0.05),
          itemCount: entries.length,
          itemBuilder: (context, i){
              TextEditingController bName = TextEditingController();
              TextEditingController bEmail = TextEditingController();
              TextEditingController bPhone = TextEditingController();
              TextEditingController cvr = TextEditingController();
              TextEditingController wName = TextEditingController();
              TextEditingController wEmail = TextEditingController();
              TextEditingController wPhone = TextEditingController();
              TextEditingController cpr = TextEditingController();
              TextEditingController time = TextEditingController();
              bName.text = entries[i]['business'];
              bEmail.text = entries[i]['businessEmail'];
              bPhone.text = entries[i]['businessPhone'];
              cvr.text = entries[i]['businessCVR'];
              wName.text = entries[i]['workerFName']+" "+entries[i]['workerLName'];
              wEmail.text = entries[i]['workerEmail'];
              wPhone.text = entries[i]['workerPhone'];
              cpr.text = entries[i]['workerCPR'];
              String formattedTime = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(entries[i]['time']));
              time.text = formattedTime;
              String id = entries[i].id;
              List<MultiSelectItem> categories = getItemList(entries[i]['categories']);
              List<MultiSelectItem> cities = getItemList(entries[i]['cities']);
              List datesAndShifts = entries[i]['daysAndShifts'];

              return Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: EdgeInsets.all(width*0.05),
                  child: Column(
                    children: [
                      AdminInputField(hint: 'Business Name',controller: bName,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Business Email',controller: bEmail,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Business Mobile Number',controller: bPhone,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'CVR Number',controller: cvr,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Recruiter Name',controller: wName,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Recruiter Email',controller: wEmail,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Recruiter Mobile Number',controller: wPhone,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'CPR Number',controller: cpr,),
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
                            padding: EdgeInsets.symmetric(vertical: width*0.005, horizontal: width*0.015),
                            child: CustomText(
                              text: 'Kategori/ Kategorier',
                              color: Color(0xff52575D),
                              // size: width*0.1,
                              align: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: width*0.005,),
                      Padding(
                        padding: EdgeInsets.only(left: width*0.009),
                        child: AbsorbPointer(
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
                            padding: EdgeInsets.symmetric(vertical: width*0.005, horizontal: width*0.015),
                            child: CustomText(
                              text: 'By /Byer',
                              color: Color(0xff52575D),
                              align: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: width*0.005,),
                      Padding(
                        padding: EdgeInsets.only(left: width*0.009),
                        child: AbsorbPointer(
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
                      ),
                      SizedBox(height: width*0.05,),

                      ///shifts
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
                            padding: EdgeInsets.symmetric(vertical: width*0.005, horizontal: width*0.015),
                            child: CustomText(
                              text: 'Ledige arbejdsdage og tider',
                              color: Color(0xff52575D),
                              align: TextAlign.start,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: width*0.02,),
                      Container(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(width*0.015,width*0.008,width*0.01,width*0.01),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: datesAndShifts.length,
                            itemBuilder: (context, i){
                              String day = DateFormat('dd/MM/yyyy').format(DateTime.parse(datesAndShifts[i].split(':')[0]));
                              String shift = datesAndShifts[i].split(':')[1];
                              return Padding(
                                padding:  EdgeInsets.only(bottom: width*0.01),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                                            border: Border.all(width: 2,color: Colors.black)
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(width*0.005),
                                          child: CustomText(text: day,color: Colors.white,font: 'GoogleSans',),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                                            border: Border.all(width: 2,color: Colors.black)
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(width*0.005),
                                          child: CustomText(text: shift=='mor'?'Morgen':shift=='eve'?'Aften':'Nat',font: 'GoogleSans',isBold: false,align: TextAlign.start,),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: width*0.05,),

                      AdminInputField(hint: 'Created Time',controller: time,),
                      SizedBox(height: width*0.1,),
                      Button(
                        text: 'Delete',
                        borderRadius: 10,
                        color: Colors.red,
                        padding: isTablet?15:10,
                        onclick: () async {
                          SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                          pd.show(
                              message: 'Please wait',
                              hideText: true
                          );
                          try{
                            await FirebaseFirestore.instance.collection('overview').doc(id).delete();
                            pd.hide();
                            if(Responsive.isMobile(context)){
                              ToastBar(text: 'Deleted!',color: Colors.green).show();
                            }
                            else{
                              MessageDialog.show(context: context, text: 'Deleted', type: CoolAlertType.success);
                            }
                          }
                          catch(e){
                            pd.hide();
                            MessageDialog.show(context: context, text: e.toString(), type: CoolAlertType.error);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
          },
        ),
    ):Center(child: CircularProgressIndicator(),),
    );
  }
}
