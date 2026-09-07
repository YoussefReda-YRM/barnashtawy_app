import 'package:barnasht_app/core/helper_functions/get_dummy_category.dart';
import 'package:barnasht_app/core/widgets/custom_error_widget.dart';
import 'package:barnasht_app/features/home/presentation/cubits/category_cubit.dart';
import 'package:barnasht_app/features/home/presentation/cubits/category_state.dart';
import 'package:barnasht_app/features/home/presentation/views/widgets/custom_empty_categories_widget.dart';
import 'package:barnasht_app/features/home/presentation/views/widgets/home_category_gride_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeCategoryGrideViewBlocBuilder extends StatelessWidget {
  const HomeCategoryGrideViewBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return Skeletonizer.sliver(
            enabled: true,
            child: HomeCategoryGrideView(categories: getDummyCategories()),
          );
        }

        if (state is CategoryFailure) {
          return SliverToBoxAdapter(
            child: CustomErrorWidget(text: state.errorMessage),
          );
        }

        if (state is CategorySuccess) {
          final categories = state.categories;

          if (categories.isEmpty) {
            return const SliverToBoxAdapter(
              child: CustomEmptyCategoriesWidget(),
            );
          }

          return HomeCategoryGrideView(categories: categories);
        }

        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
