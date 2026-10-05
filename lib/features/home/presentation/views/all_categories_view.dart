import 'package:barnasht_app/core/widgets/custom_app_bar.dart';
import 'package:barnasht_app/core/widgets/search_text_field.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:barnasht_app/features/home/presentation/views/widgets/custom_empty_category_search_widget.dart';
import 'package:barnasht_app/features/home/presentation/views/widgets/home_categroy_card.dart';
import 'package:barnasht_app/features/places/presentation/views/place_view.dart';
import 'package:flutter/material.dart';

class AllCategoriesView extends StatefulWidget {
  const AllCategoriesView({super.key, required this.categories});

  static const routeName = 'allCategories_view';

  final List<CategoryEntity> categories;

  @override
  State<AllCategoriesView> createState() => _AllCategoriesViewState();
}

class _AllCategoriesViewState extends State<AllCategoriesView> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  late List<CategoryEntity> _filteredCategories;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();

    _filteredCategories = List<CategoryEntity>.from(widget.categories);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String _normalizeArabic(String text) {
    return text
        .trim()
        .toLowerCase()
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ٱ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll(RegExp(r'[\u064B-\u065F\u0670]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  int _levenshtein(String first, String second) {
    if (first == second) return 0;

    if (first.isEmpty) return second.length;
    if (second.isEmpty) return first.length;

    List<int> previous = List<int>.generate(
      second.length + 1,
      (index) => index,
    );

    for (int i = 0; i < first.length; i++) {
      final current = List<int>.filled(second.length + 1, 0);

      current[0] = i + 1;

      for (int j = 0; j < second.length; j++) {
        final cost = first[i] == second[j] ? 0 : 1;

        current[j + 1] = [
          current[j] + 1,
          previous[j + 1] + 1,
          previous[j] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }

      previous = current;
    }

    return previous[second.length];
  }

  double _similarity(String first, String second) {
    if (first.isEmpty && second.isEmpty) return 1;

    final distance = _levenshtein(first, second);
    final maxLength = first.length > second.length
        ? first.length
        : second.length;

    return 1 - (distance / maxLength);
  }

  int _calculateSearchScore(String categoryName, String query) {
    final name = _normalizeArabic(categoryName);
    final search = _normalizeArabic(query);

    if (search.isEmpty) return 0;

    if (name == search) {
      return 100;
    }

    if (name.startsWith(search)) {
      return 90;
    }

    if (name.contains(search)) {
      return 80;
    }

    final words = name.split(' ');
    final queryWords = search.split(' ');

    for (final queryWord in queryWords) {
      if (queryWord.isEmpty) continue;

      for (final word in words) {
        if (word == queryWord) {
          return 75;
        }

        if (word.startsWith(queryWord)) {
          return 65;
        }

        if (word.contains(queryWord)) {
          return 55;
        }

        final similarity = _similarity(word, queryWord);

        if (similarity >= 0.75) {
          return (similarity * 50).round();
        }
      }
    }

    final similarity = _similarity(name, search);

    if (similarity >= 0.75) {
      return (similarity * 50).round();
    }

    return 0;
  }

  void _searchCategories(String query) {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      setState(() {
        _filteredCategories = List<CategoryEntity>.from(widget.categories);
      });

      return;
    }

    final results = <MapEntry<CategoryEntity, int>>[];

    for (final category in widget.categories) {
      final score = _calculateSearchScore(category.name, trimmedQuery);

      if (score > 0) {
        results.add(MapEntry(category, score));
      }
    }

    results.sort((a, b) => b.value.compareTo(a.value));

    setState(() {
      _filteredCategories = results.map((entry) => entry.key).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasSearchQuery = _searchController.text.trim().isNotEmpty;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            customAppBar(context, title: 'كل التصنيفات'),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: SearchTextField(
                categoryName: 'تصنيف',
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _searchCategories,
                onSubmitted: _searchCategories,
                onFilterPressed: () {},
              ),
            ),

            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),

                  if (_filteredCategories.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: CustomEmptyCategorySearchWidget(
                        searchQuery: hasSearchQuery
                            ? _searchController.text
                            : null,
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1,
                            ),
                        itemCount: _filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = _filteredCategories[index];

                          return HomeCategoryCard(
                            category: category,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                PlaceView.routeName,
                                arguments: category,
                              );
                            },
                          );
                        },
                      ),
                    ),

                  if (_filteredCategories.isNotEmpty)
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
