import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:findmee/widgets/toggle-button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EditDatesWeb extends StatefulWidget {
  final String email;

  const EditDatesWeb({Key key, this.email}) : super(key: key);

  @override
  _EditDatesWebState createState() => _EditDatesWebState();
}

class _EditDatesWebState extends State<EditDatesWeb> {
  bool morning = false;
  bool evening = false;
  bool night = false;
  DateTime _focusedDay = DateTime.now();
  List list = [];

  final Set<DateTime> _selectedDays = LinkedHashSet<DateTime>(
    equals: isSameDay,
  );

  _onCreated() async {
    var sub = await FirebaseFirestore.instance.collection('workers').where('email', isEqualTo: widget.email).get();
    var user = sub.docs;

    List datesAndShifts = user[0]['datesAndShifts'];
    datesAndShifts.forEach((element) {
      String year = element.toString().substring(0, 4);
      String month = element.toString().substring(5, 7);
      String day = element.toString().substring(8, 10);
      DateTime date = DateTime(int.parse(year), int.parse(month), int.parse(day));
      DateTime finalDate = DateTime.parse(DateFormat("yyyy-MM-dd HH:mm:ss'.000Z'").format(date));
      if(_selectedDays.contains(finalDate)){
        print("containing "+finalDate.toString());
        var x = list.where((element) => element['day']==DateFormat('yyyy-MM-dd').format(finalDate)).toList();
        bool morning = x[0]['morning'];
        bool evening = x[0]['evening'];
        bool night = x[0]['night'];
        list.removeWhere((element) => element['day']==DateFormat('yyyy-MM-dd').format(finalDate));
        // print(morning|(element.toString().substring(10, 13)=='mor'));
        // print(evening|(element.toString().substring(10, 13)=='eve'));
        // print(night|(element.toString().substring(10, 13)=='nig'));
        Map y = {
          'day': DateFormat('yyyy-MM-dd').format(finalDate),
          'morning': morning|(element.toString().substring(10, 13)=='mor'),
          'evening': evening|(element.toString().substring(10, 13)=='eve'),
          'night': night|(element.toString().substring(10, 13)=='nig'),
        };
        list.add(y);
      }
      else{
        _selectedDays.add(finalDate);
        list.removeWhere((element) => element['day']==DateFormat('yyyy-MM-dd').format(finalDate));
        Map x = {
          'day': DateFormat('yyyy-MM-dd').format(finalDate),
          'morning': element.toString().substring(10, 13)=='mor',
          'evening': element.toString().substring(10, 13)=='eve',
          'night': element.toString().substring(10, 13)=='nig',
        };
        list.add(x);
      }
    });
    setState(() {});
  }

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
    print(_selectedDays);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _onCreated();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: width*0.015,),
          Center(child: CustomText(text: 'Vælg datoer og tidspunkter, hvor du ønsker at arbejde',isBold: false, size: ScreenUtil().setSp(55),font: 'GoogleSans',)),

          Expanded(
            child: Row(
              children: [
                ///calendar
                Expanded(
                  child: Container(
                    height: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(width*0.1,width*0.028,width*0.05,0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0,0,width*0.01,0),
                              child: TableCalendar(
                                firstDay: DateTime.now(),
                                lastDay: DateTime(3000,12,31),
                                focusedDay: _focusedDay,
                                calendarFormat: CalendarFormat.month,
                                startingDayOfWeek: StartingDayOfWeek.monday,
                                availableGestures: AvailableGestures.none,
                                headerStyle: HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                  titleTextStyle: TextStyle(
                                      fontSize: width*0.012
                                  )
                                ),
                                calendarStyle: CalendarStyle(
                                  defaultTextStyle: TextStyle(
                                    fontSize: width*0.013
                                  ),
                                  disabledTextStyle: TextStyle(
                                      fontSize: width*0.013,
                                      color: Colors.grey
                                  ),
                                  selectedTextStyle: TextStyle(
                                      fontSize: width*0.013,
                                    color: Colors.white
                                  ),
                                  weekendTextStyle: TextStyle(
                                      fontSize: width*0.013
                                  ),
                                  todayTextStyle: TextStyle(
                                      fontSize: width*0.013
                                  ),
                                  selectedDecoration: BoxDecoration(
                                      color: Color(0xffFA1E0E),
                                      shape: BoxShape.circle,
                                  ),
                                ),
                                calendarBuilders: CalendarBuilders(
                                  dowBuilder: (context, day) {
                                    final text = DateFormat.E().format(day);
                                    return Center(
                                        child: Text(
                                          text,
                                          style: TextStyle(color: Colors.red, fontSize: width*0.01,),
                                        ),
                                      );
                                  },
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
                          ),
                          SizedBox(height: width*0.13,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
                            child: Button(text: 'Update',padding: width*0.01,color: Colors.green,onclick: () async {
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
                                await FirebaseFirestore.instance.collection('workers').doc(widget.email).update({
                                  'datesAndShifts': finalDatesAndShifts
                                });
                                MessageDialog.show(context: context, text: 'Dates Updated!',type: CoolAlertType.success);
                              }
                            }
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                ///dates
                Expanded(
                  child: Container(
                    color: Colors.white,
                    height: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(width*0.04,width*0.028,width*0.15,width*0.04),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            boxShadow: [BoxShadow(blurRadius: 20)]
                        ),
                        child: Scrollbar(
                          isAlwaysShown: true,
                          child: ListView.builder(
                            itemCount: _selectedDays.length,
                            itemBuilder: (context, i){
                              String date = DateFormat('yyyy-MM-dd').format(_selectedDays.elementAt(_selectedDays.length-(i+1)));

                              int index = list.indexWhere((element) => element['day']==date);
                              return ExpansionTile(
                                title: CustomText(text: date,size: width*0.01),
                                initiallyExpanded: false,
                                childrenPadding: EdgeInsets.symmetric(horizontal: width*0.05,vertical: ScreenUtil().setHeight(70)),
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
                                  SizedBox(height: ScreenUtil().setHeight(50),),
                                  ToggleButton(
                                    text: 'Aften',
                                    onclick: (){
                                      setState(() {
                                        list[index]['evening'] = !list[index]['evening'];
                                      });
                                    },
                                    isSelected: list[index]['evening'],
                                  ),
                                  SizedBox(height: ScreenUtil().setHeight(50),),
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
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


