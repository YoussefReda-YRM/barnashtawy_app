import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber.trim());

  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  }
}
