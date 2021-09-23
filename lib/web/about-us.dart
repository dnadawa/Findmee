import 'package:findmee/web/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/buttons.dart';
import '../widgets/custom-text.dart';

class AboutUs extends StatelessWidget {

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
            Padding(
              padding: EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(150)),
              child: Image.asset("assets/web/about-us.png"),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(30),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(60)),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),),
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(50)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: ScreenUtil().setHeight(40),
                      ),
                      CustomText(
                        text: 'Om os',
                        size: width*0.07,
                        font: 'Ubuntu',
                      ),
                      SizedBox(height: width*0.08,),
                      CustomText(
                        text: 'Velkommen til Findme aps\n\n'
                            'Vi er et ungt og dynamisk team med gåpåmod, som står til tjeneste '
                            '24/7 i 365 dage, så du kan altid træffe os, når der opstår akutte situationer. '
                            'Det eneste det kræver for dig er at ringe og booke en af vores vikarer på 42 33 43 43',
                        font: 'GoogleSans',
                        size: width*0.042,
                        isBold: false,
                        align: TextAlign.start,
                      ),
                      CustomText(
                        text: '\nVi er anderledes end de fleste vikarbureauer.\n',
                        font: 'GoogleSans',
                        size: width*0.050,
                        align: TextAlign.start,
                      ),
                      CustomText(
                        text: 'Du kan nemt planlægge og bestille alle vores personligt udvalgte vikarer og kan vælge præcis den medarbejder, '
                            'der passer til dit behov. Mens vi sørger for, at forholdene og papirarbejdet altid er i orden. Opret en profil hos os allerede i dag.',
                        font: 'GoogleSans',
                        size: width*0.042,
                        isBold: false,
                        align: TextAlign.start,
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(80),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(150),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width*0.146,),
              child: Button(
                color: Colors.red,
                text: 'Book Vikar',
                textSize: width*0.046,
                onclick: (){
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => Home()),
                  );
                },
                padding: ScreenUtil().setHeight(50),
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(100),
            ),
          ],
        ),
      ),
    );
  }
}
