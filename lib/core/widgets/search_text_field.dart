import 'package:barnasht_app/core/utils/app_colors.dart';
import 'package:barnasht_app/core/utils/app_images.dart';
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg.dart';

class SearchTextField extends StatefulWidget {
  const SearchTextField({
    super.key,
    required this.categoryName,
    required this.controller,
    required this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.onFilterPressed,
  });

  final String categoryName;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onFilterPressed;

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField>
    with WidgetsBindingObserver {
  bool _keyboardWasVisible = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    widget.controller.addListener(_onControllerChanged);
    widget.focusNode.addListener(_onFocusChanged);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didChangeMetrics() {
    final views = WidgetsBinding.instance.platformDispatcher.views;

    if (views.isEmpty) return;

    final bottomInset = views.first.viewInsets.bottom;
    final keyboardVisible = bottomInset > 0;

    // الكيبورد ظهر
    if (keyboardVisible) {
      _keyboardWasVisible = true;
      return;
    }

    // الكيبورد اختفى بعد أن كان ظاهرًا
    if (_keyboardWasVisible) {
      _keyboardWasVisible = false;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (widget.focusNode.hasFocus) {
          widget.focusNode.unfocus();
        }
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    widget.controller.removeListener(_onControllerChanged);
    widget.focusNode.removeListener(_onFocusChanged);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final bool hasText = widget.controller.text.isNotEmpty;
    final bool isFocused = widget.focusNode.hasFocus;

    // ============================================================
    // Search Field Color
    // ============================================================
    final fieldColor = theme.brightness == Brightness.dark
        ? AppColors.darkCard
        : AppColors.lightSurface;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.search,
        textDirection: TextDirection.rtl,
        textAlign: TextAlign.right,
        onChanged: widget.onChanged,
        onSubmitted: (value) {
          widget.focusNode.unfocus();
          widget.onSubmitted?.call(value);
        },
        style: TextStyles.semiBold13.copyWith(
          color: colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(13),
            child: SvgPicture.asset(
              Assets.imagesSearchIcon,
              colorFilter: ColorFilter.mode(
                colorScheme.primary,
                BlendMode.srcIn,
              ),
            ),
          ),
          suffixIcon: hasText
              ? IconButton(
                  tooltip: 'مسح',
                  onPressed: () {
                    widget.controller.clear();
                    widget.focusNode.requestFocus();
                    widget.onChanged?.call('');
                  },
                  icon: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: colorScheme.primary.withValues(alpha: 0.65),
                  ),
                )
              : IconButton(
                  tooltip: 'فلترة',
                  onPressed: widget.onFilterPressed,
                  icon: SvgPicture.asset(
                    Assets.imagesFilter,
                    colorFilter: ColorFilter.mode(
                      colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
          hintText: 'ابحث عن ${widget.categoryName}...',
          hintStyle: TextStyles.regular13.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.45),
          ),
          filled: true,

          // Dark mode: #141C21
          // Light mode: #FFFFFF
          fillColor: fieldColor,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: buildBorder(colorScheme),
          enabledBorder: buildBorder(colorScheme),
          focusedBorder: buildFocusedBorder(colorScheme),
        ),
      ),
    );
  }

  OutlineInputBorder buildBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        width: 1,
        color: colorScheme.primary.withValues(alpha: 0.25),
      ),
    );
  }

  OutlineInputBorder buildFocusedBorder(ColorScheme colorScheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        width: 1.3,
        color: colorScheme.primary.withValues(alpha: 0.65),
      ),
    );
  }
}