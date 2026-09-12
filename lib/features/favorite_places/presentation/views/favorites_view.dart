import 'package:barnasht_app/core/widgets/custom_app_bar.dart';
import 'package:barnasht_app/features/favorite_places/presentation/views/widgets/favorite_place_view_body.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  static const String routeName = 'favorites_view';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              customAppBar(context, title: 'المفضلة'),

              const Expanded(child: FavoritePlaceViewBody()),
            ],
          ),
        ),
      ),
    );
  }
}
