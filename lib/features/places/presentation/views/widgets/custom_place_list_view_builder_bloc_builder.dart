import 'package:barnasht_app/core/helper_functions/get_dummy_places.dart';
import 'package:barnasht_app/core/widgets/custom_empty_search_widget.dart';
import 'package:barnasht_app/core/widgets/custom_error_widget.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:barnasht_app/features/places/presentation/cubits/place_cubit.dart';
import 'package:barnasht_app/features/places/presentation/cubits/place_state.dart';
import 'package:barnasht_app/features/places/presentation/views/widgets/custom_empty_place_widget.dart';
import 'package:barnasht_app/features/places/presentation/views/widgets/custom_place_list_view_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomPlaceListViewBlocBuilder extends StatelessWidget {
  const CustomPlaceListViewBlocBuilder({
    super.key,
    required this.category,
  });

  final CategoryEntity category;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaceCubit, PlaceState>(
      builder: (context, state) {
        // ============================================================
        // LOADING
        // ============================================================

        if (state is PlaceLoading) {
          return Skeletonizer(
            enabled: true,
            child: CustomPlaceListViewBuilder(
              category: category,
              places: getDummyPlaces(),
            ),
          );
        }

        // ============================================================
        // FAILURE
        // ============================================================

        if (state is PlaceFailure) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: CustomErrorWidget(
                text: state.errorMessage,
              ),
            ),
          );
        }

        // ============================================================
        // SEARCHING
        // ============================================================

        if (state is PlaceSearching) {
          final places = state.places;

          // البحث تم، ولكن مفيش نتيجة
          if (places.isEmpty) {
            return CustomEmptySearchWidget(
              searchQuery: state.searchQuery,
            );
          }

          // البحث لقى نتائج
          return CustomPlaceListViewBuilder(
            category: category,
            places: places,
          );
        }

        // ============================================================
        // SUCCESS
        // ============================================================

        if (state is PlaceSuccess) {
          final places = state.places;

          // مفيش بيانات اتضافت أصلًا
          if (places.isEmpty) {
            return const CustomEmptyPlacesWidget();
          }

          // فيه بيانات
          return CustomPlaceListViewBuilder(
            category: category,
            places: places,
          );
        }

        // ============================================================
        // DEFAULT
        // ============================================================

        return const SizedBox.shrink();
      },
    );
  }
}