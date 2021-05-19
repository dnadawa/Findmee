import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ProfilePopUp extends StatefulWidget {
  @override
  _ProfilePopUpState createState() => _ProfilePopUpState();
}

class _ProfilePopUpState extends State<ProfilePopUp> {
  TextEditingController experience  = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    experience.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem";
  }
  @override
  Widget build(BuildContext context) {
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
                initialValue: [
                  'AX'
                ],
                items: [
                  MultiSelectItem('AX', 'ADS'),
                  MultiSelectItem('AA', 'ADS'),
                  MultiSelectItem('AS', 'ADS'),
                  MultiSelectItem('AS', 'ADS'),
                  MultiSelectItem('AS', 'ADS'),
                ],
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
                initialValue: [
                  'AX'
                ],
                items: [
                  MultiSelectItem('AX', 'ADS'),
                  MultiSelectItem('AA', 'ADS'),
                  MultiSelectItem('AS', 'ADS'),
                  MultiSelectItem('AS', 'ADS'),
                  MultiSelectItem('AS', 'ADS'),
                ],
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
                      child: CustomText(text: 'Available Working Days & Shifts',color: Colors.white,isBold: false,align: TextAlign.start,size: ScreenUtil().setSp(45),),
                    ),
                  ),

                  ///body
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                                      border: Border.all(width: 2,color: Colors.black)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                                    child: CustomText(text: 'Wednesday',color: Colors.white,font: 'GoogleSans',size: ScreenUtil().setSp(40),),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.horizontal(right: Radius.circular(10)),
                                      border: Border.all(width: 2,color: Colors.black)
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                                    child: CustomText(text: 'Morning, Evening, Night',font: 'GoogleSans',isBold: false,size: ScreenUtil().setSp(40),align: TextAlign.start,),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(60),),

            ///experience
            TextField(
              controller: experience,
              maxLines: null,
              style: TextStyle(fontFamily: 'GoogleSans'),
              decoration: InputDecoration(
                labelText: 'Experience',
                labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                enabled: false,
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
              onclick: (){},
              color: Color(0xff00C853),
              text: 'Hire me',
            )
          ],
        ),
      ),
    );
  }
}
