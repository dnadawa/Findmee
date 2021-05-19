import 'package:findmee/screens/be-a-recruit/approvalRecruit.dart';
import 'package:findmee/screens/be-a-recruit/photosRecruit.dart';
import 'package:findmee/screens/be-a-recruit/registerRecruit.dart';
import 'package:findmee/screens/book-a-recruit/categories.dart';
import 'package:findmee/screens/book-a-recruit/cities.dart';
import 'package:findmee/screens/book-a-recruit/dates.dart';
import 'package:flutter/material.dart';
import 'package:im_stepper/stepper.dart';

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
              Icon(Icons.app_registration,size: 20,),
              Icon(Icons.app_registration,size: 20,),
            ],
          ),
        ),
        body: PageView(
          controller: _controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            RecruitSignUp(controller: _controller,),
            Photos(controller: _controller,),
            Approval(controller: _controller,),
            Categories(from: 'recruiter',controller: _controller,),
            Cities(from: 'recruiter',controller: _controller,),
            Dates(from: 'recruiter',),
          ],
        ),
      ),
    );
  }
}
