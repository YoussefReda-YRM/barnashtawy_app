import 'package:equatable/equatable.dart';

enum PlaceStatus { pending, approved, rejected }

class PlaceEntity extends Equatable {
  final String id;
  final String categoryId;

  final String placeName;
  final String placeAddress;
  final String placeDescription;
  final String? phoneNumber;

  final double latitude;
  final double longitude;

  final PlaceStatus status;

  final DateTime createdAt;

  const PlaceEntity({
    required this.id,
    required this.categoryId,
    required this.placeName,
    required this.placeAddress,
    required this.placeDescription,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [
    id,
    categoryId,
    placeName,
    placeAddress,
    placeDescription,
    latitude,
    longitude,
    status,
    createdAt,
    phoneNumber,
  ];
}
