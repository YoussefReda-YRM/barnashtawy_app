import 'package:barnasht_app/core/services/get_it_service.dart';
import 'package:barnasht_app/features/home/presentation/cubits/category_cubit.dart';
import 'package:barnasht_app/features/home/presentation/views/widgets/home_view_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const String routeName = 'home_view';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CategoryCubit>()..getCategories(),
      child: const Scaffold(body: SafeArea(child: HomeViewBody())),
    );
  }
}
