import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/core/widgets/build_bar.dart';
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

  Future<void> _showFilterBottomSheet() async {
    final cubit = context.read<PlaceCubit>();
    final colorScheme = Theme.of(context).colorScheme;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(bottomSheetContext).size.height * 0.82,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 25,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // =====================================================
                // DRAG HANDLE
                // =====================================================

                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: colorScheme.onSurface.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // =====================================================
                // HEADER
                // =====================================================
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: colorScheme.primary,
                          size: 24,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'فلترة الأماكن',
                              style: TextStyles.bold16.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              'اختر أقصى مسافة للبحث من موقعك',
                              style: TextStyles.regular11.copyWith(
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.60,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // =====================================================
                // DIVIDER
                // =====================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    height: 20,
                    color: colorScheme.onSurface.withValues(alpha: 0.08),
                  ),
                ),

                // =====================================================
                // FILTER OPTIONS
                // =====================================================
                Flexible(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Text(
                        'المسافة',
                        style: TextStyles.semiBold13.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...PlaceDistanceFilter.values.map((filter) {
                        final isSelected = cubit.distanceFilter == filter;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () async {
                                final success = await cubit.setDistanceFilter(
                                  filter,
                                );

                                if (!bottomSheetContext.mounted) {
                                  return;
                                }

                                if (!success) {
                                  Navigator.pop(bottomSheetContext);

                                  buildBar(
                                    bottomSheetContext,
                                    'لا يمكن تطبيق فلتر المسافة. تأكد من تفعيل الموقع والسماح للتطبيق باستخدامه.',
                                    type: SnackBarType.warning,
                                  );

                                  return;
                                }

                                Navigator.pop(bottomSheetContext);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                curve: Curves.easeOut,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 13,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? colorScheme.primary.withValues(
                                          alpha: 0.10,
                                        )
                                      : colorScheme.onSurface.withValues(
                                          alpha: 0.035,
                                        ),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: isSelected
                                        ? colorScheme.primary
                                        : colorScheme.onSurface.withValues(
                                            alpha: 0.07,
                                          ),
                                    width: isSelected ? 1.4 : 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // -------------------------------------------------
                                    // ICON
                                    // -------------------------------------------------

                                    Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? colorScheme.primary
                                            : colorScheme.onSurface.withValues(
                                                alpha: 0.07,
                                              ),
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: Icon(
                                        filter == PlaceDistanceFilter.all
                                            ? Icons.public_rounded
                                            : Icons.near_me_rounded,
                                        size: 21,
                                        color: isSelected
                                            ? colorScheme.onPrimary
                                            : colorScheme.onSurface.withValues(
                                                alpha: 0.60,
                                              ),
                                      ),
                                    ),

                                    const SizedBox(width: 13),

                                    // -------------------------------------------------
                                    // TEXT
                                    // -------------------------------------------------
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            filter.label,
                                            style:
                                                (isSelected
                                                        ? TextStyles.bold13
                                                        : TextStyles.semiBold13)
                                                    .copyWith(
                                                      color:
                                                          colorScheme.onSurface,
                                                    ),
                                          ),

                                          if (filter == PlaceDistanceFilter.all)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 2,
                                              ),
                                              child: Text(
                                                'عرض جميع الأماكن',
                                                style: TextStyles.regular11
                                                    .copyWith(
                                                      color: colorScheme
                                                          .onSurface
                                                          .withValues(
                                                            alpha: 0.55,
                                                          ),
                                                    ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),

                                    // -------------------------------------------------
                                    // SELECTED INDICATOR
                                    // -------------------------------------------------
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
                                      width: 26,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? colorScheme.primary
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? colorScheme.primary
                                              : colorScheme.onSurface
                                                    .withValues(alpha: 0.20),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 150,
                                        ),
                                        child: isSelected
                                            ? Icon(
                                                Icons.check_rounded,
                                                key: const ValueKey(true),
                                                size: 17,
                                                color: colorScheme.onPrimary,
                                              )
                                            : const SizedBox(
                                                key: ValueKey(false),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 4),

                      // =========================================================
                      // SORTING INFO
                      // =========================================================
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.10),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.10,
                                ),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Icon(
                                Icons.sort_rounded,
                                size: 20,
                                color: colorScheme.primary,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                'يتم عرض الأماكن من الأقرب إليك إلى الأبعد، '
                                'وعند تقارب المسافة يظهر المكان الأحدث أولًا.',
                                style: TextStyles.regular11.copyWith(
                                  color: colorScheme.onSurface.withValues(
                                    alpha: 0.75,
                                  ),
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                onFilterPressed: _showFilterBottomSheet,
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.near_me_rounded,
                    size: 17,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'الأقرب إلى موقعك يظهر أولًا',
                    style: TextStyles.semiBold11.copyWith(
                      color: Theme.of(context).colorScheme.onSurface
                          .withValues(alpha: 0.60),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: CustomPlaceListViewBlocBuilder(category: widget.category),
            ),
          ],
        ),
      ),
    );
  }
}
