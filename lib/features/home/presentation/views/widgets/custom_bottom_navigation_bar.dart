import 'package:barnasht_app/features/home/domain/entities/bottom_navigation_bar_entity.dart';
import 'package:barnasht_app/features/home/presentation/views/widgets/navigation_bar_item.dart';
import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  final int currentIndex;
  final ValueChanged<int> onItemTapped;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      height: 70,
      decoration: ShapeDecoration(
        color: theme.scaffoldBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        shadows: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.10),
            blurRadius: 25,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: bottomNavigationBarItems.asMap().entries.map((entry) {
          final index = entry.key;
          final entity = entry.value;

          return Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => onItemTapped(index),
              child: NaivgationBarItem(
                isSelected: currentIndex == index,
                bottomNavigationBarEntity: entity,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
