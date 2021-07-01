import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/pop-ups/profile-pop-up.dart';
import 'package:findmee/pop-ups/recieved-pop-up.dart';
import 'package:findmee/screens/book-a-recruit/stepper.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../responsive.dart';

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
    // List dates = prefs.getStringList('companyDates');
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
    bool isTablet = Responsive.isTablet(context);
    double width = MediaQuery.of(context).size.width;
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
                      profiles.isEmpty?Center(child: CustomText(text: 'No profiles found!',color: Colors.white,size: width*0.04,)):
                  ListView.builder(
                    itemCount: profiles.length,
                    itemBuilder: (context, i){
                      String name = profiles[i]['name'];
                      String surname = profiles[i]['surname'];
                      String phone = profiles[i]['phone'];
                      String cpr = profiles[i]['cpr'];
                      String profileImage = profiles[i]['profileImage'];
                      String experience = profiles[i]['experience'];
                      String email = profiles[i]['email'];
                      String playerID = profiles[i]['playerID'];
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
                                          text: 'Se min profil',
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
                                                    phone: phone,
                                                    cpr: cpr,
                                                    name: name,
                                                    surname: surname,
                                                    playerID: playerID,
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
                  ):Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setHeight(80)),
              child: Button(
                text: 'Finish',
                padding: isTablet?width*0.025:10,
                onclick: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  List<String> emailList = prefs.getStringList('emailList');
                  List<String> notificationList = prefs.getStringList('notificationList');
                  if(emailList==null){
                    ToastBar(text: 'No one in the list!',color: Colors.red).show();
                  }
                  else{
                    SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                    pd.show(
                        message: 'Please wait',
                        type: SimpleFontelicoProgressDialogType.custom,
                        loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
                    );
                    try{
                      await FirebaseFirestore.instance.collection('offers').add({
                        'categories': selectedCategories,
                        'cities': selectedCities,
                        'accepted': [],
                        'closed': false,
                        'company': prefs.getString('companyEmail'),
                        'daysAndShifts': prefs.getStringList('longDates'),
                        'sent': emailList
                      });


                      if(!kIsWeb){
                        ///send notification
                        OneSignal.shared.postNotification(
                            OSCreateNotification(
                                playerIds: notificationList,
                                content: 'You received a new job offer'
                            )
                        );

                        String username = dotenv.env['EMAIL'];
                        String password = dotenv.env['PASSWORD'];

                        final smtpServer = gmail(username, password);
                        final message = Message()
                          ..from = Address(username, 'Findmee')
                          ..recipients.addAll(emailList)
                          ..subject = "Offer Received"
                          ..text = "You received a new job offer";
                        try {
                          final sendReport = await send(message, smtpServer);
                          print('Message sent: ' + sendReport.toString());
                        } on MailerException catch (e) {
                          for (var p in e.problems) {
                            print('Problem: ${p.code}: ${p.msg}');
                          }
                        }
                      }
                      pd.hide();

                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              if(kIsWeb) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  insetPadding: EdgeInsets.symmetric(
                                      vertical: 24, horizontal: 10),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      24, 0, 24, 24),
                                  scrollable: true,
                                  backgroundColor: Colors.white,
                                  content: Container(
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        ///check mark
                                        Container(
                                          width: ScreenUtil().setHeight(800),
                                          height: ScreenUtil().setHeight(800),
                                          child: Center(child: Image.asset(
                                              'assets/images/tick.gif')),
                                        ),


                                        ///text
                                        CustomText(
                                          text: 'Offer successfully sent to selected recruiters. You will receive an email and a notification when they are respond to the offer.',
                                          font: 'ComicSans',
                                          isBold: false,
                                          size: ScreenUtil().setSp(55),
                                        ),
                                        SizedBox(
                                          height: ScreenUtil().setWidth(100),),

                                        ///buttons
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height: ScreenUtil().setHeight(
                                                    230),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                        CupertinoPageRoute(
                                                            builder: (
                                                                context) =>
                                                                StepperPage()), (
                                                        Route<
                                                            dynamic> route) => false);
                                                  },
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    primary: Color(0xff00C853),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius
                                                            .circular(10)
                                                    ),
                                                    padding: EdgeInsets.all(10),
                                                  ),
                                                  child: CustomText(
                                                    text: 'Jeg skal ansætte flere vikarer',
                                                    size: 18,
                                                    color: Colors.white,),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )


                                      ],
                                    ),
                                  ),
                                );
                              }
                              else{
                                return ReceivedPopUp();
                              }
                       });
                      prefs.remove('cart');
                      prefs.remove('emailList');
                      prefs.remove('notificationList');
                    }
                    catch(e){
                      pd.hide();
                      ToastBar(text: 'Something went wrong',color: Colors.red).show();
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
