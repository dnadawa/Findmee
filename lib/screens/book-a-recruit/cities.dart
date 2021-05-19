import 'package:findmee/screens/book-a-recruit/stepper.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Cities extends StatefulWidget {
  final String from;
  final PageController controller;

  const Cities({Key key, this.from, this.controller}) : super(key: key);
  @override
  _CitiesState createState() => _CitiesState();
}

class _CitiesState extends State<Cities> {

  List cities = [
    {'city': 'Anlæg' , 'selected': false},
    {'city': 'Nedriver' , 'selected': false},
    {'city': 'Pakke/plukke' , 'selected': false},
    {'city': 'Truckkørsel' , 'selected': false},
    {'city': 'Maskinoperatør' , 'selected': false},
    {'city': 'Montage' , 'selected': false},
    {'city': 'Oprydning' , 'selected': false},
    {'city': 'Rengøring' , 'selected': false},
    {'city': 'Vinduespudsning' , 'selected': false},
  ];

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: ScreenUtil().setHeight(30),),
                  CustomText(text: 'Cities',size: ScreenUtil().setSp(60),align: TextAlign.start,),
                  SizedBox(height: ScreenUtil().setHeight(100),),
                  CustomText(text: 'Select city/cities that you need to hire a recruiter',size: ScreenUtil().setSp(45),align: TextAlign.start,font: 'GoogleSans',),
                  SizedBox(height: ScreenUtil().setHeight(100),),

                  Expanded(
                    child: ListView.builder(
                      itemCount: cities.length,
                      itemBuilder: (context,i){
                        return CheckboxListTile(
                          title: CustomText(text: cities[i]['city'],font: 'GoogleSans',align: TextAlign.start,size: ScreenUtil().setSp(40),isBold: false,),
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

                  SizedBox(height: ScreenUtil().setHeight(40),),

                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                    child: Button(text: 'Next',onclick: () async {
                      print(cities);
                      widget.controller.animateToPage(3,curve: Curves.ease,duration: Duration(milliseconds: 200));
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
