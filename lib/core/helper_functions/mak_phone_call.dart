import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(BuildContext context, String phone) async {
  final phoneNumber = phone.trim();

  if (phoneNumber.isEmpty) {
    return;
  }

  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

  try {
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      if (!context.mounted) return;

      buildBar(
        context,
        "لا يمكن فتح تطبيق المكالمات",
        type: SnackBarType.warning,
      );
    }
  } catch (e) {
    if (!context.mounted) return;

    buildBar(context, 'حدث خطأ أثناء محاولة الاتصال', type: SnackBarType.error);
  }
}
