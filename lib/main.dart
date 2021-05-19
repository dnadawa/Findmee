import 'file:///C:/Users/dulaj/OneDrive/Desktop/AndroidStudioProjects/findmee/lib/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xaa8C0000),
    ));
    return ScreenUtilInit(
      designSize: Size(1080, 2340),
      builder: ()=>MaterialApp(
        theme: ThemeData(
          fontFamily: 'Ubuntu',
          primaryColor: Color(0xff8C0000),
          scaffoldBackgroundColor: Color(0xff8C0000)
        ),
        home: Welcome(),
      ),
    );
  }
}
