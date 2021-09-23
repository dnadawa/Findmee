import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'home.dart';

class ContactUs extends StatelessWidget {

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
              child: Image.asset("assets/web/contact-us.png"),
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
                        width: double.infinity,
                      ),
                      CustomText(
                        text: 'Kontakt os',
                        size: width*0.07,
                        font: 'Ubuntu',
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: width*0.1),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: CustomText(
                            text: 'Her kan du se vores kontaktoplysninger.\n\nVi glæder os til at høre fra dig.',
                            font: 'GoogleSans',
                            size: width*0.042,
                            isBold: false,
                            align: TextAlign.start,
                          ),
                        ),
                      ),
                      ListTile(
                        horizontalTitleGap: width*0.02,
                        contentPadding: EdgeInsets.zero,
                        leading: SizedBox(width: width*0.09,child: Image.asset('assets/web/phone.png')),
                        title: CustomText(
                          text: 'Telephone: 42 33 43 43',
                          font: 'ComicSans',
                          align: TextAlign.start,
                          isBold: false,
                          size: width*0.04,
                        ),
                      ),
                      ListTile(
                        horizontalTitleGap: width*0.02,
                        contentPadding: EdgeInsets.zero,
                        leading: SizedBox(width: width*0.09,child: Image.asset('assets/web/cvr.png')),
                        title: CustomText(
                          text: 'CVR-nummer: 28119575',
                          font: 'ComicSans',
                          align: TextAlign.start,
                          isBold: false,
                          size: width*0.04,
                        ),
                      ),
                      ListTile(
                        horizontalTitleGap: width*0.02,
                        contentPadding: EdgeInsets.zero,
                        leading: SizedBox(width: width*0.09,child: Image.asset('assets/web/email.png')),
                        title: CustomText(
                          text: 'info@findme.dk',
                          font: 'ComicSans',
                          align: TextAlign.start,
                          isBold: false,
                          size: width*0.04,
                        ),
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
          ],
        ),
      ),
    );
  }
}
