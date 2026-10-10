import 'package:barnasht_app/core/utils/app_images.dart';
import 'package:flutter/material.dart';

class PermissionLoadingView extends StatefulWidget {
  const PermissionLoadingView({super.key});

  @override
  State<PermissionLoadingView> createState() => _PermissionLoadingViewState();
}

class _PermissionLoadingViewState extends State<PermissionLoadingView>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _orbitController;
  late final AnimationController _dotsController;

  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _scale = Tween<double>(begin: 0.94, end: 1.04).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _glow = Tween<double>(begin: 0.08, end: 0.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _orbitController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final primaryColor = colorScheme.primary;

    return Scaffold(
      // Main screen background
      // Dark mode: #0B1014
      // Light mode: #F7F9F7
      backgroundColor: theme.scaffoldBackgroundColor,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: Listenable.merge([_pulseController, _orbitController]),
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
                          width: 184,
                          height: 184,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: primaryColor.withValues(alpha: _glow.value),
                          ),
                        ),

                        Transform.rotate(
                          angle: _orbitController.value * 2 * 3.1415926535,
                          child: SizedBox(
                            width: 164,
                            height: 164,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              value: 0.72,
                              backgroundColor: primaryColor.withValues(
                                alpha: 0.08,
                              ),
                              color: primaryColor,
                            ),
                          ),
                        ),

                        Container(
                          width: 132,
                          height: 132,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,

                            // Surface for the logo container.
                            // This remains #192127 in dark mode.
                            color: colorScheme.surface,

                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withValues(alpha: 0.14),
                                blurRadius: 30,
                                spreadRadius: 3,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            Assets.imagesAppLogoTransparent,
                            fit: BoxFit.contain,
                          ),
                        ),

                        Transform.rotate(
                          angle: _orbitController.value * 2 * 3.1415926535,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: primaryColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryColor.withValues(alpha: 0.45),
                                    blurRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 34),

            Text(
              'بنجهزلك رفيق...',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'لحظة ونكون جاهزين ليك',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 18),

            AnimatedBuilder(
              animation: _dotsController,
              builder: (context, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final delay = index * 0.22;
                    final value = (_dotsController.value + delay) % 1.0;

                    final opacity =
                        0.25 + (value < 0.5 ? value * 1.5 : (1 - value) * 1.5);

                    final scale =
                        0.75 + (value < 0.5 ? value * 0.5 : (1 - value) * 0.5);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Opacity(
                        opacity: opacity.clamp(0.25, 1.0),
                        child: Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
