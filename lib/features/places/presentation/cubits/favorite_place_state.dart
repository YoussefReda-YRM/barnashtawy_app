import 'package:flutter/foundation.dart';

@immutable
sealed class FavoriteState {}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoaded extends FavoriteState {
  final Set<String> favoritePlaceIds;

  FavoriteLoaded({
    required this.favoritePlaceIds,
  });
}