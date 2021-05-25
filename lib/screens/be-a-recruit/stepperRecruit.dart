import 'package:findmee/screens/be-a-recruit/approvalRecruit.dart';
import 'package:findmee/screens/be-a-recruit/photosRecruit.dart';
import 'package:findmee/screens/be-a-recruit/registerRecruit.dart';
import 'package:findmee/screens/book-a-recruit/categories.dart';
import 'package:findmee/screens/book-a-recruit/cities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_stepper/stepper.dart';

import 'datesRecruit.dart';

// ignore: must_be_immutable
class RecruitStepperPage extends StatefulWidget {
  @override
  _RecruitStepperPageState createState() => _RecruitStepperPageState();
}

class _RecruitStepperPageState extends State<RecruitStepperPage> {
  PageController _controller = PageController();
  int currentPage = 0;

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
            images: [
              currentPage==0?AssetImage('assets/images/step1active.png'):AssetImage('assets/images/step1.png'),
              currentPage==1?AssetImage('assets/images/worker/step2active.png'):AssetImage('assets/images/worker/step2.png'),
              currentPage==2?AssetImage('assets/images/worker/step3active.png'):AssetImage('assets/images/worker/step3.png'),
              currentPage==3?AssetImage('assets/images/worker/step4active.png'):AssetImage('assets/images/worker/step4.png'),
              currentPage==4?AssetImage('assets/images/worker/step5active.png'):AssetImage('assets/images/worker/step5.png'),
              currentPage==5?AssetImage('assets/images/worker/step6active.png'):AssetImage('assets/images/worker/step6.png'),
            ]
          ),
        ),
        body: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            RecruitSignUp(controller: _controller,),
            Categories(from: 'worker',controller: _controller,),
            Cities(from: 'worker',controller: _controller,),
            RecruitDates(controller: _controller,),
            Photos(controller: _controller,),
            Approval(controller: _controller,),
          ],
        ),
      ),
    );
  }
}
