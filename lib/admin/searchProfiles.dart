import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data.dart';
import '../responsive.dart';

class SearchProfiles extends StatefulWidget {
  @override
  _SearchProfilesState createState() => _SearchProfilesState();
}

class _SearchProfilesState extends State<SearchProfiles> {

  List categories = Data().categories;
  List cities = Data().cities;
  DateTime _focusedDay = DateTime.now();
  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
  );
  var profiles = [];
  var catProfiles;
  final _scrollController = ScrollController();

  getProfiles() async {
    profiles = [];
    SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
    pd.show(
        message: 'Please wait',
        type: SimpleFontelicoProgressDialogType.custom,
        loadingIndicator: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),)
    );

    ///build categories
    List<String> selectedCategories = [];
    for(int i=0;i<categories.length;i++){
      if(categories[i]['selected']){
        selectedCategories.add(categories[i]['category']);
      }
    }

    ///build cities
    List<String> selectedCities = [];
    for(int i=0;i<cities.length;i++){
      if(cities[i]['selected']){
        selectedCities.add(cities[i]['city']);
      }
    }


    ///build dates and shifts
    List<String> datesAndShifts = [];
    _selectedDays.forEach((element) {
      String date = DateFormat('yyyy-MM-dd').format(element);
      datesAndShifts.add(date+'mor');
      datesAndShifts.add(date+'eve');
      datesAndShifts.add(date+'nig');
    });

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

    pd.hide();
    setState(() {});
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
    double width;
    double profileWidth;
    bool isTablet = Responsive.isTablet(context);
    bool isDesktop = Responsive.isDesktop(context);
    if(isDesktop){
      width = MediaQuery.of(context).size.width*0.25;
      profileWidth = MediaQuery.of(context).size.width;
    }
    else if(isTablet){
      width = MediaQuery.of(context).size.width*0.4;
      profileWidth = MediaQuery.of(context).size.width*1.6;
    }
    else{
      width = MediaQuery.of(context).size.width;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ///filters
          Padding(
            padding: EdgeInsets.all(width*0.15),
            child: Row(
              children: [
                ///dates
                Expanded(
                  flex: 2,
                  child: Container(
                    height: width*0.13,
                    decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      border: Border(right: BorderSide(color: Color(0xffFA1E0E), width: 2))
                    ),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ListTile(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return StatefulBuilder(
                                  builder: (context, setState){
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      content: Container(
                                        width: width,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TableCalendar(
                                              firstDay: DateTime.now(),
                                              lastDay: DateTime(3000,12,31),
                                              focusedDay: _focusedDay,
                                              calendarFormat: CalendarFormat.month,
                                              startingDayOfWeek: StartingDayOfWeek.monday,
                                              availableGestures: AvailableGestures.none,
                                              headerStyle: HeaderStyle(
                                                  formatButtonVisible: false,
                                                  titleCentered: true
                                              ),
                                              calendarStyle: CalendarStyle(
                                                selectedDecoration: BoxDecoration(
                                                    color: Color(0xffFA1E0E),
                                                    shape: BoxShape.circle
                                                ),
                                              ),
                                              onPageChanged: (focusedDay) {
                                                _focusedDay = focusedDay;
                                              },
                                              selectedDayPredicate: (day) {
                                                return _selectedDays.contains(day);
                                              },
                                              onDaySelected: (selectedDay, focusedDay){
                                                setState(() {
                                                  _focusedDay = focusedDay;
                                                  if (_selectedDays.contains(selectedDay)) {
                                                    _selectedDays.remove(selectedDay);
                                                  } else {
                                                    _selectedDays.add(selectedDay);
                                                  }
                                                });
                                              },
                                            ),
                                            SizedBox(height: width*0.1,),
                                            Button(
                                              text: 'OK',
                                              padding: width*0.05,
                                              color: Colors.red,
                                              onclick: ()=>Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                          );
                        },
                        title: CustomText(text: 'Pick date/dates',font: 'GoogleSans',isBold: false, color: Colors.black,),
                        trailing: Icon(Icons.arrow_drop_down, color: Colors.black,),
                      ),
                    ),
                  ),
                ),

                ///categories
                Expanded(
                  flex: 2,
                  child: Container(
                    height: width*0.13,
                    decoration: BoxDecoration(
                        color: Color(0xfff5f5f5),
                        border: Border(right: BorderSide(color: Color(0xffFA1E0E), width: 2))
                    ),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ListTile(
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return StatefulBuilder(
                                builder: (context, setState){
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    content: Container(
                                      height: width*2,
                                      width: width,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Scrollbar(
                                              controller: _scrollController,
                                              isAlwaysShown: true,
                                              child: ListView.builder(
                                                controller: _scrollController,
                                                itemCount: categories.length,
                                                itemBuilder: (context,i){
                                                  return CheckboxListTile(
                                                    title: CustomText(text: categories[i]['category'],font: 'GoogleSans',align: TextAlign.start,size: ScreenUtil().setSp(50),isBold: false,),
                                                    value: categories[i]['selected'],
                                                    contentPadding: EdgeInsets.zero,
                                                    dense: true,
                                                    activeColor: Theme.of(context).primaryColor,
                                                    controlAffinity: ListTileControlAffinity.leading,
                                                    onChanged: (value){
                                                      setState(() {
                                                        categories[i]['selected'] = value;
                                                      });
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          Button(
                                            text: 'OK',
                                            padding: width*0.05,
                                            color: Colors.red,
                                            onclick: ()=>Navigator.pop(context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          );
                        },
                        title: CustomText(text: 'Pick category/categories',font: 'GoogleSans',isBold: false, color: Colors.black,),
                        trailing: Icon(Icons.arrow_drop_down, color: Colors.black,),
                      ),
                    ),
                  ),
                ),

                ///cities
                Expanded(
                  flex: 2,
                  child: Container(
                    height: width*0.13,
                    decoration: BoxDecoration(
                        color: Color(0xfff5f5f5),
                        border: Border(right: BorderSide(color: Color(0xffFA1E0E), width: 2))
                    ),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ListTile(
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return StatefulBuilder(
                                  builder: (context, setState){
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      content: Container(
                                        height: width*2,
                                        width: width,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: Scrollbar(
                                                isAlwaysShown: true,
                                                controller: _scrollController,
                                                child: ListView.builder(
                                                  itemCount: cities.length,
                                                  controller: _scrollController,
                                                  itemBuilder: (context,i){
                                                    return CheckboxListTile(
                                                      title: CustomText(text: cities[i]['city'],font: 'GoogleSans',align: TextAlign.start,size: ScreenUtil().setSp(50),isBold: false,),
                                                      value: cities[i]['selected'],
                                                      contentPadding: EdgeInsets.zero,
                                                      dense: true,
                                                      activeColor: Theme.of(context).primaryColor,
                                                      controlAffinity: ListTileControlAffinity.leading,
                                                      onChanged: (value){
                                                        setState(() {
                                                          cities[i]['selected'] = value;
                                                        });
                                                      },
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                            Button(
                                              text: 'OK',
                                              padding: width*0.05,
                                              color: Colors.red,
                                              onclick: ()=>Navigator.pop(context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                          );
                        },
                        title: CustomText(text: 'Pick city/cities',font: 'GoogleSans',isBold: false, color: Colors.black,),
                        trailing: Icon(Icons.arrow_drop_down, color: Colors.black,),
                      ),
                    ),
                  ),
                ),

                ///search
                Expanded(
                  flex: 1,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: ()=>getProfiles(),
                      child: Container(
                        height: width*0.13,
                        color: Colors.red,
                        child: Center(child: CustomText(text: 'Search',color: Colors.white,font: 'GoogleSans',size: width*0.06,)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          ///profiles
          Expanded(
              child: catProfiles!=null?
              profiles.isEmpty?Center(child: CustomText(text: 'No Profiles Found',color: Colors.black,size: profileWidth*0.01,font: 'GoogleSans',)):
              Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: StaggeredGridView.countBuilder(
                  controller: _scrollController,
                  staggeredTileBuilder: (index)=> StaggeredTile.fit(1),
                  crossAxisCount: isDesktop?3:isTablet?2:1,
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
                                padding: EdgeInsets.all(profileWidth*0.015),
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: profileWidth*0.04,
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
                                          padding: EdgeInsets.symmetric(vertical: profileWidth*0.005, horizontal: profileWidth*0.01),
                                          child: CustomText(text: name+" "+surname[0]+".",color: Colors.white,font: 'GoogleSans',size: profileWidth*0.01,),
                                        ),
                                      ),
                                    ),
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
                                padding: EdgeInsets.symmetric(vertical: profileWidth*0.005, horizontal: profileWidth*0.015),
                                child: CustomText(
                                  text: 'Kategori/ Kategorier',
                                  color: Color(0xff52575D),
                                  size: profileWidth*0.012,
                                  align: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: profileWidth*0.009),
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
                          SizedBox(height: profileWidth*0.01,),

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
                                padding: EdgeInsets.symmetric(vertical: profileWidth*0.005, horizontal: profileWidth*0.015),
                                child: CustomText(
                                  text: 'By /Byer',
                                  color: Color(0xff52575D),
                                  size: profileWidth*0.012,
                                  align: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: profileWidth*0.009),
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
                                padding: EdgeInsets.symmetric(vertical: profileWidth*0.005, horizontal: profileWidth*0.015),
                                child: CustomText(
                                  text: 'Ledige arbejdsdage og tider',
                                  color: Color(0xff52575D),
                                  size: profileWidth*0.012,
                                  align: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(profileWidth*0.015,profileWidth*0.008,profileWidth*0.01,profileWidth*0.01),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: datesAndShifts.length,
                                itemBuilder: (context, i){
                                  String day = datesAndShifts[i]['day'];
                                  String shift = datesAndShifts[i]['shift'];
                                  Color color = Colors.black;
                                  return Padding(
                                    padding:  EdgeInsets.only(bottom: profileWidth*0.008),
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
                                              padding: EdgeInsets.all(profileWidth*0.005),
                                              child: CustomText(text: day,color: Colors.white,font: 'GoogleSans',size: profileWidth*0.01),
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
                                              padding: EdgeInsets.all(profileWidth*0.005),
                                              child: CustomText(text: shift,font: 'GoogleSans',isBold: false,size: profileWidth*0.01,align: TextAlign.start,),
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
                                padding: EdgeInsets.symmetric(vertical: profileWidth*0.005, horizontal: profileWidth*0.015),
                                child: CustomText(
                                  text: 'Erfaring',
                                  color: Color(0xff52575D),
                                  size: profileWidth*0.012,
                                  align: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(profileWidth*0.015,profileWidth*0.01,profileWidth*0.01,profileWidth*0.01),
                            child: CustomText(
                              text: experience,
                              align: TextAlign.justify,
                              size: profileWidth*0.01,
                              isBold: false,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ):Center(child: Container(),)
          )
        ],
      ),
    );
  }
}
