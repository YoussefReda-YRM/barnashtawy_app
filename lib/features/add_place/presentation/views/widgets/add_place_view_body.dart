import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:barnasht_app/core/widgets/custom_app_bar.dart';
import 'package:barnasht_app/features/add_place/presentation/cubits/add_place_cubit.dart';
import 'package:barnasht_app/features/add_place/presentation/cubits/add_place_state.dart';
import 'package:barnasht_app/features/add_place/presentation/views/widgets/custom_location_card_widget.dart';
import 'package:barnasht_app/features/add_place/presentation/views/widgets/custom_text_form_field_and_label.dart';
import 'package:barnasht_app/core/widgets/custom_button_widget.dart';
import 'package:barnasht_app/features/home/domain/entities/category_entities.dart';
import 'package:barnasht_app/features/places/domain/entities/place_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddPlaceViewBody extends StatefulWidget {
  const AddPlaceViewBody({
    super.key,
    required this.category,
    this.place,
    required this.isEditing,
    this.onUpdate,
  });

  final CategoryEntity category;
  final PlaceEntity? place;
  final bool isEditing;

  final Future<void> Function(PlaceEntity place)? onUpdate;

  @override
  State<AddPlaceViewBody> createState() => _AddPlaceViewBodyState();
}

class _AddPlaceViewBodyState extends State<AddPlaceViewBody> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  double? _selectedLatitude;
  double? _selectedLongitude;

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();

    if (widget.isEditing && widget.place != null) {
      _initializePlaceData();
    }
  }

  void _initializePlaceData() {
    final place = widget.place!;

    _nameController.text = place.placeName;
    _phoneController.text = place.phoneNumber ?? '';
    _descriptionController.text = place.placeDescription;
    _addressController.text = place.placeAddress;

    _selectedLatitude = place.latitude;
    _selectedLongitude = place.longitude;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();

    super.dispose();
  }

  // ============================================================
  // SUBMIT PLACE
  // ============================================================

  Future<void> _submitPlace() async {
    // ============================================================
    // FORM VALIDATION
    // ============================================================

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    // ============================================================
    // LOCATION VALIDATION
    // ============================================================

    if (_selectedLatitude == null || _selectedLongitude == null) {
      buildBar(
        context,
        'من فضلك قم بتحديد موقع المكان على الخريطة',
        type: SnackBarType.warning,
      );
      return;
    }

    // ============================================================
    // EDIT
    // ============================================================

    if (widget.isEditing && widget.place != null) {
      final place = widget.place!;

      final updatedPlace = PlaceEntity(
        id: place.id,
        categoryId: widget.category.id,
        userId: place.userId,
        placeName: _nameController.text.trim(),
        placeAddress: _addressController.text.trim(),
        placeDescription: _descriptionController.text.trim(),
        phoneNumber: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        latitude: _selectedLatitude!,
        longitude: _selectedLongitude!,
        status: place.status,
        createdAt: place.createdAt,
        updatedAt: place.updatedAt,
        reviewedAt: place.reviewedAt,
        reviewedBy: place.reviewedBy,
        rejectionReason: place.rejectionReason,
      );

      if (widget.onUpdate == null) {
        return;
      }

      setState(() {
        _isUpdating = true;
      });

      try {
        await widget.onUpdate!(updatedPlace);

        if (!mounted) {
          return;
        }

        FocusScope.of(context).unfocus();

        buildBar(
          context,
          'تم إرسال تعديلات المكان بنجاح، وسيتم مراجعته قريبًا',
          type: SnackBarType.success,
        );

        Navigator.of(context).pop();
      } catch (_) {
        if (!mounted) {
          return;
        }

        buildBar(
          context,
          'حدث خطأ أثناء تعديل المكان',
          type: SnackBarType.error,
        );
      } finally {
        if (mounted) {
          setState(() {
            _isUpdating = false;
          });
        }
      }

      return;
    }

    // ============================================================
    // ADD
    // ============================================================

    context.read<AddPlaceCubit>().addPlace(
      categoryId: widget.category.id,
      placeName: _nameController.text.trim(),
      placeAddress: _addressController.text.trim(),
      placeDescription: _descriptionController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      latitude: _selectedLatitude!,
      longitude: _selectedLongitude!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final addPlaceState = context.watch<AddPlaceCubit>().state;

    final isLoading = addPlaceState is AddPlaceLoading || _isUpdating;

    return Column(
      children: [
        // ========================================================
        // APP BAR
        // ========================================================

        customAppBar(
          context,
          title: widget.isEditing ? 'تعديل المكان' : 'إضافة مكان جديد',
          showBackButton: true,
        ),

        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ==================================================
                  // LOCATION
                  // ==================================================

                  CustomLocationCardWidget(
                    initialLocation: widget.isEditing && widget.place != null
                        ? LatLng(
                            widget.place!.latitude,
                            widget.place!.longitude,
                          )
                        : null,
                    onLocationChanged: (location) {
                      if (location == null) {
                        setState(() {
                          _selectedLatitude = null;
                          _selectedLongitude = null;
                        });
                        return;
                      }

                      setState(() {
                        _selectedLatitude = location.latitude;
                        _selectedLongitude = location.longitude;
                      });
                    },
                  ),

                  const SizedBox(height: 18),

                  // ==================================================
                  // NAME
                  // ==================================================
                  CustomTextFormFieldAndLabel(
                    label: 'اسم المكان',
                    hint: 'اكتب اسم المكان',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك اكتب اسم المكان';
                      }

                      if (value.trim().length < 2) {
                        return 'اسم المكان قصير جدًا';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // DESCRIPTION
                  // ==================================================
                  CustomTextFormFieldAndLabel(
                    label: 'وصف المكان',
                    hint: 'اكتب وصفًا مختصرًا للمكان',
                    controller: _descriptionController,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك اكتب وصفًا مختصرًا للمكان';
                      }

                      if (value.trim().length > 500) {
                        return 'الوصف يجب ألا يتجاوز 500 حرف';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // ADDRESS
                  // ==================================================
                  CustomTextFormFieldAndLabel(
                    label: 'العنوان',
                    hint: 'اكتب عنوان المكان',
                    controller: _addressController,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك اكتب عنوان المكان';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  // ==================================================
                  // PHONE
                  // ==================================================
                  CustomTextFormFieldAndLabel(
                    label: 'رقم الموبايل (اختياري)',
                    hint: 'اكتب رقم موبايل المكان',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    isRequired: false,
                    validator: (value) {
                      final phone = value?.trim() ?? '';

                      if (phone.isEmpty) {
                        return null;
                      }

                      if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(phone)) {
                        return 'من فضلك اكتب رقم موبايل مصري صحيح';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // BUTTON
                  // ==================================================
                  CustomButtonWidget(
                    text: widget.isEditing
                        ? 'حفظ تعديلات المكان'
                        : 'طلب إضافة مكان في ${widget.category.name}',
                    icon: widget.isEditing
                        ? Icons.save_outlined
                        : Icons.add_location_alt_rounded,
                    onTap: isLoading ? null : _submitPlace,
                    isLoading: isLoading,
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
