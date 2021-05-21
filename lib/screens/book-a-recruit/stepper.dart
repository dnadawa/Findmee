import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';

import 'categories.dart';
import 'cities.dart';
import 'dates.dart';
import 'log-in.dart';

// ignore: must_be_immutable
class StepperPage extends StatefulWidget {
  @override
  _StepperPageState createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  int currentPage = 0;
  PageController _controller = PageController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _controller.addListener(() {
      if(mounted){
        setState(() {
          currentPage = _controller.page.toInt();
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
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            LogIn(controller: _controller,),
            Categories(from: 'company',controller: _controller,),
            Cities(from: 'company',controller: _controller,),
            Dates(),
          ],
        ),
      ),
    );
  }
}
