import 'package:flutter/material.dart';

class CustomHeaderIconWidget extends StatelessWidget {
  const CustomHeaderIconWidget({
    super.key,
    required this.widget,
    required this.onTap,
  });

  final Widget widget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: colorScheme.primary,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget,
        ),
      ),
    );
  }
}