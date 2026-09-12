import 'package:barnasht_app/features/profile/presentation/views/widgets/logout_widget.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileLoadingView extends StatelessWidget {
  const ProfileLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileHeaderSkeleton(colorScheme),

                  const SizedBox(height: 16),

                  _buildStatisticsSkeleton(colorScheme),

                  const SizedBox(height: 24),

                  _buildMyPlacesHeaderSkeleton(colorScheme),

                  const SizedBox(height: 14),

                  ...List.generate(
                    3,
                    (index) => Padding(
                      padding: EdgeInsets.only(bottom: index == 2 ? 0 : 12),
                      child: _buildPlaceCardSkeleton(colorScheme),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: LogoutWidget(colorScheme: colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderSkeleton(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 14,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Bone.circle(size: 68),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(
                  width: 75,
                  height: 12,
                  borderRadius: BorderRadius.circular(5),
                ),

                const SizedBox(height: 4),

                Bone(
                  width: 150,
                  height: 18,
                  borderRadius: BorderRadius.circular(6),
                ),

                const SizedBox(height: 7),

                Bone(
                  width: 175,
                  height: 11,
                  borderRadius: BorderRadius.circular(5),
                ),

                const SizedBox(height: 5),

                Bone(
                  width: 120,
                  height: 11,
                  borderRadius: BorderRadius.circular(5),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Bone(width: 40, height: 40, borderRadius: BorderRadius.circular(13)),
        ],
      ),
    );
  }

  Widget _buildStatisticsSkeleton(ColorScheme colorScheme) {
    return Row(
      children: List.generate(3, (index) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: index == 0 ? 0 : 5,
              right: index == 2 ? 0 : 5,
            ),
            child: Container(
              height: 92,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.05),
                    blurRadius: 14,
                    spreadRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Bone.circle(size: 28),

                  const SizedBox(height: 8),

                  Bone(
                    width: 28,
                    height: 14,
                    borderRadius: BorderRadius.circular(5),
                  ),

                  const SizedBox(height: 5),

                  Bone(
                    width: 55,
                    height: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildMyPlacesHeaderSkeleton(ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone(
                width: 75,
                height: 20,
                borderRadius: BorderRadius.circular(6),
              ),

              const SizedBox(height: 6),

              Bone(
                width: 190,
                height: 11,
                borderRadius: BorderRadius.circular(5),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Bone(width: 32, height: 32, borderRadius: BorderRadius.circular(10)),
      ],
    );
  }

  Widget _buildPlaceCardSkeleton(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.05),
            blurRadius: 14,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Place Icon
              Bone(
                width: 52,
                height: 52,
                borderRadius: BorderRadius.circular(15),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Bone(
                            width: 120,
                            height: 16,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),

                        const SizedBox(width: 8),

                        Bone(
                          width: 72,
                          height: 25,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Bone(
                      width: 90,
                      height: 11,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Address
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              children: [
                Bone.circle(size: 17),

                const SizedBox(width: 7),

                Expanded(
                  child: Bone(
                    height: 11,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),

                const SizedBox(width: 8),

                Bone(
                  width: 32,
                  height: 32,
                  borderRadius: BorderRadius.circular(9),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Actions
          Row(
            children: [
              Expanded(
                child: Bone(
                  height: 38,
                  borderRadius: BorderRadius.circular(11),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Bone(
                  height: 38,
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
