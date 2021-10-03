import 'package:findmee/web/home-app.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

import 'book-a-recruit/stepper.dart';

class HomeDesktopWeb extends StatefulWidget {
  @override
  _HomeDesktopWebState createState() => _HomeDesktopWebState();
}

class _HomeDesktopWebState extends State<HomeDesktopWeb> with SingleTickerProviderStateMixin{
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width*0.3;
    return Scaffold(
      backgroundColor: Color(0xffFA1E0E).withOpacity(0.05),
      body: Column(
        children: [
          ///navbar
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            children: [
              ///logo
              Align(
                alignment: Alignment.topLeft,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        _controller.animateTo(0);
                      });
                    },
                    child: Container(
                        height: width*0.16,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
                          color: Color(0xffe01b22),
                        ),
                        child: Image.asset('assets/images/logo.png')
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),

              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _controller.animateTo(1);
                    });
                  },
                  child: CustomText(
                    text: 'Kontakt os',
                    color: _controller.index==1?Colors.red:Colors.black,
                    size: width*0.04,
                  ),
                ),
              ),
              SizedBox(width: 20,),

              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _controller.animateTo(2);
                    });
                  },
                  child: CustomText(
                    text: 'Om os',
                    color: _controller.index==2?Colors.red:Colors.black,
                    size: width*0.04,
                  ),
                ),
              ),
              SizedBox(width: 30,),
            ],
          ),

          ///body
          Expanded(
            child: TabBarView(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                ///homepage
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/web/desktop-back.png'),alignment: Alignment.bottomRight, fit: BoxFit.cover)
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(width*0.28,width*0.15,width*0.2,0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///texts
                        Text(
                          'Velkommen til',
                          style: GoogleFonts.merriweather(
                              fontSize: width*0.09,
                              fontWeight: FontWeight.w700
                          ),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(height: width*0.03,),
                        Text(
                            'FindMe',
                            style: GoogleFonts.koHo(
                                fontSize: width*0.18,
                                fontWeight: FontWeight.w700,
                                height: 1
                            ),
                            textAlign: TextAlign.start
                        ),
                        SizedBox(height: width*0.06,),
                        Text(
                            'Har du brug for en vikar?',
                            style: GoogleFonts.koHo(
                              fontWeight: FontWeight.w500,
                              fontSize: width*0.046,
                              fontStyle: FontStyle.italic,
                              color: Color(0xff8C0000)
                            ),
                            textAlign: TextAlign.start
                        ),
                        Text(
                            'ELLER',
                            style: GoogleFonts.koHo(
                                fontWeight: FontWeight.bold,
                                fontSize: width*0.046,
                                fontStyle: FontStyle.italic,
                                color: Color(0xff8C0000)
                            ),
                            textAlign: TextAlign.start
                        ),
                        Text(
                            'Ønsker du at blive en vikar?',
                            style: GoogleFonts.koHo(
                                fontWeight: FontWeight.w500,
                                fontSize: width*0.046,
                                fontStyle: FontStyle.italic,
                                color: Color(0xff8C0000)
                            ),
                            textAlign: TextAlign.start
                        ),
                        SizedBox(height: width*0.06,),

                        ///stores
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){},
                                child: Container(
                                  width: width*0.34,
                                  height: width*0.12,
                                  child: Image.asset('assets/web/google-play.png', fit: BoxFit.fitWidth,),
                                ),
                              ),
                            ),
                            SizedBox(width: width*0.04,),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: (){},
                                child: Container(
                                  width: width*0.31,
                                  height: width*0.12,
                                  child: Image.asset('assets/web/app-store.png', fit: BoxFit.fitWidth,),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width*0.3,),

                        ///button
                        SizedBox(
                          width: width*0.65,
                          child: Button(
                            color: Colors.red,
                            text: 'Tilmeld dig nu',
                            onclick: (){
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => HomeApp()),
                              );
                            },
                            padding: width*0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ///contact us
                Container(
                  child: Row(
                    children: [
                      ///image
                      Expanded(flex: 6,child: Padding(
                        padding: EdgeInsets.all(width*0.06),
                        child: Image.asset('assets/web/contact-us.png'),
                      )),
                      SizedBox(width: width*0.1,),
                      Expanded(
                        flex: 5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.horizontal(left: Radius.circular(20))
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(width*0.08),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text: 'Kontakt os',
                                  size: width*0.1,
                                  font: 'Ubuntu',
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: width*0.1),
                                  child: CustomText(
                                    text: 'Her kan du se vores kontaktoplysninger.\n\nVi glæder os til at høre fra dig.',
                                    font: 'GoogleSans',
                                    size: width*0.04,
                                    isBold: false,
                                    align: TextAlign.start,
                                  ),
                                ),
                                ListTile(
                                  leading: SizedBox(width: width*0.07,child: Image.asset('assets/web/phone.png')),
                                  title: CustomText(
                                    text: 'Telefonnr: 42 33 43 43',
                                    font: 'ComicSans',
                                    align: TextAlign.start,
                                    isBold: false,
                                  ),
                                ),
                                ListTile(
                                  leading: SizedBox(width: width*0.07,child: Image.asset('assets/web/cvr.png')),
                                  title: CustomText(
                                    text: 'CVR-nummer: 28119575',
                                    font: 'ComicSans',
                                    align: TextAlign.start,
                                    isBold: false,
                                  ),
                                ),
                                ListTile(
                                  leading: SizedBox(width: width*0.07,child: Image.asset('assets/web/email.png')),
                                  title: CustomText(
                                    text: 'info@find-me.dk',
                                    font: 'ComicSans',
                                    align: TextAlign.start,
                                    isBold: false,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                ///about us
                Container(
                  child: Row(
                    children: [
                      ///image
                      Expanded(flex: 6,child: Padding(
                        padding: EdgeInsets.all(width*0.06),
                        child: Image.asset('assets/web/about-us.png'),
                      )),
                      Expanded(
                        flex: 5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.horizontal(left: Radius.circular(20))
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(width*0.08),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: 'Om os',
                                      size: width*0.1,
                                      font: 'Ubuntu',
                                    ),
                                    SizedBox(height: width*0.1,),
                                    CustomText(
                                      text: 'Velkommen til Findme aps\n\n'
                                          'Vi er et ungt og dynamisk team med gåpåmod, som står til tjeneste '
                                          '24/7 i 365 dage, så du kan altid træffe os, når der opstår akutte situationer. '
                                          'Det eneste det kræver for dig er at ringe og booke en af vores vikarer på 42 33 43 43',
                                      font: 'GoogleSans',
                                      size: width*0.04,
                                      isBold: false,
                                      align: TextAlign.start,
                                    ),
                                    CustomText(
                                      text: '\nVi er anderledes end de fleste vikarbureauer.\n',
                                      font: 'GoogleSans',
                                      size: width*0.045,
                                      align: TextAlign.start,
                                    ),
                                    CustomText(
                                      text: 'Du kan nemt planlægge og bestille alle vores personligt udvalgte vikarer og kan vælge præcis den medarbejder, '
                                          'der passer til dit behov. Mens vi sørger for, at forholdene og papirarbejdet altid er i orden. Opret en profil hos os allerede i dag.',
                                      font: 'GoogleSans',
                                      size: width*0.04,
                                      isBold: false,
                                      align: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: width*0.1,),
                            SizedBox(
                              width: width*0.65,
                              child: Button(
                                color: Colors.red,
                                text: 'Book vikar',
                                onclick: (){
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(builder: (context) => StepperWebCompany()),
                                  );
                                },
                                padding: width*0.04,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
