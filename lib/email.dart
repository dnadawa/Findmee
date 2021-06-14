import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class Email{

  static sendEmail(String msg, String subject, {String to='shakib@live.dk'}) async {
    String username = dotenv.env['EMAIL'];
    String password = dotenv.env['PASSWORD'];

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'Findmee')
      ..recipients.add(to)
    // ..recipients.add('dulajnadawa@gmail.com')
      ..subject = subject
      ..text = msg;
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

}