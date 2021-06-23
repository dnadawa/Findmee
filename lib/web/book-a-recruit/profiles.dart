import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:multi_select_flutter/chip_field/multi_select_chip_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../data.dart';

class ProfilesWeb extends StatefulWidget {
  @override
  _ProfilesWebState createState() => _ProfilesWebState();
}

class _ProfilesWebState extends State<ProfilesWeb> {

  List<MultiSelectItem> buildCategories(){
    List<MultiSelectItem> categories = [];
    Data().categories.forEach((element) {
      categories.add(
          MultiSelectItem(element['category'], element['category'])
      );
    });
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ///appbar
          Container(
            color: Theme.of(context).primaryColor,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: width*0.01),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox.shrink(),
                    CustomText(text: 'User Profiles',size: width*0.018,color: Colors.white,),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width*0.005),
                            child: Row(
                              children: [
                                CustomText(text: 'Finish',size: width*0.013,),
                                SizedBox(width: 10,),
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.horizontal(left: Radius.circular(10))
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(width*0.005),
                                      child: Icon(Icons.arrow_forward, color: Colors.white,size: width*0.01,),
                                    )
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
          ),

          ///profiles
          Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 35,
                  mainAxisExtent: width*0.8,
                  mainAxisSpacing: 25
                ),
                padding: EdgeInsets.all(20),
                itemCount: 4,
                itemBuilder: (context, i){
                  List<MultiSelectItem> categories = buildCategories();


                  return Container(
                    decoration: BoxDecoration(
                      color: Color(0xfff5f5f5),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      )
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ///top
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///image
                              Padding(
                                padding: EdgeInsets.all(width*0.01),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: width*0.03,
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
                                          padding: EdgeInsets.all(width*0.005),
                                          child: CustomText(text: 'Sanjula P.',color: Colors.white,font: 'GoogleSans',size: width*0.01,),
                                        ),
                                      ),
                                    ),

                                    ///hire me
                                    Padding(
                                      padding: EdgeInsets.all(width*0.03),
                                      child: SizedBox(
                                        width: width*0.125,
                                        child: Button(
                                          color: Colors.red,
                                          text: 'Ansæet mig',
                                          image: 'hire.png',
                                          imageSize: 80,
                                          contentPadding: 10,
                                          padding: width*0.01,
                                          onclick: (){},
                                        ),
                                      ),
                                    )
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
                                padding: EdgeInsets.all(width*0.005),
                                child: CustomText(
                                  text: 'Kategori/ Kategorier',
                                  color: Color(0xff52575D),
                                  size: width*0.012,
                                  align: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: width*0.01,),
                          AbsorbPointer(
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
                              // initialValue: widget.selectedCategories,
                              items: categories,
                            ),
                          ),
                          SizedBox(height: width*0.02,),

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
                                padding: EdgeInsets.all(width*0.005),
                                child: CustomText(
                                  text: 'By /Byer',
                                  color: Color(0xff52575D),
                                  size: width*0.012,
                                  align: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: width*0.01,),
                          AbsorbPointer(
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
                              // initialValue: widget.selectedCategories,
                              items: categories,
                            ),
                          ),
                          SizedBox(height: width*0.02,),

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
                                padding: EdgeInsets.all(width*0.005),
                                child: CustomText(
                                  text: 'Ledige arbejdsdage og tider',
                                  color: Color(0xff52575D),
                                  size: width*0.012,
                                  align: TextAlign.start,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.all(width*0.01),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 7,
                                itemBuilder: (context, i){
                                  // String day = datesAndShifts[i]['day'];
                                  // String shift = datesAndShifts[i]['shift'];
                                  // Color color = selectedDates.contains(day)?Colors.green:Colors.black;
                                  String day = "Monday";
                                  String shift = "Morning, Evening, Night";
                                  Color color = Colors.black;
                                  return Padding(
                                    padding:  EdgeInsets.only(bottom: width*0.008),
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
                                              padding: EdgeInsets.all(width*0.005),
                                              child: CustomText(text: day,color: Colors.white,font: 'GoogleSans',size: width*0.01),
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
                                              padding: EdgeInsets.all(width*0.005),
                                              child: CustomText(text: shift,font: 'GoogleSans',isBold: false,size: width*0.01,align: TextAlign.start,),
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
                  );
                },
              )
          )
        ],
      ),
    );
  }
}
