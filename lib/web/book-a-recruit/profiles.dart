import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../../email.dart';
import '../home-app.dart';

class ProfilesWeb extends StatefulWidget {
  @override
  _ProfilesWebState createState() => _ProfilesWebState();
}

class _ProfilesWebState extends State<ProfilesWeb> {
  var profiles = [];
  var catProfiles;
  List selectedCategories, selectedCities;
  List selectedDates = [];
  getProfiles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedCategories = prefs.getStringList('companyCategories');
    selectedCities = prefs.getStringList('companyCities');
    List datesAndShifts = prefs.getStringList('companyDatesAndShifts');

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
  getSelected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List dates = prefs.getStringList('companyDatesAndShifts');
    dates.forEach((element) {
      selectedDates.add(element.toString().substring(0, 10));
    });
    print(selectedDates);
    setState(() {});
  }
  hire({String email, String playerID}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> emailList = prefs.getStringList('emailList') ?? [];
    List<String> notList = prefs.getStringList('notificationList') ?? [];
    emailList.add(email);
    notList.add(playerID);
    prefs.setStringList('emailList', emailList);
    prefs.setStringList('notificationList', notList);
    MessageDialog.show(
      text: 'Added to List!',
      context: context,
      type: CoolAlertType.success
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProfiles();
    getSelected();
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
  List buildDates(List dates){
    List temp = [];
    Map data;
    List datesAndShifts = [];
    dates.forEach((element) {
      if(!temp.contains(element.toString().substring(0, 10))){
        temp.add(element.toString().substring(0, 10));
        var shifts = dates.where((x) => x.toString().startsWith(element.toString().substring(0, 10)));

        String shift = "";
        String day = element.toString().substring(0, 10);

        shifts.forEach((x) {
          if(x.contains('mor')){
            shift += 'Morgen, ';
          }
          if(x.contains('eve')){
            shift += 'Aften, ';
          }
          if(x.contains('nig')){
            shift += 'Nat, ';
          }
        });

        data = {
          'day': day,
          'shift': shift.substring(0, shift.length - 2)
        };
        datesAndShifts.add(data);
      }
    });
    return datesAndShifts;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ///appbar
          Container(
            color: Theme.of(context).primaryColor,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: width*0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox.shrink(),
                    CustomText(text: 'User Profiles',size: width*0.018,color: Colors.white,),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: ()async{
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            List<String> emailList = prefs.getStringList('emailList');

                            if(emailList==null){
                              MessageDialog.show(
                                context: context,
                                text: 'No one in the list!',
                              );
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


                                ///send notification
                                emailList.forEach((element) async {
                                  await CustomEmail.sendEmail("You received a new job offer", "Offer Received", to: element);
                                });
                                pd.hide();

                                showDialog(
                                    context: context,
                                    builder: (BuildContext context){
                                       return AlertDialog(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        scrollable: true,
                                        backgroundColor: Colors.white,
                                        content: Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [

                                              ///check mark
                                              Container(
                                                width: width*0.15,
                                                height: width*0.15,
                                                child: Center(child: Image.asset('assets/images/tick.gif')),
                                              ),

                                              ///text
                                              CustomText(
                                                text: 'Offer successfully sent to selected recruiters.\nYou will receive an email and a notification when they are respond to the offer. Please check your inbox or spam folders',
                                                font: 'ComicSans',
                                                isBold: false,
                                                size: width*0.015,
                                              ),
                                              SizedBox(height: width*0.05,),

                                              ///buttons
                                              ElevatedButton(
                                                onPressed: (){
                                                  Navigator.of(context).pushAndRemoveUntil(
                                                      CupertinoPageRoute(builder: (context) =>
                                                          HomeApp()), (Route<dynamic> route) => false);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  primary: Color(0xff00C853),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                  padding: EdgeInsets.all(width*0.01),
                                                ),
                                                child: CustomText(text: 'Go to Home',size: width*0.012,color: Colors.white,),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                prefs.remove('cart');
                                prefs.remove('emailList');
                                prefs.remove('notificationList');
                              }
                              catch(e){
                                pd.hide();
                                MessageDialog.show(
                                  context: context,
                                  text: 'Something went wrong',
                                );
                              }
                            }
                          },
                          child: Container(
                            width: width*0.13,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(width*0.002),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(child: Container(),),
                                  CustomText(text: 'Finish',size: width*0.013,),
                                  Expanded(child: Container(),),
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.horizontal(left: Radius.circular(5))
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(width*0.005),
                                        child: Icon(Icons.arrow_forward, color: Colors.white,size: width*0.01,),
                                      )
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),

          ///profiles
          Expanded(
              child: catProfiles!=null?
              profiles.isEmpty?Center(child: CustomText(text: 'No Profiles Found',color: Colors.black,size: width*0.01,font: 'GoogleSans',)):
              Scrollbar(
                isAlwaysShown: true,
                child: StaggeredGridView.countBuilder(
                  staggeredTileBuilder: (index)=> StaggeredTile.fit(1),
                  crossAxisCount: 3,
                  crossAxisSpacing: 35,
                  mainAxisSpacing: 25,
                  padding: EdgeInsets.all(30),
                  itemCount: profiles.length,
                  itemBuilder: (context, i){
                    List<MultiSelectItem> categories = buildCategories(profiles[i]['categories']);
                    List<MultiSelectItem> cities = buildCategories(profiles[i]['cities']);
                    List datesAndShifts = buildDates(profiles[i]['datesAndShifts']);
                    String name = profiles[i]['name'];
                    String surname = profiles[i]['surname'];
                    String profileImage = profiles[i]['profileImage'];
                    String experience = profiles[i]['experience'];
                    String email = profiles[i]['email'];
                    String playerID = profiles[i]['playerID'];

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
                          ///top
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///image
                              Padding(
                                padding: EdgeInsets.all(width*0.015),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: width*0.04,
                                  backgroundImage: CachedNetworkImageProvider(profileImage),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    ///name
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: width*0.005, horizontal: width*0.01),
                                          child: CustomText(text: name+" "+surname[0]+".",color: Colors.white,font: 'GoogleSans',size: width*0.01,),
                                        ),
                                      ),
                                    ),

                                    ///hire me
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(width*0.04, width*0.05, width*0.03 ,0),
                                      child: SizedBox(
                                        width: width*0.13,
                                        child: Button(
                                          color: Colors.red,
                                          text: 'Ansæet mig',
                                          image: 'hire.png',
                                          imageSize: 50,
                                          contentPadding: width*0.005,
                                          textSize: width*0.009,
                                          padding: width*0.005,
                                          onclick: ()=>hire(email: email,playerID: playerID),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),

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
                                initialValue: selectedCategories,
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
                                initialValue: selectedCities,
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
                          Container(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(width*0.015,width*0.008,width*0.01,width*0.01),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: datesAndShifts.length,
                                itemBuilder: (context, i){
                                  String day = datesAndShifts[i]['day'];
                                  String shift = datesAndShifts[i]['shift'];
                                  Color color = selectedDates.contains(day)?Colors.green:Colors.black;
                                  return Padding(
                                    padding:  EdgeInsets.only(bottom: width*0.008),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: color,
                                                borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                                                border: Border.all(width: 2,color: color)
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
                                                border: Border.all(width: 2,color: color)
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(width*0.005),
                                              child: CustomText(text: shift,font: 'GoogleSans',isBold: false,size: width*0.01,align: TextAlign.start,),
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

                          ///experience
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
                                  text: 'Erfaring',
                                  color: Color(0xff52575D),
                                  size: width*0.012,
                                  align: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(width*0.015,width*0.01,width*0.01,width*0.01),
                            child: CustomText(
                              text: experience,
                              align: TextAlign.justify,
                              size: width*0.01,
                              isBold: false,
                            ),
                          ),
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
