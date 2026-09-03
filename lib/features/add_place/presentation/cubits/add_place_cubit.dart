import 'package:barnasht_app/features/add_place/presentation/cubits/add_place_state.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/places/domain/repos/place_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPlaceCubit extends Cubit<AddPlaceState> {
  AddPlaceCubit({required this.placeRepo}) : super(AddPlaceInitial());

  final PlaceRepo placeRepo;

  Future<void> addPlace({
    required String categoryId,
    required String placeName,
    required String placeAddress,
    required String placeDescription,
    required double latitude,
    required double longitude,
  }) async {
    // Prevent duplicate submissions.
    if (state is AddPlaceLoading) return;

    final category = categoryId.trim();
    final name = placeName.trim();
    final address = placeAddress.trim();
    final description = placeDescription.trim();

    // ============================================================
    // VALIDATION
    // ============================================================

    if (category.isEmpty) {
      emit(const AddPlaceValidationFailure(message: 'تصنيف المكان غير محدد'));
      return;
    }

    if (name.isEmpty) {
      emit(const AddPlaceValidationFailure(message: 'من فضلك اكتب اسم المكان'));
      return;
    }

    if (address.isEmpty) {
      emit(
        const AddPlaceValidationFailure(message: 'من فضلك اكتب عنوان المكان'),
      );
      return;
    }

    if (!_isValidLocation(latitude, longitude)) {
      emit(
        const AddPlaceValidationFailure(
          message: 'من فضلك قم بتحديد موقع صحيح للمكان',
        ),
      );
      return;
    }

    // ============================================================
    // LOADING
    // ============================================================

    emit(AddPlaceLoading());

    try {
      // ============================================================
      // CREATE PLACE
      // ============================================================

      final place = PlaceEntity(
        id: '',
        categoryId: category,
        placeName: name,
        placeAddress: address,
        placeDescription: description,
        latitude: latitude,
        longitude: longitude,
        status: PlaceStatus.pending,
        createdAt: DateTime.now(),
      );

      // ============================================================
      // ADD TO REPOSITORY
      // ============================================================

      final result = await placeRepo.addPlace(place: place);

      // ============================================================
      // RESULT
      // ============================================================

      result.fold(
        (failure) {
          emit(AddPlaceFailure(message: failure.message));
        },
        (_) {
          emit(const AddPlaceSuccess());
        },
      );
    } catch (e) {
      emit(
        const AddPlaceFailure(
          message: 'حدث خطأ أثناء إرسال الطلب، حاول مرة أخرى',
        ),
      );
    }
  }

  bool _isValidLocation(double latitude, double longitude) {
    if (!latitude.isFinite || !longitude.isFinite) {
      return false;
    }

    if (latitude < -90 || latitude > 90) {
      return false;
    }

    if (longitude < -180 || longitude > 180) {
      return false;
    }

    if (latitude == 0 && longitude == 0) {
      return false;
    }

    return true;
  }

  void reset() {
    emit(AddPlaceInitial());
  }
}
