import 'package:barnasht_app/core/helper_functions/get_dummy_places.dart';
import 'package:barnasht_app/core/services/get_it_service.dart';
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:barnasht_app/features/home/domain/repos/category_repo.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/places/domain/repos/place_repo.dart';
import 'package:barnasht_app/features/places/presentation/cubits/favorite_place_cubit.dart';
import 'package:barnasht_app/features/places/presentation/cubits/favorite_place_state.dart';
import 'package:barnasht_app/features/places/presentation/views/widgets/custom_place_list_view_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FavoritePlaceViewBody extends StatefulWidget {
  const FavoritePlaceViewBody({super.key});

  @override
  State<FavoritePlaceViewBody> createState() => _FavoritePlaceViewBodyState();
}

class _FavoritePlaceViewBodyState extends State<FavoritePlaceViewBody> {
  late Future<_FavoritesData> _favoritesFuture;

  @override
  void initState() {
    super.initState();

    _favoritesFuture = _loadFavorites();
  }

  Future<_FavoritesData> _loadFavorites() async {
    final placeRepo = getIt<PlaceRepo>();
    final categoryRepo = getIt<CategoryRepo>();

    final placesResult = await placeRepo.getAllPlaces();
    final categoriesResult = await categoryRepo.getCategories();

    return placesResult.fold((failure) => throw Exception(failure.message), (
      places,
    ) {
      return categoriesResult.fold(
        (failure) => throw Exception(failure.message),
        (categories) {
          return _FavoritesData(places: places, categories: categories);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<FavoriteCubit, FavoriteState>(
      builder: (context, favoriteState) {
        // ==============================================================
        // LOADING FAVORITES
        // ==============================================================

        if (favoriteState is! FavoriteLoaded) {
          return Center(
            child: CircularProgressIndicator(color: colorScheme.primary),
          );
        }

        final favoriteIds = favoriteState.favoritePlaceIds;

        // ==============================================================
        // EMPTY FAVORITES
        // ==============================================================

        if (favoriteIds.isEmpty) {
          return _buildEmptyState(colorScheme);
        }

        // ==============================================================
        // LOAD FAVORITE PLACES
        // ==============================================================

        return FutureBuilder<_FavoritesData>(
          future: _favoritesFuture,
          builder: (context, snapshot) {
            // ==========================================================
            // LOADING DATA
            // ==========================================================

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Skeletonizer(
                enabled: true,
                child: CustomPlaceListViewBuilder(
                  category: const CategoryEntity(id: '', name: '', image: ''),
                  places: getDummyPlaces(),
                ),
              );
            }

            // ==========================================================
            // ERROR
            // ==========================================================

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'حصل خطأ أثناء تحميل المفضلة',
                    textAlign: TextAlign.center,
                    style: TextStyles.regular13.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }

            // ==========================================================
            // NO DATA
            // ==========================================================

            if (!snapshot.hasData) {
              return _buildEmptyState(colorScheme);
            }

            final data = snapshot.data!;

            // ==========================================================
            // FILTER FAVORITE PLACES
            // ==========================================================

            final favoritePlaces = data.places
                .where((place) => favoriteIds.contains(place.id))
                .toList();

            // ==========================================================
            // NO FAVORITE PLACES FOUND
            // ==========================================================

            if (favoritePlaces.isEmpty) {
              return _buildEmptyState(colorScheme);
            }

            // ==========================================================
            // FAVORITE PLACES LIST
            // ==========================================================

            return CustomPlaceListViewBuilder(
              places: favoritePlaces,
              categories: data.categories,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    final favoriteColor = colorScheme.error;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: favoriteColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 45,
                color: favoriteColor,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'مفيش أماكن مفضلة',
              style: TextStyles.bold19.copyWith(color: colorScheme.onSurface),
            ),

            const SizedBox(height: 8),

            Text(
              'الأماكن اللي هتضيفها للمفضلة\nهتظهر هنا ❤️',
              textAlign: TextAlign.center,
              style: TextStyles.regular13.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.55),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesData {
  final List<PlaceEntity> places;
  final List<CategoryEntity> categories;

  const _FavoritesData({required this.places, required this.categories});
}
