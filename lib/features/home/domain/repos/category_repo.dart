import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:dartz/dartz.dart';
import 'package:barnasht_app/core/errors/failures.dart';

abstract class CategoryRepo {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
