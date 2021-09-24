import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';

import 'custom-text.dart';

class MessageDialog {

  static void show({@required BuildContext context,CoolAlertType type = CoolAlertType.error, @required String text}){

    CoolAlert.show(
      context: context,
      width: MediaQuery.of(context).size.width*0.15,
      type: type,
      title: '',
      widget: CustomText(
        text: text,
        size: MediaQuery.of(context).size.width*0.012,
        color: Colors.black,
      ),
      confirmBtnColor: Theme.of(context).primaryColor,
    );
  }

}
