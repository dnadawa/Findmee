import 'package:findmee/pop-ups/profile-pop-up.dart';
import 'package:findmee/pop-ups/recieved-pop-up.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profiles extends StatefulWidget {
  @override
  _ProfilesState createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(ScreenUtil().setHeight(40)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).primaryColor
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(ScreenUtil().setHeight(30)),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 45,
                                ),
                                SizedBox(width: ScreenUtil().setWidth(40),),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'Sanjula Puka',
                                        font: 'GoogleSans',
                                        align: TextAlign.start,
                                        size: ScreenUtil().setSp(50),
                                      ),
                                      SizedBox(height: ScreenUtil().setWidth(40),),
                                      Button(
                                        text: 'View my profile',
                                        color: Color(0xffFA1E0E),
                                        onclick: (){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                              return ProfilePopUp();
                                          });
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setHeight(80)),
              child: Button(
                text: 'Finish',
                onclick: (){
                  showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return ReceivedPopUp();
                      });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
