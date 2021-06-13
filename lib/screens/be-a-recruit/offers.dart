import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Offers extends StatefulWidget {
  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: CustomText(text: 'Job Offers',color: Colors.white,),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///ribbon
           Padding(
             padding: EdgeInsets.symmetric(vertical: ScreenUtil().setHeight(80)),
             child: Container(
               decoration: BoxDecoration(
                 color: Color(0xffffeb3b),
                 borderRadius: BorderRadius.horizontal(right: Radius.circular(10))
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
                       width: ScreenUtil().setHeight(50),
                       height: ScreenUtil().setHeight(50),
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

          ///offers
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setHeight(35)),
              child: offers!=null?ListView.builder(
                itemCount: offers.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, i){

                  List<MultiSelectItem> categories = getItemList(offers[i]['categories']);
                  List<MultiSelectItem> cities = getItemList(offers[i]['cities']);
                  List datesAndShifts = offers[i]['daysAndShifts'];
                  String id = offers[i].id;


                  return Padding(
                    padding: EdgeInsets.only(bottom: ScreenUtil().setHeight(60)),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xfff5f5f5)
                      ),
                      child: Column(
                        children: [
                          ///id
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
                                  color: Color(0xffC0E218)
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                                child: CustomText(
                                  text: '#$id',
                                ),
                              ),
                            ),
                          ),

                          ///body
                          Padding(
                            padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                            child: Column(
                              children: [
                                ///text
                                CustomText(
                                  text: 'Here are some requirements that business is looking from you',
                                  isBold: false,
                                  font: 'GoogleSans',
                                  align: TextAlign.start,
                                  size: ScreenUtil().setSp(45),
                                ),
                                SizedBox(height: ScreenUtil().setHeight(70),),

                                ///categories
                                AbsorbPointer(
                                  absorbing: true,
                                  child: MultiSelectChipField(
                                    title: Text(
                                      'Category/Categories',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    headerColor: Theme.of(context).primaryColor,
                                    chipShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),side: BorderSide(color: Colors.black)),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Theme.of(context).primaryColor,width: 2),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    selectedChipColor: Color(0xff00C853),
                                    selectedTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'GoogleSans'),
                                    textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'GoogleSans'),
                                    scroll: false,
                                    items: categories,
                                  ),
                                ),
                                SizedBox(height: ScreenUtil().setHeight(60),),

                                ///cities
                                AbsorbPointer(
                                  absorbing: true,
                                  child: MultiSelectChipField(
                                    title: Text(
                                      'City/Cities',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    headerColor: Theme.of(context).primaryColor,
                                    chipShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),side: BorderSide(color: Colors.black)),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Theme.of(context).primaryColor,width: 2),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    selectedChipColor: Color(0xff00C853),
                                    selectedTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'GoogleSans'),
                                    textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'GoogleSans'),
                                    scroll: false,
                                    items: cities,
                                  ),
                                ),
                                SizedBox(height: ScreenUtil().setHeight(60),),

                                ///shifts
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Theme.of(context).primaryColor,width: 2)
                                  ),
                                  child: Column(
                                    children: [
                                      ///header
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                                            color: Theme.of(context).primaryColor
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(ScreenUtil().setHeight(25)),
                                          child: CustomText(text: 'Available Working Days & Shifts',color: Colors.white,align: TextAlign.start,size: ScreenUtil().setSp(45),),
                                        ),
                                      ),

                                      ///body
                                      Container(
                                        width: double.infinity,
                                        child: Padding(
                                          padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: datesAndShifts.length,
                                            itemBuilder: (context, i){
                                              String day = DateFormat('dd/MM/yyyy').format(DateTime.parse(datesAndShifts[i].split(':')[0]));
                                              String shift = datesAndShifts[i].split(':')[1];
                                              return Padding(
                                                padding:  EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
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
                                                          padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                                                          child: CustomText(text: day,color: Colors.white,font: 'GoogleSans',size: ScreenUtil().setSp(40),),
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
                                                          padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                                                          child: CustomText(text: shift=='mor'?'Morning':shift=='eve'?'Evening':'Night',font: 'GoogleSans',isBold: false,size: ScreenUtil().setSp(40),align: TextAlign.start,),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: ScreenUtil().setHeight(80),),

                                ///buttons
                                Row(
                                  children: [
                                    Expanded(
                                      child: Button(
                                        text: 'Accept the job',
                                        color: Colors.green,
                                        borderRadius: 10,
                                        onclick: () async {
                                          ToastBar(text: 'Please wait', color: Colors.orange).show();
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

                                          String username = 'findmee.db@gmail.com';
                                          String password = 'Findmee@123';

                                          final smtpServer = gmail(username, password);
                                          final message = Message()
                                            ..from = Address(username, 'Findmee')
                                            ..recipients.add('shakib@live.dk')
                                            // ..recipients.add('dulajnadawa@gmail.com')
                                            ..subject = 'Workers'
                                            ..text = msg;
                                          try {
                                            final sendReport = await send(message, smtpServer);
                                            print('Message sent: ' + sendReport.toString());
                                            ToastBar(text: 'Email sent!',color: Colors.green).show();

                                            await FirebaseFirestore.instance.collection('offers').doc(id).update({
                                              'sent': FieldValue.arrayRemove([email]),
                                              'accepted': FieldValue.arrayUnion([email])
                                            });

                                            getOffers();

                                          } on MailerException catch (e) {
                                            for (var p in e.problems) {
                                              print('Problem: ${p.code}: ${p
                                                  .msg}');
                                              ToastBar(
                                                  text: 'Email not sent! ${p
                                                      .msg}', color: Colors.red)
                                                  .show();
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(width: ScreenUtil().setHeight(50),),

                                    Expanded(
                                      child: Button(
                                        text: 'Reject the job',
                                        color: Colors.red,
                                        borderRadius: 10,
                                        onclick: () async {
                                          ToastBar(text: 'Please wait', color: Colors.orange).show();
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          String email = jsonDecode(prefs.getString('data'))['email'];
                                          await FirebaseFirestore.instance.collection('offers').doc(id).update({
                                            'sent': FieldValue.arrayRemove([email])
                                          });
                                          getOffers();
                                          ToastBar(text: 'Offer rejected', color: Colors.green).show();
                                        },
                                      ),
                                    ),
                                  ],
                                )

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ):Center(child: CircularProgressIndicator(),),
            ),
          )
        ],
      ),
    );
  }
}
