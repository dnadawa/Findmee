import 'package:findmee/web/welcomeWeb.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/custom-text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeWeb extends StatefulWidget {
  @override
  _HomeWebState createState() => _HomeWebState();
}

class _HomeWebState extends State<HomeWeb> with SingleTickerProviderStateMixin{
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
                        color: Theme.of(context).primaryColor,
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
                    color: _controller.index==1?Theme.of(context).primaryColor:Colors.black,
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
                    color: _controller.index==2?Theme.of(context).primaryColor:Colors.black,
                    size: width*0.04,
                  ),
                ),
              ),
              SizedBox(width: 30,),
            ],
          ),

          Expanded(
            child: TabBarView(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/web/desktop-back.png'),alignment: Alignment.bottomRight, fit: BoxFit.fitHeight)
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(width*0.2,width*0.2,width*0.2,0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///texts
                        Text(
                          'Welcome to',
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
                            'Hire talented professionals\nOR\nMarket your skills to find jobs',
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
                            text: 'Get started',
                            onclick: (){
                              Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (context) => WelcomeWeb()),
                              );
                            },
                            padding: width*0.04,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(color: Colors.black,),
                Container(color: Colors.blue,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
