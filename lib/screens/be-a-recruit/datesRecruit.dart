import 'dart:collection';
import 'dart:convert';
import 'package:findmee/screens/book-a-recruit/profiles.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:findmee/widgets/toggle-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class RecruitDates extends StatefulWidget {
  final PageController controller;

  const RecruitDates({Key key, this.controller}) : super(key: key);
  @override
  _RecruitDatesState createState() => _RecruitDatesState();
}

class _RecruitDatesState extends State<RecruitDates> {
  //
  // void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
  //   list.clear();
  //   setState(() {
  //     if (_selectedDays.contains(selectedDay)) {
  //       _selectedDays.remove(selectedDay);
  //     } else {
  //       _selectedDays.add(selectedDay);
  //     }
  //   });
  //   _selectedDays.forEach((element) {
  //     Map x = {
  //       'day': DateFormat('yyyy-MM-dd').format(element),
  //       'morning': false,
  //       'evening': false,
  //       'night': false,
  //     };
  //
  //     // if(!list.any((element) => mapEquals(element, x))){
  //     //   list.add(x);
  //     // }
  //     list.add(x);
  //   });
  // }
  int selectedDay = 1;
  List x = [
    {'mor' : false, 'eve': false, 'nig': false},
    {'mor' : false, 'eve': false, 'nig': false},
    {'mor' : false, 'eve': false, 'nig': false},
    {'mor' : false, 'eve': false, 'nig': false},
    {'mor' : false, 'eve': false, 'nig': false},
    {'mor' : false, 'eve': false, 'nig': false},
    {'mor' : false, 'eve': false, 'nig': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(45)),
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              )
          ),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(65)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    CustomText(text: 'Dates and Shifts',size: ScreenUtil().setSp(90),align: TextAlign.start,color: Color(0xff52575D)),
                    SizedBox(height: ScreenUtil().setHeight(50),),
                    CustomText(text: 'Select date/dates and relevant shifts that you need to hire a recruiter',size: ScreenUtil().setSp(45),align: TextAlign.start,font: 'GoogleSans',),
                    SizedBox(height: ScreenUtil().setHeight(40),),
                    Center(
                      child: SizedBox(
                          width: ScreenUtil().setHeight(600),
                          // height: ScreenUtil().setWidth(400),
                          child: Image.asset('assets/images/calendar.png')),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(100),),

                    ///dropdown
                    Center(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:  Color(0xfff5f5f5),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(40)),
                          child: DropdownButton(
                            underline: Divider(color:  Color(0xfff5f5f5),height: 0,thickness: 0,),
                            dropdownColor: Color(0xfff5f5f5),
                            iconEnabledColor: Colors.black,
                            isExpanded: true,
                            items: [
                              DropdownMenuItem(child: CustomText(text: 'Monday',font: 'GoogleSans',),value: 1,),
                              DropdownMenuItem(child: CustomText(text: 'Tuesday',font: 'GoogleSans',),value: 2,),
                              DropdownMenuItem(child: CustomText(text: 'Wednesday',font: 'GoogleSans',),value: 3,),
                              DropdownMenuItem(child: CustomText(text: 'Thursday',font: 'GoogleSans',),value: 4,),
                              DropdownMenuItem(child: CustomText(text: 'Friday',font: 'GoogleSans',),value: 5,),
                              DropdownMenuItem(child: CustomText(text: 'Saturday',font: 'GoogleSans',),value: 6,),
                              DropdownMenuItem(child: CustomText(text: 'Sunday',font: 'GoogleSans',),value: 7,),
                            ],
                            onChanged:(newValue){
                              setState(() {
                                selectedDay = newValue;
                              });
                            },
                            value: selectedDay,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(250),),


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
                              child: CustomText(text: 'Shift/Shifts',color: Colors.white,isBold: false,align: TextAlign.start,size: ScreenUtil().setSp(45),),
                            ),
                          ),

                          ///body
                          Container(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.all(ScreenUtil().setHeight(50)),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: ToggleButton(
                                          text: 'Morning',
                                          onclick: (){
                                            setState(() {
                                              x[selectedDay-1]['mor'] = !x[selectedDay-1]['mor'];
                                            });
                                          },
                                          isSelected: x[selectedDay-1]['mor'],
                                        ),
                                      ),
                                      SizedBox(width: ScreenUtil().setHeight(40),),
                                      Expanded(
                                        child: ToggleButton(
                                          text: 'Evening',
                                          onclick: (){
                                            setState(() {
                                              x[selectedDay-1]['eve'] = !x[selectedDay-1]['eve'];
                                            });
                                          },
                                          isSelected: x[selectedDay-1]['eve'],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(40),),
                                  Center(
                                    child: ToggleButton(
                                      text: 'Night',
                                      onclick: (){
                                        setState(() {
                                          x[selectedDay-1]['nig'] = !x[selectedDay-1]['nig'];
                                        });
                                      },
                                      isSelected: x[selectedDay-1]['nig'],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil().setHeight(250),),

                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                      child: Button(text: 'Next',onclick: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        Map data = jsonDecode(prefs.getString('data'));

                        List datesAndShifts = [];
                        for(int i=0;i<x.length;i++){
                          if(x[i]['mor']){
                            datesAndShifts.add('${i+1}mor');
                          }
                          if(x[i]['eve']){
                            datesAndShifts.add('${i+1}eve');
                          }
                          if(x[i]['nig']){
                            datesAndShifts.add('${i+1}nig');
                          }
                        }

                        data['datesAndShifts'] = datesAndShifts;
                        prefs.setString('data', jsonEncode(data));
                        widget.controller.animateToPage(4,curve: Curves.ease,duration: Duration(milliseconds: 200));
                      }),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
