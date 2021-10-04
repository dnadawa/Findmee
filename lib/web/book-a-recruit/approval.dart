import 'package:findmee/web/book-a-recruit/profiles.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApprovalWeb extends StatefulWidget {
  @override
  _ApprovalWebState createState() => _ApprovalWebState();
}

class _ApprovalWebState extends State<ApprovalWeb> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffFA1E0E).withOpacity(0.05),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(width*0.03),
          child: Container(
            width: width*0.3,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30))
                  ),
                    child: Padding(
                      padding: EdgeInsets.all(width*0.01),
                      child: CustomText(text: 'Godkendelse',size: ScreenUtil().setSp(90),color: Colors.white,),
                    )
                ),
                SizedBox(height: ScreenUtil().setHeight(150),),

                Container(
                  height: ScreenUtil().setHeight(500),
                  width: ScreenUtil().setHeight(500),
                  child: Image.asset('assets/images/approved.png'),
                ),
                SizedBox(height: ScreenUtil().setHeight(100),),

                CustomText(
                  text: 'Din profil er godkendt.',
                  font: 'ComicSans',
                  size: ScreenUtil().setSp(60),
                  isBold: false,
                ),

                Padding(
                    padding: EdgeInsets.all(width*0.03),
                    child: Button(
                      text: 'Næste',
                      padding: width*0.01,
                      onclick: () async {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) => ProfilesWeb()),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
