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

  Future<void> getProfile({required String uid}) async {
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
      emit(ProfileFailure(message: 'حدث خطأ أثناء تحميل بيانات الملف الشخصي.'));
    }
  }
}
