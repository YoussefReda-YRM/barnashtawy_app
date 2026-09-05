import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceModel {
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

  const PlaceModel({
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

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      placeName: json['placeName'] ?? '',
      placeAddress: json['placeAddress'] ?? '',
      placeDescription: json['placeDescription'] ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      status: _statusFromString(json['status']),
      createdAt: _dateTimeFromJson(json['createdAt']),
    );
  }

  PlaceEntity toEntity() {
    return PlaceEntity(
      id: id,
      categoryId: categoryId,
      placeName: placeName,
      placeAddress: placeAddress,
      placeDescription: placeDescription,
      latitude: latitude,
      longitude: longitude,
      status: status,
      createdAt: createdAt,
      phoneNumber: phoneNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'placeName': placeName,
      'placeAddress': placeAddress,
      'placeDescription': placeDescription,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.name,
      'createdAt': createdAt,
    };
  }

  // ============================================================
  // FIRESTORE JSON
  // ============================================================

  Map<String, dynamic> toFirestore() {
    return {
      'categoryId': categoryId,
      'placeName': placeName,
      'placeAddress': placeAddress,
      'placeDescription': placeDescription,
      'phoneNumber': phoneNumber,

      'latitude': latitude,
      'longitude': longitude,

      // أي مكان من التطبيق يبدأ Pending
      'status': PlaceStatus.pending.name,

      // وقت Firestore الحقيقي
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // ============================================================
  // STATUS
  // ============================================================

  static PlaceStatus _statusFromString(dynamic value) {
    switch (value) {
      case 'approved':
        return PlaceStatus.approved;

      case 'rejected':
        return PlaceStatus.rejected;

      case 'pending':
      default:
        return PlaceStatus.pending;
    }
  }

  // ============================================================
  // DATE TIME
  // ============================================================

  static DateTime _dateTimeFromJson(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }

    return DateTime.now();
  }
}
