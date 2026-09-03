import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';

CategoryEntity getDummyCategory() {
  return CategoryEntity(id: '1', name: 'المطاعم', image: "");
}

List<CategoryEntity> getDummyCategories() {
  return List.generate(10, (_) => getDummyCategory());
}
