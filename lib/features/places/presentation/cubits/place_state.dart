import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class PlaceState {}

final class PlaceInitial extends PlaceState {}

final class PlaceLoading extends PlaceState {}

final class PlaceSuccess extends PlaceState {
  final List<PlaceEntity> places;

  PlaceSuccess({required this.places});
}

final class PlaceFailure extends PlaceState {
  final String errorMessage;

  PlaceFailure({required this.errorMessage});
}

final class PlaceSearching extends PlaceState {
  final List<PlaceEntity> places;
  final String searchQuery;

  PlaceSearching({required this.places, required this.searchQuery});
}

final class PlaceAdding extends PlaceState {}

final class PlaceAdded extends PlaceState {}

final class PlaceAddFailure extends PlaceState {
  final String errorMessage;

  PlaceAddFailure({required this.errorMessage});
}
