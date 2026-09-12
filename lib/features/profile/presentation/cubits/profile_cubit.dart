import 'package:barnasht_app/features/auth/domain/entities/auth_entity.dart';
import 'package:barnasht_app/features/auth/domain/repos/auth_repo.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:barnasht_app/features/places/domain/repos/place_repo.dart';
import 'package:barnasht_app/features/profile/presentation/cubits/profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.placeRepo, required this.authRepo})
    : super(const ProfileInitial());

  final PlaceRepo placeRepo;
  final AuthRepo authRepo;

  String? _uid;

  Future<void> getProfile({required String uid}) async {
    _uid = uid;

    emit(const ProfileLoading());

    try {
      final results = await Future.wait([
        authRepo.getUserData(uid: uid),
        placeRepo.getMyPlaces(),
      ]);

      final user = results[0] as UserEntity;
      final placesResult = results[1] as dynamic;

      placesResult.fold(
        (failure) {
          emit(ProfileFailure(message: failure.message));
        },
        (places) {
          emit(ProfileSuccess(user: user, places: places as List<PlaceEntity>));
        },
      );
    } catch (e) {
      emit(
        const ProfileFailure(
          message: 'حدث خطأ أثناء تحميل بيانات الملف الشخصي.',
        ),
      );
    }
  }

  Future<void> updateProfile({required UserEntity user}) async {
    final currentState = state;

    if (currentState is! ProfileSuccess) {
      return;
    }

    emit(const ProfileUpdating());

    try {
      await authRepo.updateUserData(user: user);

      emit(ProfileSuccess(user: user, places: currentState.places));
    } catch (e) {
      emit(
        const ProfileFailure(
          message: 'حدث خطأ أثناء تحديث بيانات الملف الشخصي.',
        ),
      );
    }
  }

  Future<void> updatePlace({required PlaceEntity place}) async {
    final result = await placeRepo.updatePlace(place: place);

    return result.fold(
      (failure) {
        throw Exception(failure.message);
      },
      (_) async {
        if (_uid != null) {
          await getProfile(uid: _uid!);
        }
      },
    );
  }

  Future<void> deletePlace({required String placeId}) async {
    final result = await placeRepo.deletePlace(placeId: placeId);

    result.fold(
      (failure) {
        emit(ProfileFailure(message: failure.message));
      },
      (_) {
        if (_uid != null) {
          getProfile(uid: _uid!);
        }
      },
    );
  }
}
