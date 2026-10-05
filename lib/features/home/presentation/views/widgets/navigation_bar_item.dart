import 'package:barnasht_app/features/home/domain/entities/bottom_navigation_bar_entity.dart';
import 'package:flutter/material.dart';

import 'active_item.dart';
import 'in_active_item.dart';

class NaivgationBarItem extends StatelessWidget {
  const NaivgationBarItem({
    super.key,
    required this.isSelected,
    required this.bottomNavigationBarEntity,
  });

  final bool isSelected;
  final BottomNavigationBarEntity bottomNavigationBarEntity;
  @override
  Widget build(BuildContext context) {
    return isSelected
        ? ActiveItem(
            image: bottomNavigationBarEntity.activeImage,
            text: bottomNavigationBarEntity.name,
          )
        : InactiveItem(
            image: bottomNavigationBarEntity.inActiveImage,
            text: bottomNavigationBarEntity.name,
          );
  }
}
