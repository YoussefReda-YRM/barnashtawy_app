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
          emit(
            ProfileSuccess(
              user: user,
              places: places as List<PlaceEntity>,
            ),
          );
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

      emit(
        ProfileSuccess(
          user: user,
          places: currentState.places,
        ),
      );
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

  Future<bool> deleteAccount({String? password}) async {
    final currentState = state;

    // ----------------------------------------------------------
    // الحصول على آخر حالة صحيحة للبروفايل
    // ----------------------------------------------------------

    final ProfileSuccess previousState;

    if (currentState is ProfileSuccess) {
      previousState = currentState;
    } else if (currentState is ProfileDeleteFailure) {
      previousState = currentState.previousState;
    } else {
      return false;
    }

    // ----------------------------------------------------------
    // حالة الحذف مع الاحتفاظ ببيانات البروفايل الحالية
    // ----------------------------------------------------------

    emit(
      ProfileDeleting(
        previousState: previousState,
      ),
    );

    // ----------------------------------------------------------
    // 1. إعادة التحقق من هوية المستخدم
    // ----------------------------------------------------------

    final reauthenticateResult = await authRepo.reauthenticate(
      password: password,
    );

    final reauthenticateFailure = reauthenticateResult.fold(
      (failure) => failure,
      (_) => null,
    );

    if (reauthenticateFailure != null) {
      emit(
        ProfileDeleteFailure(
          message: reauthenticateFailure.message,
          previousState: previousState,
        ),
      );

      return false;
    }

    // ----------------------------------------------------------
    // 2. حذف جميع الأماكن الخاصة بالمستخدم
    // ----------------------------------------------------------

    final deletePlacesResult = await placeRepo.deleteMyPlaces();

    final placesFailure = deletePlacesResult.fold(
      (failure) => failure,
      (_) => null,
    );

    if (placesFailure != null) {
      emit(
        ProfileDeleteFailure(
          message: placesFailure.message,
          previousState: previousState,
        ),
      );

      return false;
    }

    // ----------------------------------------------------------
    // 3. حذف بيانات المستخدم من Firestore
    // ----------------------------------------------------------

    final deleteUserDataResult = await authRepo.deleteUserData();

    final userDataFailure = deleteUserDataResult.fold(
      (failure) => failure,
      (_) => null,
    );

    if (userDataFailure != null) {
      emit(
        ProfileDeleteFailure(
          message: userDataFailure.message,
          previousState: previousState,
        ),
      );

      return false;
    }

    // ----------------------------------------------------------
    // 4. حذف الحساب من Firebase Authentication
    // ----------------------------------------------------------

    final deleteAccountResult = await authRepo.deleteAccount();

    final accountFailure = deleteAccountResult.fold(
      (failure) => failure,
      (_) => null,
    );

    if (accountFailure != null) {
      emit(
        ProfileDeleteFailure(
          message: accountFailure.message,
          previousState: previousState,
        ),
      );

      return false;
    }

    // ----------------------------------------------------------
    // Account deleted successfully
    // ----------------------------------------------------------

    return true;
  }
}