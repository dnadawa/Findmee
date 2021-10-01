import 'package:findmee/web/be-a-recruit/approval.dart';
import 'package:findmee/web/be-a-recruit/dates.dart';
import 'package:findmee/web/be-a-recruit/login.dart';
import 'package:findmee/web/be-a-recruit/photos.dart';
import 'package:findmee/web/be-a-recruit/register.dart';
import 'package:findmee/web/book-a-recruit/categories.dart';
import 'package:findmee/web/book-a-recruit/cities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:im_stepper/stepper.dart';

class StepperWebWorker extends StatefulWidget {
  @override
  _StepperWebWorkerState createState() => _StepperWebWorkerState();
}

class _StepperWebWorkerState extends State<StepperWebWorker> {
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
                currentPage==1?AssetImage('assets/images/worker/step2active.png'):AssetImage('assets/images/worker/step2.png'),
                currentPage==2?AssetImage('assets/images/worker/step3active.png'):AssetImage('assets/images/worker/step3.png'),
                currentPage==3?AssetImage('assets/images/worker/step4active.png'):AssetImage('assets/images/worker/step4.png'),
                currentPage==4?AssetImage('assets/images/worker/step5active.png'):AssetImage('assets/images/worker/step5.png'),
                currentPage==5?AssetImage('assets/images/worker/step6active.png'):AssetImage('assets/images/worker/step6.png'),
                currentPage==6?AssetImage('assets/images/worker/step7active.png'):AssetImage('assets/images/worker/step7.png'),
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
                    left: RegisterWebWorker(controller: _controller,),
                    image: 'assets/images/register.png'
                ),
                page(
                    left: LoginWebWorker(controller: _controller,),
                    image: 'assets/images/login.png'
                ),
                page(
                    left: CategoriesWeb(from: 'worker', controller: _controller,),
                    image: 'assets/images/categories.png'
                ),
                page(
                    left: CitiesWeb(from: 'worker', controller: _controller,),
                    image: 'assets/images/cities.png'
                ),
                page(
                    left: DatesWebWorker(controller: _controller,),
                    image: 'assets/images/calendar.png'
                ),
                page(
                    left: PhotosWeb(controller: _controller,),
                    image: 'assets/images/photos.png'
                ),
                ApprovalWorkerWeb(controller: _controller,),
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
