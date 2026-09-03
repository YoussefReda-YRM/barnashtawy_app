import 'package:barnasht_app/core/constatnts.dart';
import 'package:barnasht_app/core/utils/app_images.dart';
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/core/widgets/custom_divider_widget.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class ToContactUsWidget extends StatelessWidget {
  const ToContactUsWidget({super.key});

  Future<void> _openFacebook(BuildContext context) async {
    final Uri url = Uri.parse(facebookUrl);

    try {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذر فتح صفحة فيسبوك'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Facebook Error: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء فتح فيسبوك'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    const facebookColor = Color(0xFF1877F2);

    return Container(
      color: colorScheme.primary.withValues(alpha: 0.1),
      child: Column(
        children: [
          const CustomDividerWidget(),

          const SizedBox(height: 5),

          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'التصميم والتطبيق بالكامل صُنع بواسطة ',
                  style: TextStyles.regular11.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.60),
                  ),
                ),
                TextSpan(
                  text: 'المهندس / يوسف رضا الشليحي',
                  style: TextStyles.bold11.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 2),

          InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => _openFacebook(context),
            child: Container(
              height: 22,
              width: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: facebookColor.withValues(alpha: 0.15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.imagesFacebookIcon,
                      width: 14,
                      height: 14,
                    ),

                    const Spacer(),

                    Text(
                      'تابعنا على فيسبوك',
                      style: TextStyles.semiBold11.copyWith(
                        color: facebookColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 5),

          const CustomDividerWidget(),
        ],
      ),
    );
  }
}