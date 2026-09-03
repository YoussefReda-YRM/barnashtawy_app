import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:barnasht_app/features/home/presentation/views/widgets/home_categroy_card.dart';
import 'package:barnasht_app/features/places/presentation/views/place_view.dart';
import 'package:flutter/material.dart';

class HomeCategoryGrideView extends StatelessWidget {
  const new({super.key, required this.categories});

  final List<CategoryEntity> categories;

  @override
  Widget build(BuildContext context) {
    return SliverGrid.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        return HomeCategoryCard(
          category: category,
          onTap: () {
            Navigator.pushNamed(
              context,
              PlaceView.routeName,
              arguments: category,
            );
          },
        );
      },
    );
  }
}
