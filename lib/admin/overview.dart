import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:findmee/widgets/admin-input-field.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import '../responsive.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  List<DocumentSnapshot> entries;
  StreamSubscription<QuerySnapshot> subscription;
  final _scrollController = ScrollController();

  getData(){
    subscription = FirebaseFirestore.instance.collection('overview').orderBy('time', descending: true).snapshots().listen((dataSnapshot) {
      setState(() {
        entries = dataSnapshot.docs;
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
    body: entries!=null?Scrollbar(
      isAlwaysShown: true,
      controller: _scrollController,
      child: StaggeredGridView.countBuilder(
          controller: _scrollController,
          staggeredTileBuilder: (index)=> StaggeredTile.fit(1),
          crossAxisCount: isDesktop?4:isTablet?2:1,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          padding: EdgeInsets.all(width*0.05),
          itemCount: entries.length,
          itemBuilder: (context, i){
              TextEditingController bName = TextEditingController();
              TextEditingController bEmail = TextEditingController();
              TextEditingController bPhone = TextEditingController();
              TextEditingController cvr = TextEditingController();
              TextEditingController wName = TextEditingController();
              TextEditingController wEmail = TextEditingController();
              TextEditingController wPhone = TextEditingController();
              TextEditingController cpr = TextEditingController();
              TextEditingController time = TextEditingController();
              bName.text = entries[i]['business'];
              bEmail.text = entries[i]['businessEmail'];
              bPhone.text = entries[i]['businessPhone'];
              cvr.text = entries[i]['businessCVR'];
              wName.text = entries[i]['workerFName']+" "+entries[i]['workerLName'];
              wEmail.text = entries[i]['workerEmail'];
              wPhone.text = entries[i]['workerPhone'];
              cpr.text = entries[i]['workerCPR'];
              String formattedTime = DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse(entries[i]['time']));
              time.text = formattedTime;
              String id = entries[i].id;

              return Container(
                decoration: BoxDecoration(
                  color: Color(0xfff5f5f5),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: EdgeInsets.all(width*0.05),
                  child: Column(
                    children: [
                      AdminInputField(hint: 'Business Name',controller: bName,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Business Email',controller: bEmail,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Business Mobile Number',controller: bPhone,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'CVR Number',controller: cvr,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Recruiter Name',controller: wName,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Recruiter Email',controller: wEmail,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Recruiter Mobile Number',controller: wPhone,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'CPR Number',controller: cpr,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Created Time',controller: time,),
                      SizedBox(height: width*0.1,),
                      Button(
                        text: 'Delete',
                        borderRadius: 10,
                        color: Colors.red,
                        padding: isTablet?15:10,
                        onclick: () async {
                          SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                          pd.show(
                              message: 'Please wait',
                              hideText: true
                          );
                          try{
                            await FirebaseFirestore.instance.collection('overview').doc(id).delete();
                            pd.hide();
                            if(Responsive.isMobile(context)){
                              ToastBar(text: 'Deleted!',color: Colors.green).show();
                            }
                            else{
                              MessageDialog.show(context: context, text: 'Deleted', type: CoolAlertType.success);
                            }
                          }
                          catch(e){
                            pd.hide();
                            MessageDialog.show(context: context, text: e.toString(), type: CoolAlertType.error);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
          },
        ),
    ):Center(child: CircularProgressIndicator(),),
    );
  }
}
