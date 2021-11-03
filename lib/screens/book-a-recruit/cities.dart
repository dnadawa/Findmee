import 'dart:convert';

import 'package:findmee/data.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../responsive.dart';

class Cities extends StatefulWidget {
  final String from;
  final PageController controller;

  const Cities({Key key, this.from, this.controller}) : super(key: key);
  @override
  _CitiesState createState() => _CitiesState();
}

class _CitiesState extends State<Cities> {

  List cities = Data().cities;
  final _scrollController = ScrollController();

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: ScreenUtil().setHeight(30),),
                  CustomText(text: 'Byer',size: ScreenUtil().setSp(90),align: TextAlign.start,color: Color(0xff52575D)),
                  SizedBox(height: ScreenUtil().setHeight(50),),
                  CustomText(text: widget.from=='company'?"Vælg by eller område for ansættelse af vikar/vikarer":'Vælg by/byer hvor du har brug for at ansætte en vikar/vikarer',size: ScreenUtil().setSp(45),align: TextAlign.start,font: 'GoogleSans',),
                  SizedBox(height: ScreenUtil().setHeight(100),),

                  Expanded(
                    child: Scrollbar(
                      isAlwaysShown: true,
                      controller: _scrollController,
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: cities.length,
                        itemBuilder: (context,i){
                          return CheckboxListTile(
                            title: CustomText(text: cities[i]['city'],font: 'GoogleSans',align: TextAlign.start,size: ScreenUtil().setSp(50),isBold: false,),
                            value: cities[i]['selected'],
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            activeColor: Theme.of(context).primaryColor,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value){
                              setState(() {
                                cities[i]['selected'] = value;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: ScreenUtil().setHeight(40),),

                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                    child: Button(text: 'Næste',padding: isTablet?width*0.025:10,onclick: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      List<String> selectedCities = [];
                      for(int i=0;i<cities.length;i++){
                        if(cities[i]['selected']){
                          selectedCities.add(cities[i]['city']);
                        }
                      }

                      if(selectedCities.length==0){
                        ToastBar(text: 'Please select at least one city!',color: Colors.red).show();
                      }
                      else if(widget.from=='company'){
                        prefs.setStringList('companyCities', selectedCities);
                        widget.controller.animateToPage(3,curve: Curves.ease,duration: Duration(milliseconds: 200));
                      }
                      else{
                        Map x = jsonDecode(prefs.getString('data'));
                        x['cities'] = selectedCities;
                        prefs.setString('data', jsonEncode(x));
                        widget.controller.animateToPage(4,curve: Curves.ease,duration: Duration(milliseconds: 200));
                      }
                    }),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
