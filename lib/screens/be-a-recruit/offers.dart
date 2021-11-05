import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../../email.dart';
import '../../responsive.dart';

class Offers extends StatefulWidget {
  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  var offers;
  final _scrollController = ScrollController();

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
    bool isTablet = Responsive.isTablet(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
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
                       text: offers!=null&&offers.length>0?'Du har modtaget nye jobtilbud':'Du har ingen nye jobtilbud',
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
              child: offers!=null?Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView.builder(
                  itemCount: offers.length,
                  controller: _scrollController,
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
                                    text: 'Her er nogle krav, som virksomheden ser fra dig',
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
                                        'Kategori / Kategorier',
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
                                        'By / Byer',
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
                                            child: CustomText(text: 'Ledige arbejdsdage og tider',color: Colors.white,align: TextAlign.start,size: ScreenUtil().setSp(45),),
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
                                                            child: CustomText(text: shift=='mor'?'Morgen':shift=='eve'?'Aften':'Nat',font: 'GoogleSans',isBold: false,size: ScreenUtil().setSp(40),align: TextAlign.start,),
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
                                          text: 'Accepter jobbet',
                                          color: Colors.green,
                                          borderRadius: 10,
                                          padding: isTablet?width*0.025:10,
                                          onclick: () async {
                                            SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                                            pd.show(
                                                message: 'Vent gerne',
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
                                                  "• Firmanavn: ${company[0]['name']}\n"
                                                  "• Kontakt e-mail: ${company[0]['email']}\n"
                                                  "• Mobile Phone: ${company[0]['phone']}\n"
                                                  "• CVR-nummer: ${company[0]['cvr']}\n\n"
                                                  "Recruiter Details:-\n\n"
                                                  "• ${worker[0]['name']} ${worker[0]['surname']}\n"
                                                  "\t\tContact email: $email\n"
                                                  "\t\tMobile Phone: ${worker[0]['phone']}\n"
                                                  "\t\tCPR nummer: ${worker[0]['cpr']}";

                                              bool isSendEmail = await CustomEmail.sendEmail(msg, 'Workers');
                                              if(isSendEmail){
                                                  ToastBar(text: 'Email sendt!',color: Colors.green).show();
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

                                                  if(!kIsWeb){
                                                    OneSignal.shared.postNotification(
                                                        OSCreateNotification(
                                                            playerIds: [company[0]['playerID']],
                                                            content: 'Dit tilbud accepteret af ${worker[0]['name']} ${worker[0]['surname']}'
                                                        )
                                                    );
                                                  }

                                                  await CustomEmail.sendEmail('Dit tilbud accepteret af ${worker[0]['name']} ${worker[0]['surname']}', 'Offer Accepted', to: company[0]['email']);
                                                  ToastBar(text: 'Accepteret',color: Colors.green).show();
                                              }
                                              else{
                                                    ToastBar(text: 'E-mail ikke sendt!', color: Colors.red).show();
                                              }
                                              pd.hide();
                                          },
                                        ),
                                      ),
                                      SizedBox(width: ScreenUtil().setHeight(50),),

                                      Expanded(
                                        child: Button(
                                          text: 'Afvis jobbet',
                                          color: Colors.red,
                                          padding: isTablet?width*0.025:10,
                                          borderRadius: 10,
                                          onclick: () async {
                                            SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                                            pd.show(
                                                message: 'Vent gerne',
                                                type: SimpleFontelicoProgressDialogType.custom,
                                                loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
                                            );
                                            try{
                                              SharedPreferences prefs = await SharedPreferences.getInstance();
                                              String email = jsonDecode(prefs.getString('data'))['email'];

                                              var subCompany = await FirebaseFirestore.instance.collection('companies').where('email', isEqualTo: offers[i]['company']).get();
                                              var company = subCompany.docs;

                                              var subWorker = await FirebaseFirestore.instance.collection('workers').where('email', isEqualTo: email).get();
                                              var worker = subWorker.docs;

                                              ///send notification
                                              if(!kIsWeb){
                                                OneSignal.shared.postNotification(
                                                    OSCreateNotification(
                                                        playerIds: [company[0]['playerID']],
                                                        content: 'Dit tilbud afvist af ${worker[0]['name']} ${worker[0]['surname']}'
                                                    )
                                                );

                                              }

                                              await CustomEmail.sendEmail('Dit tilbud afvist af ${worker[0]['name']} ${worker[0]['surname']}', 'Offer Rejected', to: offers[i]['company']);

                                              await FirebaseFirestore.instance.collection('offers').doc(id).update({
                                                'sent': FieldValue.arrayRemove([email])
                                              });
                                              getOffers();

                                              ToastBar(text: 'TIlbud afvist', color: Colors.green).show();
                                            }
                                            catch(e){
                                              ToastBar(text: 'Noget gik galt', color: Colors.red).show();
                                            }
                                            pd.hide();
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
                ),
              ):Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),),),
            ),
          )
        ],
      ),
    );
  }
}
