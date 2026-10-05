import 'package:barnasht_app/core/widgets/custom_app_bar.dart';
import 'package:barnasht_app/features/favorite_places/presentation/views/widgets/favorite_place_view_body.dart';
import 'package:flutter/material.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  static const String routeName = 'favorites_view';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        customAppBar(context, title: 'المفضلة', showBackButton: false),

        const Expanded(child: FavoritePlaceViewBody()),
    ],
    );
  }
}
