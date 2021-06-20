import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data.dart';

class CategoriesWeb extends StatefulWidget {
  final String from;
  final PageController controller;

  const CategoriesWeb({Key key, this.from, this.controller}) : super(key: key);

  @override
  _CategoriesWebState createState() => _CategoriesWebState();
}

class _CategoriesWebState extends State<CategoriesWeb> {

  List categories = Data().categories;

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
            CustomText(text: 'Kategorier',size: ScreenUtil().setSp(90),align: TextAlign.start,color: Color(0xff52575D)),
            SizedBox(height: ScreenUtil().setHeight(50),),
            CustomText(text: 'Vælg kategorier, du har brug for for at ansætte en vikar:',size: ScreenUtil().setSp(45),align: TextAlign.start,font: 'GoogleSans',),
            SizedBox(height: width*0.03,),

            ListView.builder(
              itemCount: categories.length,
              shrinkWrap: true,
              itemBuilder: (context,i){
                return CheckboxListTile(
                  title: CustomText(text: categories[i]['category'],font: 'GoogleSans',align: TextAlign.start,size: ScreenUtil().setSp(50),isBold: false,),
                  value: categories[i]['selected'],
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  activeColor: Theme.of(context).primaryColor,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (value){
                    setState(() {
                      categories[i]['selected'] = value;
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
                  widget.controller.animateToPage(3,curve: Curves.ease,duration: Duration(milliseconds: 200));
                }
                else{
                  widget.controller.animateToPage(3,curve: Curves.ease,duration: Duration(milliseconds: 200));
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
