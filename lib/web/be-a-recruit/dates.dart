import 'dart:collection';
import 'dart:convert';

import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:findmee/widgets/toggle-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class DatesWebWorker extends StatefulWidget {
  final PageController controller;

  const DatesWebWorker({Key key, this.controller}) : super(key: key);

  @override
  _DatesWebWorkerState createState() => _DatesWebWorkerState();
}

class _DatesWebWorkerState extends State<DatesWebWorker> {
  bool morning = false;
  bool evening = false;
  bool night = false;
  DateTime _focusedDay = DateTime.now();
  List list = [];

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
    double width = MediaQuery.of(context).size.width;

    return Scrollbar(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(width*0.05,width*0.04,width*0.1,0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: ScreenUtil().setHeight(30),),
              CustomText(text: 'Datoer.',size: ScreenUtil().setSp(100),align: TextAlign.start,color: Color(0xff52575D)),
              SizedBox(height: ScreenUtil().setHeight(50),),
              CustomText(text: 'Vælg gerne dato/datoer og tider når du vil arbejde',size: ScreenUtil().setSp(45),align: TextAlign.start,font: 'GoogleSans',),
              SizedBox(height: width*0.03,),

              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: TableCalendar(
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
                    title: CustomText(text: date,size: width*0.01,),
                    initiallyExpanded: true,
                    childrenPadding: EdgeInsets.only(bottom: ScreenUtil().setHeight(40)),
                    children: [
                      ///toggle buttons
                      ToggleButton(
                        text: 'Morgen',
                        onclick: (){
                          setState(() {
                            list[index]['morning'] = !list[index]['morning'];
                          });
                        },
                        isSelected: list[index]['morning'],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(70),),
                      ToggleButton(
                        text: 'Aften',
                        onclick: (){
                          setState(() {
                            list[index]['evening'] = !list[index]['evening'];
                          });
                        },
                        isSelected: list[index]['evening'],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(70),),
                      ToggleButton(
                        text: 'Nat',
                        onclick: (){
                          setState(() {
                            list[index]['night'] = !list[index]['night'];
                          });
                        },
                        isSelected: list[index]['night'],
                      ),
                    ],
                  );
                },
              ),

              SizedBox(height: ScreenUtil().setHeight(80),),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20), vertical: ScreenUtil().setWidth(40)),
                child: Button(text: 'Næste',padding: width*0.01,color: Colors.red,onclick: () async {
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
                    MessageDialog.show(context: context, text: 'Please select at least one date and shift');
                  }
                  else{
                    data['datesAndShifts'] = finalDatesAndShifts;
                    prefs.setString('data', jsonEncode(data));
                    widget.controller.animateToPage(5,curve: Curves.ease,duration: Duration(milliseconds: 200));
                  }
                }
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
