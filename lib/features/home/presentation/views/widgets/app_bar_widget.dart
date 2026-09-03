import 'package:barnasht_app/core/theme/theme_cubit.dart';
import 'package:barnasht_app/core/widgets/custom_header_icon_widget.dart';
import 'package:barnasht_app/core/widgets/custom_logo_widget.dart';
import 'package:barnasht_app/features/favorite_places/presentation/views/favorites_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        const CustomLogoWidget(),

        const Spacer(),

        CustomHeaderIconWidget(
          widget: Icon(
            Icons.favorite_border,
            size: 22,
            color: colorScheme.primary,
          ),
          onTap: () {
            Navigator.pushNamed(context, FavoritesView.routeName);
          },
        ),

        const SizedBox(width: 10),

        CustomHeaderIconWidget(
          widget: Icon(
            Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode_outlined
                : Icons.dark_mode_outlined,
            size: 22,
            color: colorScheme.primary,
          ),
          onTap: () {
            context.read<ThemeCubit>().toggleTheme();
          },
        ),
      ],
    );
  }
}
