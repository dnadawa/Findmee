import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../../email.dart';

class OffersWeb extends StatefulWidget {
  @override
  _OffersWebState createState() => _OffersWebState();
}

class _OffersWebState extends State<OffersWeb> {
  final _scrollController = ScrollController();
  var offers;
  getOffers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = jsonDecode(prefs.getString('data'))['email'];
    var sub = await FirebaseFirestore.instance.collection('offers').where('sent', arrayContains: email).get();
    setState(() {
      offers = sub.docs;
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
    getOffers();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ///ribbon
          Padding(
            padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(80)),
            child: Container(
              decoration: BoxDecoration(
                  color: Color(0xffffeb3b),
                  borderRadius: BorderRadius.circular(10)
              ),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 10
              ),
              child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: ScreenUtil().setHeight(80),
                      height: ScreenUtil().setHeight(80),
                      child: Image.asset('assets/images/ribbon.png'),
                    ),
                    SizedBox(width: ScreenUtil().setWidth(20),),

                    CustomText(
                      text: offers!=null&&offers.length>0?'You have received new job offer(s)':'You have no new job offers',
                      font: 'GoogleSans',
                      size: ScreenUtil().setSp(45),
                    )
                  ],
                ),
              ),
            ),
          ),

          ///profiles
          Expanded(
              child: offers!=null?
              Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: StaggeredGridView.countBuilder(
                  controller: _scrollController,
                  staggeredTileBuilder: (index)=> StaggeredTile.fit(1),
                  crossAxisCount: 3,
                  crossAxisSpacing: 35,
                  mainAxisSpacing: 25,
                  padding: EdgeInsets.all(30),
                  itemCount: offers.length,
                  itemBuilder: (context, i){
                    List<MultiSelectItem> categories = getItemList(offers[i]['categories']);
                    List<MultiSelectItem> cities = getItemList(offers[i]['cities']);
                    List datesAndShifts = offers[i]['daysAndShifts'];
                    String id = offers[i].id;

                    return Container(
                      decoration: BoxDecoration(
                          color: Color(0xfff5f5f5),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          boxShadow: [BoxShadow(blurRadius: 20)]
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///hint
                          Padding(
                            padding: EdgeInsets.all(width*0.015),
                            child: CustomText(
                              text: 'Here are the requirements that business is looking from you',
                              isBold: false,
                              font: 'GoogleSans',
                              align: TextAlign.start,
                              size: width*0.01,
                            ),
                          ),
                          SizedBox(height: width*0.005,),

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
                                  size: width*0.012,
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
                          SizedBox(height: width*0.01,),

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
                                  size: width*0.012,
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
                          SizedBox(height: width*0.01,),

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
                                  size: width*0.012,
                                  align: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: width*0.005,),
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
                                    padding:  EdgeInsets.only(bottom: width*0.008),
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
                                              child: CustomText(text: day,color: Colors.white,font: 'GoogleSans',size: width*0.01),
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
                                              child: CustomText(text: shift=='mor'?'Morgen':shift=='eve'?'Aften':'Nat',font: 'GoogleSans',isBold: false,size: width*0.01,align: TextAlign.start,),
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
                          SizedBox(height: width*0.03,),

                          ///buttons
                          Padding(
                            padding: EdgeInsets.all(width*0.01),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Button(
                                    text: 'Accept the job',
                                    color: Colors.green,
                                    padding: width*0.013,
                                    borderRadius: 10,
                                    textSize: width*0.012,
                                    onclick: () async {
                                      SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                                      pd.show(
                                          message: 'Please wait',
                                          type: SimpleFontelicoProgressDialogType.custom,
                                          loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
                                      );
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      String email = jsonDecode(prefs.getString('data'))['email'];

                                      ///send email
                                      var subCompany = await FirebaseFirestore.instance.collection('companies').where('email', isEqualTo: offers[i]['company']).get();
                                      var company = subCompany.docs;

                                      var subWorker = await FirebaseFirestore.instance.collection('workers').where('email', isEqualTo: email).get();
                                      var worker = subWorker.docs;

                                      String msg = "${company[0]['name']} wants to hire following recruiter. All the details of the business and recruiter are mentioned below\n\n"
                                          "Business Details:-\n\n"
                                          "• Business Name: ${company[0]['name']}\n"
                                          "• Contact Email: ${company[0]['email']}\n"
                                          "• Mobile Phone: ${company[0]['phone']}\n"
                                          "• CVR Number: ${company[0]['cvr']}\n\n"
                                          "Recruiter Details:-\n\n"
                                          "• ${worker[0]['name']} ${worker[0]['surname']}\n"
                                          "\t\tContact email: $email\n"
                                          "\t\tMobile Phone: ${worker[0]['phone']}\n"
                                          "\t\tCPR Number: ${worker[0]['cpr']}";

                                      ///send email to admin
                                      await CustomEmail.sendEmail(msg, 'Workers');

                                      await FirebaseFirestore.instance.collection('offers').doc(id).update({
                                          'sent': FieldValue.arrayRemove([email]),
                                          'accepted': FieldValue.arrayUnion([email])
                                        });
                                      await FirebaseFirestore.instance.collection('overview').add({
                                        'business': company[0]['name'],
                                        'businessEmail': company[0]['email'],
                                        'businessPhone': company[0]['phone'],
                                        'businessCVR': company[0]['cvr'],
                                        'workerFName': worker[0]['name'],
                                        'workerLName': worker[0]['surname'],
                                        'workerEmail': email,
                                        'workerPhone': worker[0]['phone'],
                                        'workerCPR': worker[0]['cpr'],
                                        'time': DateTime.now().toString(),
                                        'categories': offers[i]['categories'],
                                        'cities': offers[i]['cities'],
                                        'daysAndShifts': datesAndShifts
                                      });
                                      getOffers();
                                      pd.hide();
                                      MessageDialog.show(context: context, text: 'Accepted',type: CoolAlertType.success);
                                    },
                                  ),
                                ),
                                SizedBox(width: ScreenUtil().setHeight(50),),

                                Expanded(
                                  child: Button(
                                    text: 'Reject the job',
                                    color: Colors.red,
                                    padding: width*0.013,
                                    textSize: width*0.012,
                                    borderRadius: 10,
                                    onclick: () async {
                                      SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                                      pd.show(
                                          message: 'Please wait',
                                          type: SimpleFontelicoProgressDialogType.custom,
                                          loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
                                      );
                                      try{
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        String email = jsonDecode(prefs.getString('data'))['email'];

                                        var subWorker = await FirebaseFirestore.instance.collection('workers').where('email', isEqualTo: email).get();
                                        var worker = subWorker.docs;

                                        ///send notification

                                        await CustomEmail.sendEmail('Your offer rejected by ${worker[0]['name']} ${worker[0]['surname']}', 'Offer Rejected', to: offers[i]['company']);

                                        await FirebaseFirestore.instance.collection('offers').doc(id).update({
                                          'sent': FieldValue.arrayRemove([email])
                                        });
                                        getOffers();
                                        pd.hide();
                                        MessageDialog.show(context: context, text: 'Offer rejected',type: CoolAlertType.success);
                                      }
                                      catch(e){
                                        MessageDialog.show(context: context, text: 'Accepted',type: CoolAlertType.success);
                                      }
                                      pd.hide();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ):Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),),)
          )
        ],
      ),
    );
  }
}
