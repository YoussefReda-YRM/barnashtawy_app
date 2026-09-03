import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';

PlaceEntity getDummyPlace() {
  return PlaceEntity(
    id: '1',
    placeName: 'Place Name',
    placeAddress: 'Place Address',
    placeDescription: 'Place Description',
    latitude: 0.0,
    longitude: 0.0,
    categoryId: '1',
    status: PlaceStatus.approved,
    createdAt: DateTime.now(),
  );
}

List<PlaceEntity> getDummyPlaces() {
  return List.generate(10, (_) => getDummyPlace());
}
