import 'package:barnasht_app/core/services/database_service.dart';
import 'package:barnasht_app/core/services/fire_store_service.dart';
import 'package:barnasht_app/core/services/firebase_auth_service.dart';
import 'package:barnasht_app/features/add_place/presentation/cubits/add_place_cubit.dart';
import 'package:barnasht_app/features/home/data/repos/category_repo_impl.dart';
import 'package:barnasht_app/features/home/domain/repos/category_repo.dart';
import 'package:barnasht_app/features/home/presentation/cubits/category_cubit.dart';
import 'package:barnasht_app/features/places/data/repos/place_repo_impl.dart';
import 'package:barnasht_app/features/places/domain/repos/place_repo.dart';
import 'package:barnasht_app/features/places/presentation/cubits/place_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetIt() {
  // ─────────────────────────────────────────
  // Services
  // ─────────────────────────────────────────

  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService());

  getIt.registerSingleton<DatabaseService>(FireStoreService());

  // ─────────────────────────────────────────
  // Category Repository
  // ─────────────────────────────────────────

  getIt.registerSingleton<CategoryRepo>(
    CategoryRepoImpl(getIt<DatabaseService>()),
  );

  // ─────────────────────────────────────────
  // Place Repository
  // ─────────────────────────────────────────

  getIt.registerSingleton<PlaceRepo>(PlaceRepoImpl(getIt<DatabaseService>()));

  getIt.registerFactory<CategoryCubit>(
    () => CategoryCubit(categoryRepo: getIt<CategoryRepo>()),
  );

  getIt.registerFactory<PlaceCubit>(
    () => PlaceCubit(placeRepo: getIt<PlaceRepo>()),
  );

  getIt.registerFactory<AddPlaceCubit>(
    () => AddPlaceCubit(placeRepo: getIt<PlaceRepo>()),
  );
}
