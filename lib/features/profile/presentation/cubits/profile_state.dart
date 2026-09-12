import 'package:barnasht_app/features/auth/domain/entities/auth_entity.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';

abstract class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileSuccess extends ProfileState {
  final UserEntity user;

  final List<PlaceEntity> places;

  const ProfileSuccess({required this.user, required this.places});
}

class ProfileFailure extends ProfileState {
  final String message;

  const ProfileFailure({required this.message});
}

class ProfileUpdating extends ProfileState {
  const ProfileUpdating();
}
