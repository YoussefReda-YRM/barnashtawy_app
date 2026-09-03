import 'package:barnasht_app/features/home/presentation/views/widgets/app_bar_widget.dart';
import 'package:barnasht_app/features/home/presentation/views/widgets/home_category_gride_view_bloc_builder.dart';
import 'package:barnasht_app/features/home/presentation/views/widgets/to_contact_us_widget.dart';
import 'package:flutter/material.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الجزء الثابت
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: AppBarWidget(),
        ),

        const ToContactUsWidget(),

        // الجزء القابل للـ Scroll
        Expanded(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: const SizedBox(height: 16)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: HomeCategoryGrideViewBlocBuilder(),
              ),
              SliverToBoxAdapter(child: const SizedBox(height: 16)),
            ],
          ),
        ),
      ],
    );
  }
}
