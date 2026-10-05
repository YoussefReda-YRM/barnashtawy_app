import 'package:barnasht_app/features/favorite_places/presentation/views/favorites_view.dart';
import 'package:barnasht_app/features/home/presentation/views/home_view.dart';
import 'package:barnasht_app/features/profile/presentation/views/profile_view.dart';
import 'package:flutter/material.dart';

class MainViewBody extends StatelessWidget {
  const MainViewBody({
    super.key,
    required this.currentViewIndex,
    required this.isLoggedIn,
    required this.onLoggedOut,
  });

  final int currentViewIndex;
  final bool isLoggedIn;
  final VoidCallback onLoggedOut;

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentViewIndex,
      children: [
        const HomeView(),
        const FavoritesView(),
        ProfileView(key: ValueKey(isLoggedIn), onLoggedOut: onLoggedOut),
      ],
    );
  }
}
