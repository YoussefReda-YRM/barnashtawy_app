import 'package:barnasht_app/core/widgets/search_text_field.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:barnasht_app/features/places/presentation/cubits/place_cubit.dart';
import 'package:barnasht_app/features/places/presentation/views/widgets/app_bar_place_view_widget.dart';
import 'package:barnasht_app/features/places/presentation/views/widgets/custom_place_list_view_builder_bloc_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaceView extends StatefulWidget {
  const PlaceView({super.key, required this.category});

  static const String routeName = 'home_category_details_view';

  final CategoryEntity category;

  @override
  State<PlaceView> createState() => _PlaceViewState();
}

class _PlaceViewState extends State<PlaceView> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();

    super.dispose();
  }

  void _onSearchChanged(String value) {
    context.read<PlaceCubit>().searchPlaces(searchQuery: value);
  }

  void _onSearchSubmitted(String value) {
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: AppBarPlaceViewWidget(category: widget.category),
            ),

            const SizedBox(height: 4),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchTextField(
                categoryName: widget.category.name,
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _onSearchChanged,
                onSubmitted: _onSearchSubmitted,
                onFilterPressed: () {},
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: CustomPlaceListViewBlocBuilder(category: widget.category),
            ),
          ],
        ),
      ),
    );
  }
}
