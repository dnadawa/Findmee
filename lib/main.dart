import 'package:findmee/screens/be-a-recruit/datesRecruit.dart';
import 'package:findmee/screens/book-a-recruit/dates.dart';
import 'package:findmee/screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  initApp() async {
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initApp();
  }

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
