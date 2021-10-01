import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:findmee/widgets/admin-input-field.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:flutter/material.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';

import '../email.dart';
import '../responsive.dart';

class BusinessProfiles extends StatefulWidget {
  @override
  _BusinessProfilesState createState() => _BusinessProfilesState();
}

class _BusinessProfilesState extends State<BusinessProfiles> {
  List<DocumentSnapshot> profiles;
  StreamSubscription<QuerySnapshot> subscription;

  getData(){
    subscription = FirebaseFirestore.instance.collection('companies').where('status', isEqualTo: 'pending').snapshots().listen((dataSnapshot) {
      setState(() {
        profiles = dataSnapshot.docs;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription?.cancel();
  }

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
    body: profiles!=null?GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop?4:isTablet?3:1,
            mainAxisSpacing: 15,
            crossAxisSpacing: 15,
            mainAxisExtent: width*1.2
          ),
        padding: EdgeInsets.all(width*0.05),
        itemCount: profiles.length,
        itemBuilder: (context, i){
            TextEditingController name = TextEditingController();
            TextEditingController email = TextEditingController();
            TextEditingController phone = TextEditingController();
            TextEditingController cvr = TextEditingController();
            name.text = profiles[i]['name'];
            email.text = profiles[i]['email'];
            phone.text = profiles[i]['phone'];
            cvr.text = profiles[i]['cvr'];

            return Container(
              decoration: BoxDecoration(
                color: Color(0xfff5f5f5),
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: EdgeInsets.all(width*0.05),
                child: Column(
                  children: [
                    AdminInputField(hint: 'Business Name',controller: name,),
                    SizedBox(height: width*0.05,),
                    AdminInputField(hint: 'Contact Email',controller: email,),
                    SizedBox(height: width*0.05,),
                    AdminInputField(hint: 'Mobile Number',controller: phone,),
                    SizedBox(height: width*0.05,),
                    AdminInputField(hint: 'CVR Number',controller: cvr,),
                    SizedBox(height: width*0.1,),
                    Row(
                      children: [
                        Expanded(
                          child: Button(
                            text: 'Approve',
                            color: Colors.green,
                            borderRadius: 10,
                            padding: isTablet?15:10,
                            onclick: () async {
                              SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                              pd.show(
                                  message: 'Please wait',
                                  hideText: true
                              );
                              await FirebaseFirestore.instance.collection('companies').doc(profiles[i].id).update({
                                'status': 'approved'
                              });
                              await CustomEmail.sendEmail("Your account is approved!", "Approved", to: profiles[i].id);
                              pd.hide();
                              MessageDialog.show(context: context, text: 'Approved', type: CoolAlertType.success);
                            },
                          ),
                        ),
                        SizedBox(width: width*0.02,),
                        Expanded(
                          child: Button(
                            text: 'Ban',
                            borderRadius: 10,
                            color: Colors.red,
                            padding: isTablet?15:10,
                            onclick: () async {
                              SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                              pd.show(
                                  message: 'Please wait',
                                  hideText: true
                              );
                              await FirebaseFirestore.instance.collection('companies').doc(profiles[i].id).update({
                                'status': 'ban'
                              });
                              await CustomEmail.sendEmail("Your account is banned!", "Banned", to: profiles[i].id);
                              pd.hide();
                              MessageDialog.show(context: context, text: 'Banned', type: CoolAlertType.success);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
        },
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
