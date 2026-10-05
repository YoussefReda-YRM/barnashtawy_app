import 'package:barnasht_app/features/permissions/presentation/views/widgets/permission_info_card.dart';
import 'package:barnasht_app/features/permissions/presentation/views/widgets/permission_logo_hero.dart';
import 'package:barnasht_app/features/permissions/presentation/views/widgets/permission_page_type.dart';
import 'package:barnasht_app/features/permissions/presentation/views/widgets/permission_top_brand.dart';
import 'package:flutter/material.dart';

class PermissionPage extends StatelessWidget {
  const PermissionPage({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onPressed,
    this.secondaryText,
    this.onSecondaryPressed,
  });

  final PermissionPageType type;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onPressed;
  final String? secondaryText;
  final VoidCallback? onSecondaryPressed;

  bool get isLocation => type == PermissionPageType.location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxHeight < 700;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    height: isSmallScreen ? 20 : 36,
                  ),

                  const PermissionTopBrand(),

                  SizedBox(
                    height: isSmallScreen ? 28 : 48,
                  ),

                  PermissionLogoHero(
                    primaryColor: primaryColor,
                    type: type,
                  ),

                  SizedBox(
                    height: isSmallScreen ? 28 : 40,
                  ),

                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                      color: colorScheme.onSurface,
                    ),
                  ),

                  const SizedBox(height: 14),

                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 430,
                    ),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.75,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),

                  SizedBox(
                    height: isSmallScreen ? 28 : 42,
                  ),

                  PermissionInfoCard(type: type),

                  SizedBox(
                    height: isSmallScreen ? 24 : 34,
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: FilledButton(
                      onPressed: onPressed,
                      style: FilledButton.styleFrom(
                        elevation: 0,
                        backgroundColor: primaryColor,
                        foregroundColor: colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isLocation
                                ? Icons.location_on_rounded
                                : Icons.notifications_active_rounded,
                            size: 21,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            buttonText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (secondaryText != null) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 48,
                      child: TextButton(
                        onPressed: onSecondaryPressed,
                        style: TextButton.styleFrom(
                          foregroundColor:
                              colorScheme.onSurfaceVariant,
                        ),
                        child: Text(
                          secondaryText!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],

                  SizedBox(
                    height: isSmallScreen ? 16 : 24,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}