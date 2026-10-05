import '../../../../core/utils/app_images.dart';

class BottomNavigationBarEntity {
  final String activeImage, inActiveImage;
  final String name;

  BottomNavigationBarEntity({
    required this.activeImage,
    required this.inActiveImage,
    required this.name,
  });
}

List<BottomNavigationBarEntity> get bottomNavigationBarItems => [
  BottomNavigationBarEntity(
    activeImage: Assets.imagesHomeIcon,
    inActiveImage: Assets.imagesHomeIcon,
    name: 'الرئيسية',
  ),

  BottomNavigationBarEntity(
    activeImage: Assets.imagesFavoriteIcon,
    inActiveImage: Assets.imagesFavoriteIcon,
    name: 'المفضلة',
  ),
  BottomNavigationBarEntity(
    activeImage: Assets.imagesProfileIcon,
    inActiveImage: Assets.imagesProfileIcon,
    name: 'حسابي',
  ),
];
