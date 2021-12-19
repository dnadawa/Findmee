import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:findmee/widgets/admin-input-field.dart';
import 'package:findmee/widgets/buttons.dart';
import 'package:findmee/widgets/message-dialog.dart';
import 'package:findmee/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:http/http.dart' as http;
import '../email.dart';
import '../responsive.dart';

class BusinessProfiles extends StatefulWidget {
  @override
  _BusinessProfilesState createState() => _BusinessProfilesState();
}

class _BusinessProfilesState extends State<BusinessProfiles> {
  List<DocumentSnapshot> profiles;
  StreamSubscription<QuerySnapshot> subscription;
  final _scrollController = ScrollController();

  getData(){
    subscription = FirebaseFirestore.instance.collection('companies').snapshots().listen((dataSnapshot) {
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
    body: profiles!=null?Scrollbar(
      isAlwaysShown: true,
      controller: _scrollController,
      child: StaggeredGridView.countBuilder(
          controller: _scrollController,
          staggeredTileBuilder: (index)=> StaggeredTile.fit(1),
          crossAxisCount: isDesktop?4:isTablet?2:1,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
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
                      AdminInputField(hint: 'Firmanavn',controller: name,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Kontakt e-mail',controller: email,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'Mobilnummer',controller: phone,),
                      SizedBox(height: width*0.05,),
                      AdminInputField(hint: 'CVR-nummer',controller: cvr,),
                      SizedBox(height: width*0.1,),
                      Button(
                        text: 'Slet',
                        borderRadius: 10,
                        color: Colors.red,
                        padding: isTablet?15:10,
                        onclick: () async {
                          SimpleFontelicoProgressDialog pd = SimpleFontelicoProgressDialog(context: context, barrierDimisable:  false);
                          pd.show(
                              message: 'Vent venligst',
                              hideText: true
                          );
                          try{
                            String email = profiles[i].id;
                            String api = "https://api.prkcar.com:7000/deleteUser/$email";
                            var response = await http.get(Uri.parse(api));
                            if(response.statusCode == 200){
                              Map data = jsonDecode(response.body);
                              if(data['status']=='done'){
                                ///delete from firestore
                                await FirebaseFirestore.instance.collection('companies').doc(email).delete();
                                await CustomEmail.sendEmail("Din konto er slettet!", "Konto slettet", to: email);
                                pd.hide();
                                if(Responsive.isMobile(context)){
                                  ToastBar(text: 'Slettet!',color: Colors.green).show();
                                }
                                else{
                                  MessageDialog.show(context: context, text: 'Slettet', type: CoolAlertType.success);
                                }
                              }
                              else{
                                throw Exception('API-anmodning mislykkedes!');
                              }
                            }
                            else{
                              throw Exception('API-anmodning mislykkedes!');
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
