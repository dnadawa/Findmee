import 'dart:collection';
import 'dart:convert';
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

import '../../responsive.dart';

class RecruitDates extends StatefulWidget {
  final PageController controller;

  const RecruitDates({Key key, this.controller}) : super(key: key);
  @override
  _RecruitDatesState createState() => _RecruitDatesState();
}

class _RecruitDatesState extends State<RecruitDates> {
  bool morning = false;
  bool evening = false;
  bool night = false;
  DateTime _focusedDay = DateTime.now();
  List list = [];
  final _scrollController = ScrollController();

  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
  );

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      if (_selectedDays.contains(selectedDay)) {
        _selectedDays.remove(selectedDay);
      } else {
        _selectedDays.add(selectedDay);
      }
    });
    _selectedDays.forEach((element) {
      list.removeWhere((element) => element['day']==DateFormat('yyyy-MM-dd').format(selectedDay));
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
    print(list);
  }

  @override
  Widget build(BuildContext context) {
    bool isTablet = Responsive.isTablet(context);
    double width = MediaQuery.of(context).size.width;
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
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: ScreenUtil().setHeight(30),),
                      CustomText(text: 'Datoer.',size: ScreenUtil().setSp(90),align: TextAlign.start,color: Color(0xff52575D)),
                      SizedBox(height: ScreenUtil().setHeight(50),),
                      CustomText(text: 'Vælg gerne dato/datoer og tider når du vil arbejde',size: ScreenUtil().setSp(45),align: TextAlign.start,font: 'GoogleSans',),
                      SizedBox(height: ScreenUtil().setHeight(100),),
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

                          int index = list.indexWhere((element) => element['day']==date);
                          return ExpansionTile(
                            title: CustomText(text: date,),
                            initiallyExpanded: true,
                            childrenPadding: EdgeInsets.only(bottom: ScreenUtil().setHeight(40)),
                            children: [
                              ///toggle buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ToggleButton(
                                    text: 'Morgen',
                                    onclick: (){
                                      setState(() {
                                        list[index]['morning'] = !list[index]['morning'];
                                      });
                                    },
                                    isSelected: list[index]['morning'],
                                  ),
                                  ToggleButton(
                                    text: 'Aften',
                                    onclick: (){
                                      setState(() {
                                        list[index]['evening'] = !list[index]['evening'];
                                      });
                                    },
                                    isSelected: list[index]['evening'],
                                  ),
                                ],
                              ),
                              SizedBox(height: ScreenUtil().setHeight(70),),
                              Center(
                                child: ToggleButton(
                                  text: 'Nat',
                                  onclick: (){
                                    setState(() {
                                      list[index]['night'] = !list[index]['night'];
                                    });
                                  },
                                  isSelected: list[index]['night'],
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      ///button
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                        child: Button(text: 'Næste',padding: isTablet?width*0.025:10,onclick: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          Map data = jsonDecode(prefs.getString('data'));

                          Set datesAndShifts = {};
                          list.forEach((element) {
                            String day = element['day'];
                            if(element['morning']){
                              datesAndShifts.add(day+'mor');
                            }
                            if(element['evening']){
                              datesAndShifts.add(day+'eve');
                            }
                            if(element['night']){
                              datesAndShifts.add(day+'nig');
                            }
                          });

                          List<String> finalDatesAndShifts = [];
                          datesAndShifts.forEach((element) {
                            finalDatesAndShifts.add(element);
                          });

                          if(_selectedDays.isEmpty || finalDatesAndShifts.isEmpty){
                            ToastBar(text: 'Please select at least one date and shift', color: Colors.red).show();
                          }
                          else{
                            data['datesAndShifts'] = finalDatesAndShifts;
                            prefs.setString('data', jsonEncode(data));
                            widget.controller.animateToPage(5,curve: Curves.ease,duration: Duration(milliseconds: 200));
                          }
                        }),
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
