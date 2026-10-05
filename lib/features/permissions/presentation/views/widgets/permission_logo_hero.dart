import 'package:barnasht_app/core/utils/app_images.dart';
import 'package:barnasht_app/features/permissions/presentation/views/widgets/permission_page_type.dart';
import 'package:flutter/material.dart';

class PermissionLogoHero extends StatefulWidget {
  const PermissionLogoHero({
    super.key,
    required this.primaryColor,
    required this.type,
  });

  final Color primaryColor;
  final PermissionPageType type;

  @override
  State<PermissionLogoHero> createState() => _PermissionLogoHeroState();
}

class _PermissionLogoHeroState extends State<PermissionLogoHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 0.97,
      end: 1.03,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacity = Tween<double>(
      begin: 0.08,
      end: 0.16,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final icon = widget.type == PermissionPageType.location
        ? Icons.location_on_rounded
        : Icons.notifications_active_rounded;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: SizedBox(
            width: 190,
            height: 190,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 190,
                  height: 190,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.primaryColor.withValues(
                      alpha: _opacity.value,
                    ),
                  ),
                ),

                Container(
                  width: 164,
                  height: 164,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.surface,
                    border: Border.all(
                      color: widget.primaryColor.withValues(
                        alpha: 0.12,
                      ),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: widget.primaryColor.withValues(
                          alpha: 0.12,
                        ),
                        blurRadius: 35,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),

                Container(
                  width: 130,
                  height: 130,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colorScheme.surfaceContainerLowest,
                  ),
                  child: Image.asset(
                    Assets.imagesAppLogoTransparent,
                    fit: BoxFit.contain,
                  ),
                ),

                Positioned(
                  bottom: 10,
                  right: 12,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.primaryColor,
                      border: Border.all(
                        color: colorScheme.surface,
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.primaryColor.withValues(
                            alpha: 0.25,
                          ),
                          blurRadius: 15,
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      size: 23,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}