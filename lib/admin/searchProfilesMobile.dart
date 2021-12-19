import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:quiver/iterables.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:table_calendar/table_calendar.dart';

import '../data.dart';


class SearchProfilesMobile extends StatefulWidget {
  @override
  _SearchProfilesMobileState createState() => _SearchProfilesMobileState();
}

class _SearchProfilesMobileState extends State<SearchProfilesMobile> {

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
        message: 'Vent venligst',
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
  void initState() {
    // TODO: implement initState
    initializeDateFormatting();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    double profileWidth = MediaQuery.of(context).size.width* 4;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setWidth(50)),
            child: Column(
              children: [
                ///dates
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      border: Border(bottom: BorderSide(color: Color(0xffFA1E0E), width: 2))
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
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TableCalendar(
                                            locale: 'da_DK',
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
                                          SizedBox(height: ScreenUtil().setHeight(100),),
                                          Button(
                                            text: 'OK',
                                            padding: ScreenUtil().setHeight(30),
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
                      title: CustomText(text: 'Vælg dato/datoer',font: 'GoogleSans',isBold: false, color: Colors.black,),
                      trailing: Icon(Icons.arrow_drop_down, color: Colors.black,),
                    ),
                  ),
                ),

                ///categories
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      border: Border(bottom: BorderSide(color: Color(0xffFA1E0E), width: 2))
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
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: Scrollbar(
                                              isAlwaysShown: true,
                                              controller: _scrollController,
                                              child: ListView.builder(
                                                itemCount: categories.length,
                                                controller: _scrollController,
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
                                            padding: ScreenUtil().setHeight(30),
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
                      title: CustomText(text: 'Vælg kategori/kategorier',font: 'GoogleSans',isBold: false, color: Colors.black,),
                      trailing: Icon(Icons.arrow_drop_down, color: Colors.black,),
                    ),
                  ),
                ),

                ///cities
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      border: Border(bottom: BorderSide(color: Color(0xffFA1E0E), width: 2))
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
                                      width: MediaQuery.of(context).size.width,
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
                                            padding: ScreenUtil().setHeight(30),
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
                      title: CustomText(text: 'Vælg by/byer',font: 'GoogleSans',isBold: false, color: Colors.black,),
                      trailing: Icon(Icons.arrow_drop_down, color: Colors.black,),
                    ),
                  ),
                ),

                ///search
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: ()=>getProfiles(),
                    child: Container(
                      color: Colors.red,
                      child: Center(child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                        child: CustomText(text: 'Søg',color: Colors.white,font: 'GoogleSans',size: ScreenUtil().setSp(65),),
                      )),
                    ),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(50),),
              ],
            ),
          ),

          Expanded(
              child: catProfiles!=null?
              profiles.isEmpty?Center(child: CustomText(text: 'Ingen profiler fundet',color: Colors.black,size: profileWidth*0.01,font: 'GoogleSans',)):
              Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: ListView.builder(
                  padding: EdgeInsets.all(ScreenUtil().setWidth(50)),
                  controller: _scrollController,
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
                          SizedBox(height: profileWidth*0.01,),

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
          ),
        ],
      ),
    );
  }
}
