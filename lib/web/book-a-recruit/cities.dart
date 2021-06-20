import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data.dart';

class CitiesWeb extends StatefulWidget {
  final String from;
  final PageController controller;

  const CitiesWeb({Key key, this.from, this.controller}) : super(key: key);

  @override
  _CitiesWebState createState() => _CitiesWebState();
}

class _CitiesWebState extends State<CitiesWeb> {

  List cities = Data().cities;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(width*0.075),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: ScreenUtil().setHeight(30),),
            CustomText(text: 'Byer',size: ScreenUtil().setSp(90),align: TextAlign.start,color: Color(0xff52575D)),
            SizedBox(height: ScreenUtil().setHeight(50),),
            CustomText(text: 'Select city/cities that you need to hire a recruiter',size: ScreenUtil().setSp(45),align: TextAlign.start,font: 'GoogleSans',),
            SizedBox(height: width*0.03,),

            ListView.builder(
              itemCount: cities.length,
              shrinkWrap: true,
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

            SizedBox(height: ScreenUtil().setHeight(120),),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(60)),
              child: Button(text: 'Næste',padding: width*0.01,onclick: () async {
                if(widget.from=='company'){
                  widget.controller.animateToPage(4,curve: Curves.ease,duration: Duration(milliseconds: 200));
                }
                else{
                  widget.controller.animateToPage(4,curve: Curves.ease,duration: Duration(milliseconds: 200));
                }
              }
              ),
            )

          ],
        ),
      ),
    );
  }
}
