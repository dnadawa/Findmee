import 'package:findmee/widgets/admin-input-field.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:flutter/material.dart';

import '../responsive.dart';

class BusinessProfiles extends StatefulWidget {
  @override
  _BusinessProfilesState createState() => _BusinessProfilesState();
}

class _BusinessProfilesState extends State<BusinessProfiles> {

  @override
  Widget build(BuildContext context) {
    double width;
    bool isTablet = Responsive.isTablet(context);
    bool isDesktop = Responsive.isDesktop(context);
    if(isDesktop){
      width = MediaQuery.of(context).size.width*0.25;
    }
    else if(isTablet){
      width = MediaQuery.of(context).size.width*0.4;
    }
    else{
      width = MediaQuery.of(context).size.width;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop?4:isTablet?3:1,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            mainAxisExtent: width*1.2
          ),
        padding: EdgeInsets.all(width*0.05),
        itemCount: 5,
        itemBuilder: (context, i){
            return Container(
              decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: EdgeInsets.all(width*0.05),
                child: Column(
                  children: [
                    AdminInputField(hint: 'Business Name',),
                    SizedBox(height: width*0.05,),
                    AdminInputField(hint: 'Contact Email',),
                    SizedBox(height: width*0.05,),
                    AdminInputField(hint: 'Mobile Number',),
                    SizedBox(height: width*0.05,),
                    AdminInputField(hint: 'CVR Number',),
                    SizedBox(height: width*0.1,),
                    Row(
                      children: [
                        Expanded(
                          child: Button(
                            text: 'Approve',
                            color: Colors.green,
                            borderRadius: 10,
                            padding: isTablet?15:10,
                            onclick: (){},
                          ),
                        ),
                        SizedBox(width: width*0.02,),
                        Expanded(
                          child: Button(
                            text: 'Ban',
                            borderRadius: 10,
                            color: Colors.red,
                            padding: isTablet?15:10,
                            onclick: (){},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
        },
      ),
    );
  }
}
