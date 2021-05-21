import 'dart:collection';
import 'package:findmee/screens/book-a-recruit/profiles.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/toggle-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
  );

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }
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
              padding: EdgeInsets.all(ScreenUtil().setWidth(45)),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: ScreenUtil().setHeight(30),),
                    CustomText(text: 'Dates and Shifts',size: ScreenUtil().setSp(60),align: TextAlign.start,),
                    SizedBox(height: ScreenUtil().setHeight(100),),
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

                    ///toggle buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ToggleButton(
                          text: 'Morning',
                          onclick: (){
                            setState(() {
                              morning = !morning;
                            });
                          },
                          isSelected: morning,
                        ),
                        ToggleButton(
                          text: 'Evening',
                          onclick: (){
                            setState(() {
                              evening = !evening;
                            });
                          },
                          isSelected: evening,
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil().setHeight(70),),
                    Center(
                      child: ToggleButton(
                        text: 'Night',
                        onclick: (){
                          setState(() {
                            night = !night;
                          });
                        },
                        isSelected: night,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                      child: Button(text: 'Next',onclick: () async {
                        List<String> dates = [];
                        _selectedDays.forEach((element) {
                          dates.add(element.toString());
                        });
                        List<String> shifts = [];
                        if(morning) shifts.add('Morning');
                        if(evening) shifts.add('Evening');
                        if(night) shifts.add('Night');
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setStringList('companyDates', dates);
                        prefs.setStringList('companyShifts', shifts);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => Profiles()),
                        );
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
