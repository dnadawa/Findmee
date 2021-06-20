import 'package:findmee/responsive.dart';
import 'package:flutter/material.dart';

import '../screens/welcome.dart';
import '../widgets/buttons.dart';
import '../widgets/custom-text.dart';

class WelcomeWeb extends StatefulWidget {
  @override
  _WelcomeWebState createState() => _WelcomeWebState();
}

class _WelcomeWebState extends State<WelcomeWeb> {
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
                      description: 'Her kan du nemlig booke en vikar til din arbejdsopgave, så kan du bruge din tid på at fokusere hvad du er bedst til.\n\n'
                          'Uanset om du har brug for en ekstra hånd i en dag eller for en længere periode , sender vi en vikar med de rette kvalifikationer.'
                  )
              ),
              Expanded(
                  child: welcomeWidget(
                      backgroundColor: Colors.white,
                      image: 'be-a-recruit.png',
                      buttonText: 'Bliv vikar',
                      description: 'Ønsker du at blive vikar, er du velkommen til at udfylde vores online ansøgningsskema, hvorefter vi vil kontakte dig.\n\n'
                          'Søger du nye udfordringer, og har du hænderne skruet rigtigt på?\n\n'
                          'Uanset dit mulige ønske om karrierevej, kan vi åbne dørene for dig til nye spændende muligheder på arbejdsmarkedet.\n\n'
                          'Hos os kan du afprøve mange forskellige brancher og nivenaver. Du kan få små eller større opgaver.\n\n'
                          'Tøv endelig ikke med at kontakte os for et uforpligtende tilbud.'
                  )
              ),

            ],
          ),
          tablet: Welcome(),
          mobile: Welcome(),
        ),
    );
  }

  Widget welcomeWidget({Color backgroundColor,String image, String buttonText, String description}){
    double width = MediaQuery.of(context).size.width;
    return Container(
      color: backgroundColor,
      height: double.infinity,
      child: SingleChildScrollView(
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
                padding: width*0.01,
                textSize: width*0.01,
                onclick: (){},
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
    );
  }
}