import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';

PlaceEntity getDummyPlace() {
  return PlaceEntity(
    id: '1',
    categoryId: '1',
    userId: 'dummy-user-id',
    placeName: 'Place Name',
    placeAddress: 'Place Address',
    placeDescription: 'Place Description',
    phoneNumber: '+201234567890',
    latitude: 0.0,
    longitude: 0.0,
    status: PlaceStatus.approved,
    createdAt: DateTime.now(),
    updatedAt: null,
    reviewedAt: null,
    reviewedBy: null,
    rejectionReason: null,
  );
}

List<PlaceEntity> getDummyPlaces() {
  return List.generate(
    10,
    (_) => getDummyPlace(),
  );
}