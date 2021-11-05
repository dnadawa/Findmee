import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/email.dart';
import 'package:findmee/pop-ups/profile-pop-up.dart';
import 'package:findmee/pop-ups/recieved-pop-up.dart';
import 'package:findmee/screens/book-a-recruit/stepper.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:quiver/iterables.dart';
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
  final _scrollController = ScrollController();

  getProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedCategories = prefs.getStringList('companyCategories');
    selectedCities = prefs.getStringList('companyCities');
    // List dates = prefs.getStringList('companyDates');
    // List shifts = prefs.getStringList('companyShifts');
    List datesAndShifts = prefs.getStringList('companyDatesAndShifts');

    ///divide into 10 per group
    var groupedCategories = partition(selectedCategories, 10);
    groupedCategories.forEach((group) async {
      var sub = await FirebaseFirestore.instance.collection('workers').where('categories', arrayContainsAny: group).where('status', isEqualTo: 'approved').get();
      catProfiles==null?catProfiles=sub.docs:catProfiles.addAll(sub.docs);
    });


    var groupedCities = partition(selectedCities, 10);
    var citProfiles = [];
    groupedCities.forEach((group) async {
      var sub = await FirebaseFirestore.instance.collection('workers').where('cities', arrayContainsAny: group).where('status', isEqualTo: 'approved').get();
      citProfiles.addAll(sub.docs);
    });

    var groupedDates = partition(datesAndShifts, 10);
    var datProfiles = [];
    for(int i=0;i<groupedDates.length;i++){
      var sub = await FirebaseFirestore.instance.collection('workers').where('datesAndShifts', arrayContainsAny: groupedDates.toList()[i]).where('status', isEqualTo: 'approved').get();
      datProfiles.addAll(sub.docs);
    }

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
                  Scrollbar(
                    isAlwaysShown: true,
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
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
                    ),
                  ):Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setHeight(80)),
              child: Button(
                text: 'Afslut',
                padding: isTablet?width*0.025:10,
                onclick: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  List<String> emailList = prefs.getStringList('emailList');
                  List<String> notificationList = prefs.getStringList('notificationList');
                  if(emailList==null){
                    ToastBar(text: 'Ingen på listen!',color: Colors.red).show();
                  }
                  else{
                    SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                    pd.show(
                        message: 'Vent gerne',
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
                                content: 'Du har modtaget et nyt jobtilbud'
                            )
                        );
                      }
                      emailList.forEach((element) async {
                        await CustomEmail.sendEmail("Du har modtaget et nyt jobtilbud", "Tilbud modtaget", to: element);
                      });
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
                                          text: 'Tilbud sendt til udvalgte rekrutterere. Du vil modtage en e-mail og en notifikation, når de svarer på tilbuddet. Tjek venligst din indbakke eller spam-mappe.',
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
                      ToastBar(text: 'Noget gik galt',color: Colors.red).show();
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
