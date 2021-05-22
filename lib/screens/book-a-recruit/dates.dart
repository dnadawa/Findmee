import 'dart:collection';
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

class Dates extends StatefulWidget {
  @override
  _DatesState createState() => _DatesState();
}

class _DatesState extends State<Dates> {
  bool morning = false;
  bool evening = false;
  bool night = false;

  List list = [];

  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
  );

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    list.clear();
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }
    });
    _selectedDays.forEach((element) {
      Map x = {
        'day': DateFormat('yyyy-MM-dd').format(element),
        'morning': false,
        'evening': false,
        'night': false,
      };

      // if(!list.any((element) => mapEquals(element, x))){
      //   list.add(x);
      // }
      list.add(x);
    });
  }

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
                    SizedBox(height: ScreenUtil().setHeight(100),),
                    TableCalendar(
                      firstDay: DateTime(2021,1,1),
                      lastDay: DateTime(2021,12,12),
                      focusedDay: DateTime.now(),
                      calendarFormat: CalendarFormat.month,
                      startingDayOfWeek: StartingDayOfWeek.monday,
                      selectedDayPredicate: (day) {
                        return _selectedDays.contains(day);
                      },
                      onDaySelected: _onDaySelected,
                    ),
                    SizedBox(height: ScreenUtil().setHeight(40),),

                    ///dates
                    ListView.builder(
                      itemCount: _selectedDays.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i){
                        String date = DateFormat('yyyy-MM-dd').format(_selectedDays.elementAt(i));

                        return Padding(
                          padding:  EdgeInsets.only(bottom: ScreenUtil().setHeight(30)),
                          child: ExpansionTile(
                            title: CustomText(text: date,),
                            childrenPadding: EdgeInsets.only(bottom: ScreenUtil().setHeight(40)),
                            children: [
                              ///toggle buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ToggleButton(
                                    text: 'Morning',
                                    onclick: (){
                                      setState(() {
                                        list[i]['morning'] = !list[i]['morning'];
                                      });
                                    },
                                    isSelected: list[i]['morning'],
                                  ),
                                  ToggleButton(
                                    text: 'Evening',
                                    onclick: (){
                                      setState(() {
                                        list[i]['evening'] = !list[i]['evening'];
                                      });
                                    },
                                    isSelected: list[i]['evening'],
                                  ),
                                ],
                              ),
                              SizedBox(height: ScreenUtil().setHeight(70),),
                              Center(
                                child: ToggleButton(
                                  text: 'Night',
                                  onclick: (){
                                    setState(() {
                                      list[i]['night'] = !list[i]['night'];
                                    });
                                  },
                                  isSelected: list[i]['night'],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                      child: Button(text: 'Next',onclick: () async {

                        Set datesAndShifts = {};
                        list.forEach((element) {
                          int day = DateTime.parse(element['day']).weekday;
                          if(element['morning']){
                            datesAndShifts.add(day.toString()+'mor');
                          }
                          if(element['evening']){
                            datesAndShifts.add(day.toString()+'eve');
                          }
                          if(element['night']){
                            datesAndShifts.add(day.toString()+'nig');
                          }
                        });

                        List<String> finalDatesAndShifts = [];
                        datesAndShifts.forEach((element) {
                          finalDatesAndShifts.add(element);
                        });

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setStringList('companyDatesAndShifts', finalDatesAndShifts);

                        List<String> dates = [];
                        _selectedDays.forEach((element) {
                          dates.add(element.toString());
                        });

                        prefs.setStringList('companyDates', dates);

                        if(_selectedDays.isEmpty || finalDatesAndShifts.isEmpty){
                          ToastBar(text: 'Please select at least one date and shift', color: Colors.red).show();
                        }
                        else{
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => Profiles()),
                          );
                        }












                        // List<String> dates = [];
                        // _selectedDays.forEach((element) {
                        //   dates.add(element.toString());
                        // });
                        // List<String> shifts = [];
                        // if(morning) shifts.add('mon');
                        // if(evening) shifts.add('eve');
                        // if(night) shifts.add('nig');
                        // SharedPreferences prefs = await SharedPreferences.getInstance();
                        // prefs.setStringList('companyDates', dates);
                        // prefs.setStringList('companyShifts', shifts);
                        // Navigator.push(
                        //   context,
                        //   CupertinoPageRoute(builder: (context) => Profiles()),
                        // );
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
