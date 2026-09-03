
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:flutter/foundation.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategorySuccess extends CategoryState {
  final List<CategoryEntity> categories;

  CategorySuccess({
    required this.categories,
  });
}

final class CategoryFailure extends CategoryState {
  final String errorMessage;

  CategoryFailure({
    required this.errorMessage,
  });
}
