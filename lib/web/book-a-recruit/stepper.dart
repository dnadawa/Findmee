import 'package:findmee/web/book-a-recruit/categories.dart';
import 'package:findmee/web/book-a-recruit/cities.dart';
import 'package:findmee/web/book-a-recruit/dates.dart';
import 'package:findmee/web/book-a-recruit/login.dart';
import 'package:findmee/web/book-a-recruit/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:im_stepper/stepper.dart';

import 'approval.dart';

class StepperWebCompany extends StatefulWidget {
  @override
  _StepperWebCompanyState createState() => _StepperWebCompanyState();
}

class _StepperWebCompanyState extends State<StepperWebCompany> {
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
    return Scaffold(
      backgroundColor: Color(0xffFA1E0E).withOpacity(0.05),
      body: Row(
        children: [
          ///stepper
          Container(
            color: Theme.of(context).primaryColor,
            child: ImageStepper(
              activeStep: currentPage,
              stepColor: Colors.white,
              activeStepColor: Color(0xffC0E218),
              activeStepBorderColor: Color(0xffC0E218),
              activeStepBorderWidth: 1,
              direction: Axis.vertical,
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

          ///content
          Expanded(
            child: PageView(
              controller: _controller,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: [
                page(
                  left: RegisterWebCompany(controller: _controller,),
                  image: 'assets/images/register.png'
                ),
                page(
                  left: LoginWebCompany(controller: _controller,),
                  image: 'assets/images/login.png'
                ),
                page(
                    left: CategoriesWeb(from: 'company', controller: _controller,),
                    image: 'assets/images/categories.png'
                ),
                page(
                    left: CitiesWeb(from: 'company', controller: _controller,),
                    image: 'assets/images/cities.png'
                ),
                page(
                    left: DatesWebCompany(controller: _controller,),
                    image: 'assets/images/calendar.png'
                ),
                ApprovalWeb(controller: _controller,),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget page({Widget left, String image}){
    double width = MediaQuery.of(context).size.width;

    return Row(
      children: [
        ///whitebox
        Expanded(
          flex: 4,
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.horizontal(right: Radius.circular(60))
            ),
            child: left,
          ),
        ),

        ///image
        Expanded(
          flex: 6,
          child: Container(
            height: width*0.3,
            child: Center(
                child: Image.asset(image)
            ),
          ),
        ),
      ],
    );
  }


}
