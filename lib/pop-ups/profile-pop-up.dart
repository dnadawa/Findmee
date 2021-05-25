import 'package:findmee/data.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePopUp extends StatefulWidget {
  final List categories;
  final List cities;
  final String experience;
  final List userDatesAndShifts;
  final List selectedCategories;
  final List selectedCities;
  final String email;
  final String name;
  final String surname;
  final String cpr;
  final String phone;

  const ProfilePopUp({Key key, this.categories, this.cities, this.experience, this.userDatesAndShifts, this.selectedCategories, this.selectedCities, this.email, this.name, this.surname, this.cpr, this.phone}) : super(key: key);
  @override
  _ProfilePopUpState createState() => _ProfilePopUpState();
}

class _ProfilePopUpState extends State<ProfilePopUp> {
  TextEditingController experience  = TextEditingController();
  List<MultiSelectItem> categories = [];
  List<MultiSelectItem> cities = [];
  List datesAndShifts = [];
  List selectedDates = [];

  getSelected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List dates = prefs.getStringList('companyDates');
    dates.forEach((element) {
      selectedDates.add(Data().getDay(DateTime.parse(element).weekday.toString()));
    });
    setState(() {});
    print(widget.selectedCategories);
    print(widget.selectedCities);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ///get selected dates
    getSelected();

    ///create categories chips
    widget.categories.forEach((element) {
      categories.add(
          MultiSelectItem(element, element)
      );
    });

    ///create cities chips
    widget.cities.forEach((element) {
      cities.add(
          MultiSelectItem(element, element)
      );
    });

    experience.text = widget.experience;

    ///get all dates and shifts
    List temp = [];
    Map data;
    widget.userDatesAndShifts.forEach((element) {
      if(!temp.contains(element[0])){
        temp.add(element[0]);
        var shifts = widget.userDatesAndShifts.where((x) => x.toString().startsWith(element[0]));

        String shift = "";
        String day = Data().getDay(element[0]);

        shifts.forEach((x) {
          if(x.contains('mor')){
            shift += 'Morning, ';
          }
          if(x.contains('eve')){
            shift += 'Evening, ';
          }
          if(x.contains('nig')){
            shift += 'Night, ';
          }
        });

        data = {
          'day': day,
          'shift': shift.substring(0, shift.length - 2)
        };
        datesAndShifts.add(data);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: EdgeInsets.symmetric(vertical: 24,horizontal: 10),
      backgroundColor: Colors.white,
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              ///categories
              AbsorbPointer(
                absorbing: true,
                child: MultiSelectChipField(
                  title: Text(
                    'Category/Categories',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  headerColor: Theme.of(context).primaryColor,
                  chipShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),side: BorderSide(color: Colors.black)),
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor,width: 2),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  selectedChipColor: Color(0xff00C853),
                  selectedTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'GoogleSans'),
                  textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'GoogleSans'),
                  scroll: false,
                  initialValue: widget.selectedCategories,
                  items: categories,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(60),),

              ///cities
              AbsorbPointer(
                absorbing: true,
                child: MultiSelectChipField(
                  title: Text(
                    'City/Cities',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                  headerColor: Theme.of(context).primaryColor,
                  chipShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0),side: BorderSide(color: Colors.black)),
                  decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor,width: 2),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  selectedChipColor: Color(0xff00C853),
                  selectedTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontFamily: 'GoogleSans'),
                  textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold, fontFamily: 'GoogleSans'),
                  scroll: false,
                  initialValue: widget.selectedCities,
                  items: cities,
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(60),),

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
                        child: CustomText(text: 'Available Working Days & Shifts',color: Colors.white,align: TextAlign.start,size: ScreenUtil().setSp(45),),
                      ),
                    ),

                    ///body
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: datesAndShifts.length,
                          itemBuilder: (context, i){
                            String day = datesAndShifts[i]['day'];
                            String shift = datesAndShifts[i]['shift'];
                            Color color = selectedDates.contains(day)?Colors.green:Colors.black;
                            return Padding(
                              padding:  EdgeInsets.only(bottom: ScreenUtil().setHeight(15)),
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
                                        padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                                        child: CustomText(text: day,color: Colors.white,font: 'GoogleSans',size: ScreenUtil().setSp(40),),
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
                                        padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                                        child: CustomText(text: shift,font: 'GoogleSans',isBold: false,size: ScreenUtil().setSp(40),align: TextAlign.start,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(80),),

              ///experience
              TextField(
                controller: experience,
                maxLines: null,
                textAlign: TextAlign.justify,
                style: TextStyle(fontFamily: 'GoogleSans',height: 1.4,fontWeight: FontWeight.w300,color: Color(0xff52575D)),
                decoration: InputDecoration(
                  labelText: 'Experience',
                  labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: ScreenUtil().setSp(70)),
                  enabled: false,
                  contentPadding: EdgeInsets.fromLTRB(14, 30, 14, 16),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 3
                    )
                  )
                ),
              ),
              SizedBox(height: ScreenUtil().setHeight(100),),

              ///button
              Button(
                color: Color(0xff00C853),
                text: 'Hire me',
                image: 'hire.png',
                imageSize: 80,
                padding: 0,
                onclick: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  String cart = prefs.getString('cart') ?? "";
                  cart += "• ${widget.name} ${widget.surname}\n"
                      "\t\tContact email: ${widget.email}\n"
                      "\t\tMobile Phone: ${widget.phone}\n"
                      "\t\tCPR Number: ${widget.cpr}\n\n";
                  prefs.setString('cart', cart);
                  ToastBar(text: 'Added to list!',color: Colors.green).show();
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
