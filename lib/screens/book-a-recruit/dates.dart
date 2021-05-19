import 'dart:collection';
import 'package:findmee/screens/book-a-recruit/profiles.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/toggle-button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

class Dates extends StatefulWidget {
  final String from;

  const Dates({Key key, this.from}) : super(key: key);
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
                        print(_selectedDays);

                        showDialog(
                            context: context,
                            builder: (BuildContext context){
                              return AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                insetPadding: EdgeInsets.symmetric(vertical: 24,horizontal: 10),
                                scrollable: true,
                                backgroundColor: Colors.white,
                                content: Container(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [

                                      ///check mark
                                      Container(
                                        width: ScreenUtil().setHeight(500),
                                        height: ScreenUtil().setHeight(500),
                                        color: Colors.red,
                                      ),
                                      SizedBox(height: ScreenUtil().setWidth(100),),

                                      ///text
                                      CustomText(
                                        text: 'Congratulatioes',
                                        font: 'ComicSans',
                                        size: ScreenUtil().setSp(70),
                                      ),
                                      SizedBox(height: ScreenUtil().setWidth(100),),

                                      ///text
                                      CustomText(
                                        text: 'Your account was successfully created. We will contact you when someone hired you.',
                                        font: 'ComicSans',
                                        isBold: false,
                                        size: ScreenUtil().setSp(55),
                                      ),
                                      SizedBox(height: ScreenUtil().setWidth(100),),
                                    ],
                                  ),
                                ),
                              );
                            });



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
