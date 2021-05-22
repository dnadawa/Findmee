import 'package:findmee/data.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Categories extends StatefulWidget {
  final String from;
  final PageController controller;

  const Categories({Key key, this.from, this.controller}) : super(key: key);
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  List categories = Data().categories;

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
                  CustomText(text: 'Categories',size: ScreenUtil().setSp(60),align: TextAlign.start,),
                  SizedBox(height: ScreenUtil().setHeight(100),),
                  CustomText(text: 'Select category/categories that you need to hire a recruiter',size: ScreenUtil().setSp(45),align: TextAlign.start,font: 'GoogleSans',),
                  SizedBox(height: ScreenUtil().setHeight(100),),

                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context,i){
                        return CheckboxListTile(
                          title: CustomText(text: categories[i]['category'],font: 'GoogleSans',align: TextAlign.start,size: ScreenUtil().setSp(40),isBold: false,),
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

                  SizedBox(height: ScreenUtil().setHeight(40),),

                  Padding(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(60)),
                    child: Button(text: 'Next',onclick: () async {
                      if(widget.from=='company'){
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        List<String> selectedCategories = [];
                        for(int i=0;i<categories.length;i++){
                          if(categories[i]['selected']){
                            selectedCategories.add(categories[i]['category']);
                          }
                        }
                        prefs.setStringList('companyCategories', selectedCategories);
                        widget.controller.animateToPage(2,curve: Curves.ease,duration: Duration(milliseconds: 200));
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
