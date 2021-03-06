import 'dart:convert';

import 'package:http/http.dart' as http;

class CustomEmail{

  // static sendEmail(String msg, String subject, {String to='info@find-me.dk'}) async {
  //   String username = dotenv.env['EMAIL'];
  //   String password = dotenv.env['PASSWORD'];
  //
  //   final smtpServer = gmail(username, password);
  //   final message = Message()
  //     ..from = Address(username, 'Findmee')
  //     ..recipients.add(to)
  //   // ..recipients.add('dulajnadawa@gmail.com')
  //     ..subject = subject
  //     ..text = msg;
  //   try {
  //     final sendReport = await send(message, smtpServer);
  //     print('Message sent: ' + sendReport.toString());
  //   } on MailerException catch (e) {
  //     for (var p in e.problems) {
  //       print('Problem: ${p.code}: ${p.msg}');
  //     }
  //   }
  // }

  static sendEmail(String msg, String subjectText, {String to='info@find-me.dk'}) async {
    try{
      String api = "https://api.prkcar.com:7000/sendEmail";
      var response = await http.post(
        Uri.parse(api),
        body: {
          'to': to,
          'msg': msg,
          'subject': subjectText
        },
      );
      if(response.statusCode == 200){
        Map data = jsonDecode(response.body);
        if(data['status']=='successful'){
          print("Email Sent");
          return true;
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
      print(e);
      return false;
    }
  }

}