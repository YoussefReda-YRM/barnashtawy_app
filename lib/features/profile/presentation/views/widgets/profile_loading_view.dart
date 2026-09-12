import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/logout_widget.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/my_place_card_widget.dart';
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
                      child: MyPlaceCard(
                        place: PlaceEntity(
                          id: "",
                          categoryId: "",
                          userId: "",
                          placeName: "",
                          placeAddress: "",
                          placeDescription: "",
                          latitude: 90.0,
                          longitude: 90.0,
                          status: PlaceStatus.pending,
                          createdAt: DateTime.now(),
                          updatedAt: null,
                          reviewedAt: null,
                          reviewedBy: null,
                          rejectionReason: null,
                          phoneNumber: "",
                        ),

                        status: 'قيد المراجعة',

                        statusColor: Colors.orange,
                        onEdit: () {},
                        onDelete: () {},
                      ),
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
    return Row(
      children: [
        Bone.circle(size: 64),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone(
                width: 130,
                height: 18,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(height: 8),
              Bone(
                width: 170,
                height: 12,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(height: 6),
              Bone(
                width: 110,
                height: 12,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          ),
        ),
      ],
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
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(14),
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
}
