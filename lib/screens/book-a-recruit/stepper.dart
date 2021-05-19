import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';

import 'categories.dart';
import 'cities.dart';
import 'dates.dart';
import 'log-in.dart';

// ignore: must_be_immutable
class StepperPage extends StatefulWidget {
  static PageController controller = PageController();
  @override
  _StepperPageState createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  int currentPage = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    StepperPage.controller.addListener(() {
      if(mounted){
        setState(() {
          currentPage = StepperPage.controller.page.toInt();
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: AppBar().preferredSize,
          child: IconStepper(
            activeStep: currentPage,
            stepColor: Colors.white,
            activeStepColor: Color(0xffC0E218),
            activeStepBorderColor: Color(0xffC0E218),
            activeStepBorderWidth: 1,
            enableNextPreviousButtons: false,
            enableStepTapping: false,
            lineColor: Color(0xffC0E218),
            icons: [
              Icon(Icons.app_registration,size: 20,),
              Icon(Icons.app_registration,size: 20,),
              Icon(Icons.app_registration,size: 20,),
              Icon(Icons.app_registration,size: 20,),
            ],
          ),
        ),
        body: PageView(
          controller: StepperPage.controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            LogIn(),
            Categories(),
            Cities(),
            Dates(),
          ],
        ),
      ),
    );
  }
}
