import 'package:barnasht_app/core/services/get_it_service.dart';
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/features/add_place/presentation/cubits/add_place_cubit.dart';
import 'package:barnasht_app/features/add_place/presentation/views/add_place_view.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:barnasht_app/features/favorite_places/presentation/views/favorites_view.dart';
import 'package:barnasht_app/features/home/presentation/views/home_view.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/places/presentation/cubits/place_cubit.dart';
import 'package:barnasht_app/features/places/presentation/views/details_place_view.dart';
import 'package:barnasht_app/features/places/presentation/views/place_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case HomeView.routeName:
      return MaterialPageRoute(builder: (context) => const HomeView());

    case PlaceView.routeName:
      return MaterialPageRoute(
        builder: (context) {
          final category = settings.arguments as CategoryEntity;

          return BlocProvider(
            create: (_) =>
                getIt<PlaceCubit>()..getPlaces(categoryId: category.id),
            child: PlaceView(category: category),
          );
        },
      );
    case AddPlaceView.routeName:
      return MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (_) => getIt<AddPlaceCubit>(),
          child: AddPlaceView(category: settings.arguments as CategoryEntity),
        ),
      );
    case DetailsPlaceView.routeName:
      final arguments = settings.arguments as Map<String, dynamic>;

      final place = arguments['place'] as PlaceEntity;
      final placeImage = arguments['placeImage'] as String;

      return MaterialPageRoute(
        builder: (context) =>
            DetailsPlaceView(place: place, placeImage: placeImage),
      );
    case FavoritesView.routeName:
      return MaterialPageRoute(builder: (context) => const FavoritesView());

    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(
            child: Text('الصفحة غير موجودة', style: TextStyles.bold16),
          ),
        ),
      );
  }
}
