import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceModel {
  final String id;
  final String categoryId;
  final String userId;

  final String placeName;
  final String placeAddress;
  final String placeDescription;
  final String? phoneNumber;

  final double latitude;
  final double longitude;

  final PlaceStatus status;

  final DateTime createdAt;
  final DateTime? updatedAt;

  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? rejectionReason;

  const PlaceModel({
    required this.id,
    required this.categoryId,
    required this.userId,
    required this.placeName,
    required this.placeAddress,
    required this.placeDescription,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.createdAt,
    required this.phoneNumber,
    this.updatedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.rejectionReason,
  });

  // ============================================================
  // FROM JSON
  // ============================================================

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] ?? '',
      categoryId: json['categoryId'] ?? '',
      userId: json['userId'] ?? '',
      placeName: json['placeName'] ?? '',
      placeAddress: json['placeAddress'] ?? '',
      placeDescription: json['placeDescription'] ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      status: _statusFromString(json['status']),
      createdAt: _dateTimeFromJson(json['createdAt']),
      updatedAt: _nullableDateTimeFromJson(json['updatedAt']),
      reviewedAt: _nullableDateTimeFromJson(json['reviewedAt']),
      reviewedBy: json['reviewedBy'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );
  }

  // ============================================================
  // TO ENTITY
  // ============================================================

  PlaceEntity toEntity() {
    return PlaceEntity(
      id: id,
      categoryId: categoryId,
      userId: userId,
      placeName: placeName,
      placeAddress: placeAddress,
      placeDescription: placeDescription,
      latitude: latitude,
      longitude: longitude,
      status: status,
      createdAt: createdAt,
      phoneNumber: phoneNumber,
      updatedAt: updatedAt,
      reviewedAt: reviewedAt,
      reviewedBy: reviewedBy,
      rejectionReason: rejectionReason,
    );
  }

  // ============================================================
  // FROM ENTITY
  // ============================================================

  factory PlaceModel.fromEntity(PlaceEntity entity) {
    return PlaceModel(
      id: entity.id,
      categoryId: entity.categoryId,
      userId: entity.userId,
      placeName: entity.placeName,
      placeAddress: entity.placeAddress,
      placeDescription: entity.placeDescription,
      phoneNumber: entity.phoneNumber,
      latitude: entity.latitude,
      longitude: entity.longitude,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      reviewedAt: entity.reviewedAt,
      reviewedBy: entity.reviewedBy,
      rejectionReason: entity.rejectionReason,
    );
  }

  // ============================================================
  // TO JSON
  // ============================================================

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'userId': userId,
      'placeName': placeName,
      'placeAddress': placeAddress,
      'placeDescription': placeDescription,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,
      'status': status.name,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'reviewedAt': reviewedAt,
      'reviewedBy': reviewedBy,
      'rejectionReason': rejectionReason,
    };
  }

  // ============================================================
  // FIRESTORE
  // ============================================================

  Map<String, dynamic> toFirestore() {
    return {
      'categoryId': categoryId,
      'userId': userId,
      'placeName': placeName,
      'placeAddress': placeAddress,
      'placeDescription': placeDescription,
      'phoneNumber': phoneNumber,
      'latitude': latitude,
      'longitude': longitude,

      // أي مكان جديد يبدأ Pending
      'status': PlaceStatus.pending.name,

      // وقت إنشاء المكان من سيرفر Firestore
      'createdAt': FieldValue.serverTimestamp(),

      // لم تتم مراجعته بعد
      'updatedAt': null,
      'reviewedAt': null,
      'reviewedBy': null,
      'rejectionReason': null,
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

  static DateTime? _nullableDateTimeFromJson(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}