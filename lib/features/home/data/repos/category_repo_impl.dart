import 'package:barnasht_app/core/constatnts.dart';
import 'package:barnasht_app/core/services/database_service.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:dartz/dartz.dart';
import 'package:barnasht_app/core/errors/failures.dart';
import 'package:barnasht_app/features/home/data/models/category_model.dart';
import 'package:barnasht_app/features/home/domain/repos/category_repo.dart';

class CategoryRepoImpl extends CategoryRepo {
  final DatabaseService databaseService;

  CategoryRepoImpl(this.databaseService);

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final data = await databaseService.getData(
        path: categoriesPath,
      ) as List<Map<String, dynamic>>;

      final List<CategoryEntity> categories = data
          .map((e) => CategoryModel.fromJson(e).toEntity())
          .toList();

      return right(categories);
    } catch (e) {
      return left(ServerFailure('Failed to get categories'));
    }
  }
}
