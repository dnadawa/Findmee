import 'package:findmee/web/welcomeWeb.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/buttons.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: Drawer(

      ),
      appBar: AppBar(
        backgroundColor: Color(0xff8C0000),
        title: Text('FindMe',
            style: GoogleFonts.koHo(
                fontSize: 25,
                fontWeight: FontWeight.w700,
            ),
        ),
        centerTitle: true,
        actions: [
          Image.asset("assets/images/logo.png"),
        ],
      ),
      backgroundColor: Color(0xffFA1E0E).withOpacity(0.05),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: Image.asset("assets/images/worker.png",fit: BoxFit.fitWidth,),
              width: double.infinity,
            ),
            SizedBox(height: ScreenUtil().setHeight(100)),
            Text(
                'Har du brug for en vikar?',
                style: GoogleFonts.koHo(
                    fontWeight: FontWeight.w500,
                    fontSize: width*0.056,
                    fontStyle: FontStyle.italic,
                    color: Color(0xff8C0000)
                ),
                textAlign: TextAlign.start
            ),
            Text(
                'ELLER',
                style: GoogleFonts.koHo(
                    fontWeight: FontWeight.bold,
                    fontSize: width*0.056,
                    fontStyle: FontStyle.italic,
                    color: Color(0xff8C0000)
                ),
                textAlign: TextAlign.start
            ),
            Text(
                'Ønsker du at blive en vikar?',
                style: GoogleFonts.koHo(
                    fontWeight: FontWeight.w500,
                    fontSize: width*0.056,
                    fontStyle: FontStyle.italic,
                    color: Color(0xff8C0000)
                ),
                textAlign: TextAlign.start
            ),
            SizedBox(height: ScreenUtil().setHeight(150)),
            Row(
              children: [
                SizedBox(
                  width: ScreenUtil().setWidth(100),
                ),
                Expanded(child: Image.asset("assets/web/app-store.png",fit: BoxFit.fitWidth,)),
                SizedBox(
                  width: ScreenUtil().setWidth(100),
                ),
                Expanded(child: Image.asset("assets/web/google-play.png")),
                SizedBox(
                  width: ScreenUtil().setWidth(100),
                ),
              ],
            ),
            SizedBox(height: ScreenUtil().setHeight(450)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width*0.146,),
              child: Button(
                color: Colors.red,
                text: 'Tilmeld dig nu',
                textSize: width*0.046,
                onclick: (){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => WelcomeWeb()),
                  );
                },
                padding: ScreenUtil().setHeight(50),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(100)),
          ],
        ),
      ),
    );
  }
}
