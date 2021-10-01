import 'package:findmee/screens/book-a-recruit/approval.dart';
import 'package:findmee/screens/book-a-recruit/sign-up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          preferredSize: Size(MediaQuery.of(context).size.width,ScreenUtil().setHeight(220)),
          child: ImageStepper(
            activeStep: currentPage,
            stepColor: Colors.white,
            activeStepColor: Color(0xffC0E218),
            activeStepBorderColor: Color(0xffC0E218),
            activeStepBorderWidth: 1,
            enableNextPreviousButtons: false,
            enableStepTapping: false,
            lineColor: Color(0xffC0E218),
            stepRadius: 30,
            images: [
              currentPage==0?AssetImage('assets/images/step1active.png'):AssetImage('assets/images/step1.png'),
              currentPage==1?AssetImage('assets/images/step2active.png'):AssetImage('assets/images/step2.png'),
              currentPage==2?AssetImage('assets/images/step3active.png'):AssetImage('assets/images/step3.png'),
              currentPage==3?AssetImage('assets/images/step4active.png'):AssetImage('assets/images/step4.png'),
              currentPage==4?AssetImage('assets/images/step5active.png'):AssetImage('assets/images/step5.png'),
              currentPage==5?AssetImage('assets/images/step5active.png'):AssetImage('assets/images/step5.png'),
            ],
          ),
        ),
        body: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            SignUp(controller: _controller,),
            LogIn(controller: _controller,),
            Categories(from: 'company',controller: _controller,),
            Cities(from: 'company',controller: _controller,),
            Dates(controller: _controller,),
            Approval(controller: _controller,)
          ],
        ),
      ),
    );
  }
}
