import 'package:equatable/equatable.dart';

sealed class AddPlaceState extends Equatable {
  const AddPlaceState();

  @override
  List<Object?> get props => [];
}

// ============================================================
// INITIAL
// ============================================================

final class AddPlaceInitial extends AddPlaceState {
  const AddPlaceInitial();
}

// ============================================================
// LOADING
// ============================================================

final class AddPlaceLoading extends AddPlaceState {
  const AddPlaceLoading();
}

// ============================================================
// SUCCESS
// ============================================================

final class AddPlaceSuccess extends AddPlaceState {
  const AddPlaceSuccess();
}

// ============================================================
// FAILURE
// ============================================================

final class AddPlaceFailure extends AddPlaceState {
  final String message;

  const AddPlaceFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// ============================================================
// VALIDATION FAILURE
// ============================================================

final class AddPlaceValidationFailure extends AddPlaceState {
  final String message;

  const AddPlaceValidationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
