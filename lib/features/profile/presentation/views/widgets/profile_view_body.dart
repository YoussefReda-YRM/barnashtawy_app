import 'package:barnasht_app/core/widgets/show_custom_app_dialog.dart';
import 'package:barnasht_app/features/add_place/presentation/views/add_place_view.dart';
import 'package:barnasht_app/features/auth/domain/entities/auth_entity.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/logout_widget.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/my_place_card_widget.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/my_places_header_widget.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/profile_build_empty_places.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/profile_header_widget.dart';
import 'package:barnasht_app/features/profile/presentation/views/widgets/profile_statistics_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileViewBody extends StatelessWidget {
  const ProfileViewBody({
    super.key,
    required this.user,
    required this.places,
    required this.categories,
  });

  final UserEntity user;
  final List<PlaceEntity> places;
  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final approvedPlaces = places
        .where((place) => place.status == PlaceStatus.approved)
        .length;

    final pendingPlaces = places
        .where((place) => place.status == PlaceStatus.pending)
        .length;

    final rejectedPlaces = places
        .where((place) => place.status == PlaceStatus.rejected)
        .length;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ProfileHeaderWidget(colorScheme: colorScheme, user: user),
                const SizedBox(height: 16),
                ProfileStatisticsWidget(
                  colorScheme: colorScheme,
                  approvedCount: approvedPlaces,
                  pendingCount: pendingPlaces,
                  rejectedCount: rejectedPlaces,
                ),
                const SizedBox(height: 24),
                MyPlacesHeaderWidget(
                  colorScheme: colorScheme,
                  placesCount: places.length,
                ),
                const SizedBox(height: 14),
                if (places.isEmpty)
                  ProfileBuildEmptyPlaces()
                else
                  ...places.asMap().entries.map((entry) {
                    final index = entry.key;
                    final place = entry.value;

                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == places.length - 1 ? 0 : 12,
                      ),
                      child: MyPlaceCard(
                        place: place,
                        status: _getStatusText(place.status),
                        statusColor: _getStatusColor(place.status),
                        onEdit: () {
                          final category = categories.firstWhere(
                            (category) => category.id == place.categoryId,
                            orElse: () => throw Exception('Category not found'),
                          );

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AddPlaceView(
                                category: category,
                                place: place,
                                onUpdate: (updatedPlace) async {
                                  await context
                                      .read<ProfileCubit>()
                                      .updatePlace(place: updatedPlace);
                                },
                              ),
                            ),
                          );
                        },
                        onDelete: () {
                          showCustomAppDialog(
                            context: context,
                            title: 'حذف المكان',
                            message:
                                'هل أنت متأكد من حذف هذا المكان نهائيًا؟\n'
                                'لن تتمكن من استعادته بعد الحذف.',
                            icon: Icons.delete_forever_rounded,
                            iconColor: colorScheme.error,
                            confirmText: 'حذف نهائيًا',
                            confirmButtonColor: colorScheme.error,
                            onConfirm: () async {
                              await context.read<ProfileCubit>().deletePlace(
                                placeId: place.id,
                              );
                            },
                          );
                        },
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: LogoutWidget(colorScheme: colorScheme),
        ),
      ],
    );
  }

  String _getStatusText(PlaceStatus status) {
    switch (status) {
      case PlaceStatus.approved:
        return 'تم قبول المكان';

      case PlaceStatus.pending:
        return 'قيد المراجعة';

      case PlaceStatus.rejected:
        return 'تم رفض المكان';
    }
  }

  Color _getStatusColor(PlaceStatus status) {
    switch (status) {
      case PlaceStatus.approved:
        return Colors.green;

      case PlaceStatus.pending:
        return Colors.orange;

      case PlaceStatus.rejected:
        return Colors.red;
    }
  }
}
