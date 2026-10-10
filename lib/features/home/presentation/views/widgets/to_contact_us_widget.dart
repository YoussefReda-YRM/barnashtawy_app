import 'package:barnasht_app/core/constatnts.dart';
import 'package:barnasht_app/core/utils/app_colors.dart';
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
            content: Text('تعذر فتح صفحة رفيق على فيسبوك'),
          ),
        );
      }
    } catch (e) {
      debugPrint('Facebook Error: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء فتح صفحة رفيق'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const facebookColor = Color(0xFF1877F2);

    // ============================================================
    // Transparent / Soft Background
    // ============================================================
    final backgroundColor = theme.brightness == Brightness.dark
        ? AppColors.darkSurface.withValues(alpha: 0.45)
        : AppColors.lightSurface.withValues(alpha: 0.65);

    return Container(
      width: double.infinity,
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomDividerWidget(),

          const SizedBox(height: 4),

          // ============================================================
          // Rafiq Updates
          // ============================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'تابع رفيق على فيسبوك ',
                    style: TextStyles.bold11.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  TextSpan(
                    text: 'لمعرفة آخر التحديثات والأخبار',
                    style: TextStyles.regular11.copyWith(
                      color: colorScheme.onSurface.withValues(
                        alpha: 0.60,
                      ),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(height: 4),

          // ============================================================
          // Facebook Button
          // ============================================================
          InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => _openFacebook(context),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: facebookColor.withValues(alpha: 0.10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    Assets.imagesFacebookIcon,
                    width: 15,
                    height: 15,
                  ),

                  const SizedBox(width: 6),

                  Text(
                    'تابع رفيق على فيسبوك',
                    style: TextStyles.semiBold11.copyWith(
                      color: facebookColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 4),

          const CustomDividerWidget(),
        ],
      ),
    );
  }
}