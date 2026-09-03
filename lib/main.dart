import 'package:barnasht_app/core/helper_functions/on_generate_routes.dart';
import 'package:barnasht_app/core/services/get_it_service.dart';
import 'package:barnasht_app/core/services/shared_preferences_singleton.dart';
import 'package:barnasht_app/core/theme/app_theme.dart';
import 'package:barnasht_app/core/theme/theme_cubit.dart';
import 'package:barnasht_app/features/home/presentation/views/home_view.dart';
import 'package:barnasht_app/features/places/presentation/cubits/favorite_place_cubit.dart';
import 'package:barnasht_app/firebase_options.dart';
import 'package:barnasht_app/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setupGetIt();

  // Shared Preferences
  await Prefs.init();

  runApp(const BarnashtawyApp());
}

class BarnashtawyApp extends StatelessWidget {
  const BarnashtawyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => FavoriteCubit()..loadFavorites()),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,

            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            supportedLocales: S.delegate.supportedLocales,

            locale: const Locale('ar'),

            onGenerateRoute: onGenerateRoute,

            initialRoute: HomeView.routeName,

            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
