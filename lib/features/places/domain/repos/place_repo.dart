import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:barnasht_app/core/errors/failures.dart';

abstract class PlaceRepo {
  Future<Either<Failure, List<PlaceEntity>>> getPlaces({
    required String categoryId,
  });

  Future<Either<Failure, void>> addPlace({required PlaceEntity place});

  Future<Either<Failure, List<PlaceEntity>>> searchPlaces({
    required String categoryId,
    required String searchQuery,
  });

  Future<Either<Failure, List<PlaceEntity>>> getAllPlaces();
}
