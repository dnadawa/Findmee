import 'dart:convert';

import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

    return Padding(
      padding: EdgeInsets.fromLTRB(width*0.05,width*0.04,width*0.1,0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: ScreenUtil().setHeight(30),),
          CustomText(text: 'Kategorier',size: ScreenUtil().setSp(100),align: TextAlign.start,color: Color(0xff52575D)),
          SizedBox(height: ScreenUtil().setHeight(80),),
          CustomText(text: 'Vælg kategorier du har brug for at ansætte en vikar/vikarer:',size: ScreenUtil().setSp(45),align: TextAlign.start,font: 'GoogleSans',),
          SizedBox(height: width*0.03,),

          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              child: ListView.builder(
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
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20), vertical: width*0.03),
            child: Button(text: 'Næste',padding: width*0.01,color: Colors.red,onclick: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              List<String> selectedCategories = [];
              for(int i=0;i<categories.length;i++){
                if(categories[i]['selected']){
                  selectedCategories.add(categories[i]['category']);
                }
              }

              if(selectedCategories.length==0){
                MessageDialog.show(
                  context: context,
                  text: 'Please select at least one category!',
                );
              }
              else if(widget.from=='company'){
                prefs.setStringList('companyCategories', selectedCategories);
                widget.controller.animateToPage(3,curve: Curves.ease,duration: Duration(milliseconds: 200));
              }
              else{
                Map x = jsonDecode(prefs.getString('data'));
                x['categories'] = selectedCategories;
                prefs.setString('data', jsonEncode(x));
                widget.controller.animateToPage(3,curve: Curves.ease,duration: Duration(milliseconds: 200));
              }
            }
            ),
          )

        ],
      ),
    );
  }
}
