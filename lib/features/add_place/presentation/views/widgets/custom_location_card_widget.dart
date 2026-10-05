import 'package:barnasht_app/core/helper_functions/get_location_name.dart';
import 'package:barnasht_app/core/utils/app_text_styles.dart';
import 'package:barnasht_app/core/widgets/build_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomLocationCardWidget extends StatefulWidget {
  const CustomLocationCardWidget({
    super.key,
    required this.onLocationChanged,
    this.hasLocation = false,
    this.initialLocation,
  });

  final ValueChanged<LatLng?> onLocationChanged;
  final bool hasLocation;
  final LatLng? initialLocation;

  @override
  State<CustomLocationCardWidget> createState() =>
      _CustomLocationCardWidgetState();
}

class _CustomLocationCardWidgetState extends State<CustomLocationCardWidget> {
  GoogleMapController? _mapController;

  LatLng? _selectedLocation;
  LatLng? _pinLocation;
  LatLng? _draggedLocation;

  String? _locationName;

  bool _isGettingLocationName = false;
  bool _isDraggingMarker = false;
  bool _isGettingLocation = false;
  bool _mapInitialized = false;

  Offset? _markerOffset;

  static const double _markerSize = 40;

  final GlobalKey _mapKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _pinLocation = widget.initialLocation;
      _loadLocationName(widget.initialLocation!);
    }
  }

  Future<void> _loadLocationName(LatLng location) async {
    if (!mounted) return;

    setState(() {
      _isGettingLocationName = true;
      _locationName = null;
    });

    final String? name = await LocationUtils.getLocationName(location);

    if (!mounted) return;

    setState(() {
      _locationName = name;
      _isGettingLocationName = false;
    });
  }

  Future<void> _updateMarkerScreenPosition() async {
    if (_mapController == null || _pinLocation == null) return;

    try {
      final ScreenCoordinate screenCoordinate = await _mapController!
          .getScreenCoordinate(_pinLocation!);

      if (!mounted) return;

      final double devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

      setState(() {
        _markerOffset = Offset(
          screenCoordinate.x / devicePixelRatio - (_markerSize / 2),
          screenCoordinate.y / devicePixelRatio - _markerSize,
        );
      });
    } catch (e) {
      debugPrint('Failed to update marker position: $e');
    }
  }

  void _onMarkerPanStart(DragStartDetails details) {
    if (_pinLocation == null) return;

    _draggedLocation = _pinLocation;

    setState(() {
      _isDraggingMarker = true;
    });
  }

  Future<void> _onMarkerPanUpdate(DragUpdateDetails details) async {
    if (_mapController == null) return;

    final RenderBox? mapBox =
        _mapKey.currentContext?.findRenderObject() as RenderBox?;

    if (mapBox == null) return;

    final double devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
    final Offset mapGlobalPosition = mapBox.localToGlobal(Offset.zero);
    final Offset localPosition = details.globalPosition - mapGlobalPosition;

    final ScreenCoordinate screenCoordinate = ScreenCoordinate(
      x: (localPosition.dx * devicePixelRatio).round(),
      y: (localPosition.dy * devicePixelRatio).round(),
    );

    try {
      final LatLng newLocation = await _mapController!.getLatLng(
        screenCoordinate,
      );

      if (!mounted) return;

      setState(() {
        _draggedLocation = newLocation;
        _pinLocation = newLocation;
        _markerOffset = Offset(
          localPosition.dx - (_markerSize / 2),
          localPosition.dy - _markerSize,
        );
      });
    } catch (_) {}
  }

  void _onMarkerPanEnd(DragEndDetails details) {
    setState(() {
      _isDraggingMarker = false;
    });

    final LatLng? location = _draggedLocation;

    if (location != null) {
      _updateSelectedLocation(location);
    }
  }

  void _updateSelectedLocation(LatLng location) {
    setState(() {
      _selectedLocation = location;
      _pinLocation = location;
      _locationName = null;
      _isGettingLocationName = true;
    });

    widget.onLocationChanged(location);
    _loadLocationName(location);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMarkerScreenPosition();
    });
  }

  Future<void> _useMyLocation() async {
    if (_isGettingLocation) return;

    setState(() {
      _isGettingLocation = true;
    });

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        buildBar(
          context,
          'من فضلك قم بتفعيل خدمة الموقع',
          type: SnackBarType.info,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        buildBar(context, 'تم رفض صلاحية الموقع', type: SnackBarType.info);
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        buildBar(
          context,
          'صلاحية الموقع مرفوضة نهائيًا، قم بتفعيلها من إعدادات التطبيق',
          type: SnackBarType.info,
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final LatLng location = LatLng(position.latitude, position.longitude);

      _updateSelectedLocation(location);

      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: location, zoom: 18),
          ),
        );
      }

      await Future.delayed(const Duration(milliseconds: 300));
      await _updateMarkerScreenPosition();
    } catch (_) {
      if (!mounted) return;

      buildBar(context, 'حدث خطأ أثناء تحديد موقعك', type: SnackBarType.info);
    } finally {
      if (mounted) {
        setState(() {
          _isGettingLocation = false;
        });
      }
    }
  }

  Future<void> _initializeUserLocation() async {
    if (widget.initialLocation != null) return;

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final LatLng location = LatLng(position.latitude, position.longitude);

      if (!mounted) return;

      setState(() {
        _pinLocation = location;
      });

      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: location, zoom: 18),
          ),
        );
      }

      await Future.delayed(const Duration(milliseconds: 300));
      await _updateMarkerScreenPosition();
    } catch (_) {}
  }

  void _onMapTap(LatLng location) {
    _updateSelectedLocation(location);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final bool hasLocation = _selectedLocation != null;
    final Color successColor = colorScheme.primary;
    final Color errorColor = colorScheme.error;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: hasLocation
              ? successColor.withValues(alpha: 0.25)
              : errorColor.withValues(alpha: 0.25),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: successColor.withValues(alpha: 0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: successColor.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: successColor,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'موقع المكان',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.semiBold13.copyWith(
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '*',
                          style: TextStyles.semiBold13.copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _isGettingLocation ? null : _useMyLocation,
                      borderRadius: BorderRadius.circular(11),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: successColor.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _isGettingLocation
                                ? SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: successColor,
                                    ),
                                  )
                                : Icon(
                                    Icons.my_location_rounded,
                                    size: 16,
                                    color: successColor,
                                  ),
                            const SizedBox(width: 5),
                            Text(
                              'استخدم موقعي',
                              style: TextStyles.semiBold11.copyWith(
                                color: successColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 230,
                child: Stack(
                  key: _mapKey,
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target:
                            widget.initialLocation ??
                            const LatLng(30.0444, 31.2357),
                        zoom: widget.initialLocation != null ? 18 : 12,
                      ),
                      minMaxZoomPreference: const MinMaxZoomPreference(2, 20),
                      onTap: _onMapTap,
                      onMapCreated: (controller) async {
                        _mapController = controller;

                        if (_mapInitialized) return;

                        _mapInitialized = true;

                        await Future.delayed(const Duration(milliseconds: 300));

                        if (!mounted) return;

                        if (widget.initialLocation != null) {
                          await controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: widget.initialLocation!,
                                zoom: 18,
                              ),
                            ),
                          );
                        } else {
                          await _initializeUserLocation();
                        }

                        await Future.delayed(const Duration(milliseconds: 150));

                        await _updateMarkerScreenPosition();
                      },
                      onCameraMove: (_) {
                        if (!_isDraggingMarker) {
                          _updateMarkerScreenPosition();
                        }
                      },
                      onCameraIdle: _updateMarkerScreenPosition,
                      markers: const {},
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      compassEnabled: false,
                      rotateGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      zoomGesturesEnabled: true,
                      gestureRecognizers: {
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        ),
                      },
                    ),
                    if (_pinLocation != null && _markerOffset != null)
                      Positioned(
                        left: _markerOffset!.dx,
                        top: _markerOffset!.dy,
                        width: _markerSize,
                        height: _markerSize,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onPanStart: _onMarkerPanStart,
                          onPanUpdate: _onMarkerPanUpdate,
                          onPanEnd: _onMarkerPanEnd,
                          child: Icon(
                            Icons.location_pin,
                            size: _markerSize,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    if (_isGettingLocation)
                      Positioned.fill(
                        child: Container(
                          color: Colors.white.withValues(alpha: 0.55),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: hasLocation
                    ? successColor.withValues(alpha: 0.06)
                    : errorColor.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    hasLocation
                        ? Icons.location_searching_rounded
                        : Icons.location_off_rounded,
                    size: 18,
                    color: hasLocation ? successColor : errorColor,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasLocation ? 'اسم المكان' : 'الموقع مطلوب',
                          style: TextStyles.semiBold11.copyWith(
                            color: hasLocation ? successColor : errorColor,
                          ),
                        ),
                        const SizedBox(height: 3),
                        if (hasLocation && _isGettingLocationName)
                          Text(
                            'جاري تحديد اسم المكان...',
                            style: TextStyles.regular11.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.75,
                              ),
                            ),
                          )
                        else
                          Text(
                            hasLocation
                                ? (_locationName ?? 'تعذر تحديد اسم المكان')
                                : 'حدّد موقع المكان على الخريطة أو استخدم موقعك الحالي.',
                            style: TextStyles.regular11.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.75,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
