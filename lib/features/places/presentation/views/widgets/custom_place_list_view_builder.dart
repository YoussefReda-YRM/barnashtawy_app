import 'package:barnasht_app/features/add_place/presentation/views/widgets/open_location.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/places/presentation/cubits/favorite_place_cubit.dart';
import 'package:barnasht_app/features/places/presentation/cubits/favorite_place_state.dart';
import 'package:barnasht_app/features/places/presentation/views/details_place_view.dart';
import 'package:barnasht_app/features/places/presentation/views/widgets/place_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomPlaceListViewBuilder extends StatelessWidget {
  const CustomPlaceListViewBuilder({
    super.key,
    required this.places,
    this.category,
    this.categories = const [],
  });

  final List<PlaceEntity> places;

  /// تستخدم لما كل الـ places تابعين لنفس الـ category.
  final CategoryEntity? category;

  /// تستخدم لما الـ places تابعين لأكثر من category
  /// زي صفحة المفضلة.
  final List<CategoryEntity> categories;

  CategoryEntity? _getCategory(PlaceEntity place) {
    if (category != null) {
      return category;
    }

    for (final item in categories) {
      if (item.id == place.categoryId) {
        return item;
      }
    }

    return null;
  }

  void _openPlace(
    BuildContext context,
    PlaceEntity place,
    CategoryEntity category,
  ) {
    Navigator.pushNamed(
      context,
      DetailsPlaceView.routeName,
      arguments: {
        'place': place,
        'placeImage': category.image,
      },
    );
  }

  void _toggleFavorite(
    BuildContext context,
    PlaceEntity place,
  ) {
    context.read<FavoriteCubit>().toggleFavorite(place.id);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];

        final placeCategory = _getCategory(place);

        if (placeCategory == null) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: BlocBuilder<FavoriteCubit, FavoriteState>(
            builder: (context, state) {
              final isFavorite =
                  state is FavoriteLoaded &&
                  state.favoritePlaceIds.contains(place.id);

              return PlaceCard(
                place: place,
                isFavorite: isFavorite,
                placeImage: placeCategory.image,
                onTap: () {
                  _openPlace(
                    context,
                    place,
                    placeCategory,
                  );
                },
                onLocationPressed: () {
                  openLocation(
                    context,
                    place,
                  );
                },
                onFavoritePressed: () {
                  _toggleFavorite(
                    context,
                    place,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}