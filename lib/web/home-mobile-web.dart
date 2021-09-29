import 'package:findmee/screens/book-a-recruit/stepper.dart';
import 'package:findmee/web/home-app.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/buttons.dart';

class HomeMobileWeb extends StatefulWidget {

  @override
  _HomeMobileWebState createState() => _HomeMobileWebState();
}

class _HomeMobileWebState extends State<HomeMobileWeb> with SingleTickerProviderStateMixin{
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Container(
                height: ScreenUtil().setHeight(400),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Image.asset('assets/images/logo.png')
            ),
            SizedBox(height: ScreenUtil().setHeight(60),),
            ListTile(
              title: CustomText(text: 'Home',color: _controller.index==0?Theme.of(context).primaryColor:Colors.black,align: TextAlign.start,),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: (){
                setState(() {
                  _controller.animateTo(0);
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: CustomText(text: 'Kontakt os',color: _controller.index==1?Theme.of(context).primaryColor:Colors.black,align: TextAlign.start,),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: (){
                setState(() {
                  _controller.animateTo(1);
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: CustomText(text: 'Om os',color: _controller.index==2?Theme.of(context).primaryColor:Colors.black,align: TextAlign.start,),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
              onTap: (){
                setState(() {
                  _controller.animateTo(2);
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
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
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          ///home
          SingleChildScrollView(
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
                        CupertinoPageRoute(builder: (context) => HomeApp()),
                      );
                    },
                    padding: ScreenUtil().setHeight(50),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(100)),
              ],
            ),
          ),

          ///contact us
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(80),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(150)),
                  child: Image.asset("assets/web/contact-us.png"),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(100),
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
                              text: 'Telefonnr: 42 33 43 43',
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

          ///about us
          SingleChildScrollView(
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
                        CupertinoPageRoute(builder: (context) => StepperPage()),
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
        ],
      ),
    );
  }
}
