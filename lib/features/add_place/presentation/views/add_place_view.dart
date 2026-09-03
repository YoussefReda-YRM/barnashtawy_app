import 'package:barnasht_app/core/services/get_it_service.dart';
import 'package:barnasht_app/features/add_place/presentation/cubits/add_place_cubit.dart';
import 'package:barnasht_app/features/add_place/presentation/views/widgets/add_place_view_body_bloc_consumer.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPlaceView extends StatelessWidget {
  const AddPlaceView({super.key, required this.category});

  final CategoryEntity category;

  static const String routeName = 'add_place_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => getIt<AddPlaceCubit>(),
        child: SafeArea(
          child: AddPlaceViewBodyBlocConsumer(category: category),
        ),
      ),
    );
  }
}

