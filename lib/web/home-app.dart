import 'package:findmee/responsive.dart';
import 'package:findmee/web/be-a-recruit/stepper.dart';
import 'package:findmee/web/book-a-recruit/stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/welcome.dart';
import '../widgets/buttons.dart';
import '../widgets/custom-text.dart';

class HomeApp extends StatefulWidget {
  final bool logIn;

  const HomeApp({Key key, this.logIn=false}) : super(key: key);
  @override
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Responsive(
          desktop: Row(
            children: [
              Expanded(
                  child: welcomeWidget(
                      backgroundColor: Color(0xfff5f5f5),
                      image: 'book-a-recruit.png',
                      buttonText: 'Book vikar',
                      description: 'Book en af vores vikarer til din arbejdsopgave. Vi står klar med de skarpeste vikarer på arbejdsmarkedet med de helt rette kvalifikationer rettet mod dit behov!\n\n'
                          'Vi tager ansvar for, at finde de rette kandidater om det er små eller større opgaver - i en dag eller en længere periode.',
                      destination: StepperWebCompany(logIn: widget.logIn,)
                  )
              ),
              Expanded(
                  child: welcomeWidget(
                      backgroundColor: Colors.white,
                      image: 'be-a-recruit.png',
                      buttonText: 'Bliv vikar',
                      description: 'Er du vores nye vikar? Søger du nye udfordringer? Og er du klar på at tage en masse vagter - så er du det helt rette sted!  Vi kan hermed åbne dørene op for dig til nye og spændende muligheder på arbejdsmarkedet.\n\n'
                          'Hos os kan du afprøve mange forskellige brancher og nivenaver. Du kan få små eller stører opgaver rettet mod dine erfaringer og interesse.\n\n'
                          'Tilmeld dig her, eller kontakt os for en uforpligtende samtale',
                    destination: StepperWebWorker(logIn: widget.logIn,)
                  )
              ),

            ],
          ),
          tablet: Welcome(logIn: widget.logIn,),
          mobile: Welcome(logIn: widget.logIn,),
        ),
    );
  }

  Widget welcomeWidget({Color backgroundColor,String image, String buttonText, String description, Widget destination}){
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: backgroundColor,
      height: double.infinity,
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(width*0.03),
                child: Container(
                    width: width*0.25,
                    height: width*0.2,
                    child: Image.asset('assets/web/$image', fit: BoxFit.fitWidth,)
                ),
              ),
              SizedBox(
                width: width*0.2,
                child: Button(
                  color: Colors.red,
                  text: buttonText,
                  borderRadius: 10,
                  padding: width*0.015,
                  textSize: width*0.015,
                  onclick: (){
                    Navigator.push(
                      context,
                      CupertinoPageRoute(builder: (context) => destination),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width*0.03),
                child: CustomText(
                  font: 'GoogleSans',
                  isBold: false,
                  align: TextAlign.start,
                  size: width*0.01,
                  text: description,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}