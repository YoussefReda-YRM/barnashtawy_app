import 'package:barnasht_app/core/utils/app_images.dart';
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
  });

  final ValueChanged<LatLng?> onLocationChanged;
  final bool hasLocation;

  @override
  State<CustomLocationCardWidget> createState() =>
      _CustomLocationCardWidgetState();
}

class _CustomLocationCardWidgetState extends State<CustomLocationCardWidget> {
  GoogleMapController? _mapController;

  // ============================================================
  // BARNSHT BOUNDARY
  // ============================================================

  static const List<LatLng> _barnashtBoundary = [
    LatLng(29.70594145769904, 31.25065730002415),
    LatLng(29.70584825035551, 31.249906265550422),
    LatLng(29.70570844522191, 31.249208877344305),
    LatLng(29.706015973590112, 31.24916594550027),
    LatLng(29.70583883953148, 31.24720249829482),
    LatLng(29.7044036964276, 31.247224053929383),
    LatLng(29.700564285158215, 31.2456255201411),
    LatLng(29.698253053309116, 31.24446681427239),
    LatLng(29.697833622285344, 31.243190084644098),
    LatLng(29.6977496901967, 31.242052807522473),
    LatLng(29.69750739002469, 31.23922035595823),
    LatLng(29.696631376969634, 31.23943489941603),
    LatLng(29.696211988621076, 31.239563675307494),
    LatLng(29.693055849041706, 31.23816994642528),

    // start 3ezba
    LatLng(29.691801871226314, 31.23813394982131),
    LatLng(29.69177041965287, 31.23643781584134),
    LatLng(29.689235990494893, 31.236194071537902),
    LatLng(29.68917721183956, 31.236527880888904),
    LatLng(29.6861230755962, 31.235832709280754),
    // end 3ezba

    LatLng(29.685844491389055, 31.240375456287474),

    // تكملة برنشت قبل إضافة العزبة
    LatLng(29.68413393589217, 31.24005399155596),
    LatLng(29.684356269224565, 31.254853991251913),
    LatLng(29.688346562343654, 31.25365473021804),
    LatLng(29.68954364399999, 31.25926855473388),
    LatLng(29.70519284256306, 31.25477728325718),
    LatLng(29.705946300304888, 31.25077070574582),
  ];

  // ============================================================
  // BARNSHT BOUNDS
  // ============================================================

  static LatLngBounds get _barnashtBounds {
    double minLat = _barnashtBoundary.first.latitude;
    double maxLat = _barnashtBoundary.first.latitude;

    double minLng = _barnashtBoundary.first.longitude;
    double maxLng = _barnashtBoundary.first.longitude;

    for (final point in _barnashtBoundary) {
      if (point.latitude < minLat) {
        minLat = point.latitude;
      }

      if (point.latitude > maxLat) {
        maxLat = point.latitude;
      }

      if (point.longitude < minLng) {
        minLng = point.longitude;
      }

      if (point.longitude > maxLng) {
        maxLng = point.longitude;
      }
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

  // ============================================================
  // SELECTED LOCATION
  // ============================================================

  LatLng? _selectedLocation;

  LatLng? _previousLocation;

  // ============================================================
  // DRAG LOCATION
  // ============================================================

  LatLng? _draggedLocation;

  bool _isDraggingMarker = false;

  Offset? _markerOffset;

  // ============================================================
  // STATE
  // ============================================================

  bool _isGettingLocation = false;

  bool _mapInitialized = false;

  // ============================================================
  // BARNSHTAWY MARKER
  // ============================================================

  static const String _markerAsset = Assets.imagesAppLogoTransparent;

  // حجم الـ Marker على الشاشة
  static const double _markerSize = 70;

  final GlobalKey _mapKey = GlobalKey();

  // ============================================================
  // UPDATE MARKER SCREEN POSITION
  // ============================================================

  Future<void> _updateMarkerScreenPosition() async {
    if (_mapController == null || _selectedLocation == null) {
      return;
    }

    try {
      final ScreenCoordinate screenCoordinate = await _mapController!
          .getScreenCoordinate(_selectedLocation!);

      if (!mounted) return;

      final double devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

      // ScreenCoordinate بالفعل relative للـ GoogleMap
      final double x = screenCoordinate.x / devicePixelRatio;
      final double y = screenCoordinate.y / devicePixelRatio;

      setState(() {
        _markerOffset = Offset(x - (_markerSize / 2), y - _markerSize);
      });
    } catch (e) {
      debugPrint('Failed to update marker screen position: $e');
    }
  }

  // ============================================================
  // MARKER DRAG START
  // ============================================================

  void _onMarkerPanStart(DragStartDetails details) {
    if (_selectedLocation == null) return;

    _previousLocation = _selectedLocation;
    _draggedLocation = _selectedLocation;

    setState(() {
      _isDraggingMarker = true;
    });
  }

  // ============================================================
  // MARKER DRAG UPDATE
  // ============================================================

  Future<void> _onMarkerPanUpdate(DragUpdateDetails details) async {
    if (_mapController == null) return;

    final RenderBox? mapBox =
        _mapKey.currentContext?.findRenderObject() as RenderBox?;

    if (mapBox == null) return;

    final double devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    final Offset mapGlobalPosition = mapBox.localToGlobal(Offset.zero);

    // مكان إصبع المستخدم داخل الخريطة
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

        _markerOffset = Offset(
          localPosition.dx - (_markerSize / 2),
          localPosition.dy - _markerSize,
        );
      });
    } catch (_) {
      // Ignore conversion errors.
    }
  }

  // ============================================================
  // MARKER DRAG END
  // ============================================================

  void _onMarkerPanEnd(DragEndDetails details) {
    setState(() {
      _isDraggingMarker = false;
    });

    final LatLng? newLocation = _draggedLocation;

    if (newLocation == null) {
      return;
    }

    // ==========================================================
    // LOCATION OUTSIDE BARNSHT
    // ==========================================================

    if (!_isInsideBarnasht(newLocation)) {
      buildBar(
        context,
        'الموقع خارج نطاق قرية برنشت، اختر موقعًا داخل القرية',
        type: SnackBarType.info,
      );

      if (_previousLocation != null) {
        _updateSelectedLocation(_previousLocation!);
      }

      return;
    }

    // ==========================================================
    // VALID LOCATION
    // ==========================================================

    _updateSelectedLocation(newLocation);
  }

  // ============================================================
  // UPDATE SELECTED LOCATION
  // ============================================================

  void _updateSelectedLocation(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });

    widget.onLocationChanged(location);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMarkerScreenPosition();
    });
  }

  // ============================================================
  // USE MY LOCATION
  // ============================================================

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

      // ========================================================
      // CHECK BARNSHT
      // ========================================================

      if (!_isInsideBarnasht(location)) {
        if (!mounted) return;

        buildBar(
          context,
          'موقعك الحالي خارج نطاق قرية برنشت',
          type: SnackBarType.info,
        );

        return;
      }

      _updateSelectedLocation(location);

      // ========================================================
      // MOVE CAMERA
      // ========================================================

      if (_mapController != null) {
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: location, zoom: 18),
          ),
        );
      }

      await Future.delayed(const Duration(milliseconds: 300));

      await _updateMarkerScreenPosition();
    } catch (e) {
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

  // ============================================================
  // INITIAL USER LOCATION
  // ============================================================

  Future<void> _initializeUserLocation() async {
    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return;
      }

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

      // ========================================================
      // CHECK BARNSHT
      // ========================================================

      if (!_isInsideBarnasht(location)) {
        if (!mounted) return;

        buildBar(
          context,
          'موقعك الحالي خارج نطاق قرية برنشت',
          type: SnackBarType.info,
        );

        return;
      }

      _updateSelectedLocation(location);

      // ========================================================
      // MOVE CAMERA
      // ========================================================

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
      // Ignore location initialization errors.
    }
  }

  // ============================================================
  // CHECK LOCATION INSIDE BARNSHT
  // ============================================================

  bool _isInsideBarnasht(LatLng point) {
    bool inside = false;

    for (
      int i = 0, j = _barnashtBoundary.length - 1;
      i < _barnashtBoundary.length;
      j = i++
    ) {
      final double xi = _barnashtBoundary[i].latitude;

      final double yi = _barnashtBoundary[i].longitude;

      final double xj = _barnashtBoundary[j].latitude;

      final double yj = _barnashtBoundary[j].longitude;

      final bool intersect =
          ((yi > point.longitude) != (yj > point.longitude)) &&
          (point.latitude <
              (xj - xi) * (point.longitude - yi) / (yj - yi) + xi);

      if (intersect) {
        inside = !inside;
      }
    }

    return inside;
  }

  // ============================================================
  // MAP TAP
  // ============================================================

  void _onMapTap(LatLng location) {
    // ==========================================================
    // CHECK BARNSHT
    // ==========================================================

    if (!_isInsideBarnasht(location)) {
      buildBar(
        context,
        'الموقع خارج نطاق قرية برنشت، اختر موقعًا داخل القرية',
        type: SnackBarType.info,
      );

      return;
    }

    // ==========================================================
    // UPDATE LOCATION
    // ==========================================================

    _previousLocation = _selectedLocation;

    _updateSelectedLocation(location);
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final hasLocation = _selectedLocation != null;

    // Semantic colors
    final successColor = colorScheme.primary;

    final errorColor = colorScheme.error;

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
            // ==================================================
            // HEADER
            // ==================================================

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              child: Row(
                children: [
                  // ==================================================
                  // LOCATION ICON
                  // ==================================================

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

                  // ==================================================
                  // TITLE
                  // ==================================================
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

                  // ==================================================
                  // USE MY LOCATION
                  // ==================================================
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

            // ==================================================
            // MAP
            // ==================================================
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 230,
                child: Stack(
                  key: _mapKey,
                  children: [
                    // ==================================================
                    // GOOGLE MAP
                    // ==================================================

                    GoogleMap(
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(29.695, 31.247),
                        zoom: 14,
                      ),

                      // ==================================================
                      // BARNSHT BOUNDS
                      // ==================================================
                      cameraTargetBounds: CameraTargetBounds(_barnashtBounds),

                      minMaxZoomPreference: const MinMaxZoomPreference(
                        13.0,
                        20.0,
                      ),
                      onTap: _onMapTap,

                      // ==================================================
                      // MAP CREATED
                      // ==================================================
                      onMapCreated: (controller) async {
                        _mapController = controller;

                        if (_mapInitialized) {
                          return;
                        }

                        _mapInitialized = true;

                        await Future.delayed(const Duration(milliseconds: 300));

                        if (!mounted) {
                          return;
                        }

                        // تحديد موقع المستخدم
                        await _initializeUserLocation();

                        // لو مفيش Location
                        if (_selectedLocation == null) {
                          await controller.animateCamera(
                            CameraUpdate.newLatLngBounds(_barnashtBounds, 30),
                          );
                        }

                        await Future.delayed(const Duration(milliseconds: 150));

                        await _updateMarkerScreenPosition();
                      },

                      // ==================================================
                      // CAMERA MOVE
                      // ==================================================
                      onCameraMove: (_) {
                        if (!_isDraggingMarker) {
                          _updateMarkerScreenPosition();
                        }
                      },

                      // ==================================================
                      // CAMERA IDLE
                      // ==================================================
                      onCameraIdle: () {
                        _updateMarkerScreenPosition();
                      },

                      // ==================================================
                      // POLYGON
                      // ==================================================
                      polygons: {
                        Polygon(
                          polygonId: const PolygonId('barnasht_boundary'),
                          points: _barnashtBoundary,
                          strokeWidth: 2,
                          strokeColor: successColor,
                          fillColor: successColor.withValues(alpha: 0.08),
                        ),
                      },

                      // ==================================================
                      // NO GOOGLE MARKER
                      // ==================================================
                      markers: const {},

                      // ==================================================
                      // MY LOCATION
                      // ==================================================
                      myLocationEnabled: true,

                      myLocationButtonEnabled: false,

                      // ==================================================
                      // CONTROLS
                      // ==================================================
                      zoomControlsEnabled: false,

                      mapToolbarEnabled: false,

                      compassEnabled: false,

                      // ==================================================
                      // GESTURES
                      // ==================================================
                      rotateGesturesEnabled: true,

                      scrollGesturesEnabled: true,

                      zoomGesturesEnabled: true,

                      // ==================================================
                      // GESTURE RECOGNIZER
                      // ==================================================
                      gestureRecognizers:
                          <Factory<OneSequenceGestureRecognizer>>{
                            Factory<OneSequenceGestureRecognizer>(
                              () => EagerGestureRecognizer(),
                            ),
                          },
                    ),

                    // ==================================================
                    // CUSTOM DRAGGABLE MARKER
                    // ==================================================
                    if (_selectedLocation != null && _markerOffset != null)
                      Positioned(
                        left: _markerOffset!.dx,
                        top: _markerOffset!.dy,
                        width: _markerSize,
                        height: _markerSize,
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,

                          // يبدأ السحب فورًا
                          onPanStart: _onMarkerPanStart,

                          onPanUpdate: _onMarkerPanUpdate,

                          onPanEnd: _onMarkerPanEnd,

                          child: Image.asset(
                            _markerAsset,
                            width: _markerSize,
                            height: _markerSize,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                    // ==================================================
                    // LOADING
                    // ==================================================
                    if (_isGettingLocation)
                      Positioned.fill(
                        child: Container(
                          color: Colors.white.withValues(alpha: 0.55),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),

                    // ==================================================
                    // MY LOCATION BUTTON
                    // ==================================================
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ==================================================
            // LOCATION STATUS
            // ==================================================
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
                  // ==================================================
                  // STATUS ICON
                  // ==================================================

                  Icon(
                    hasLocation
                        ? Icons.location_searching_rounded
                        : Icons.location_off_rounded,
                    size: 18,
                    color: hasLocation ? successColor : errorColor,
                  ),

                  const SizedBox(width: 7),

                  // ==================================================
                  // STATUS TEXT
                  // ==================================================
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hasLocation ? 'الموقع المحدد' : 'الموقع مطلوب',
                          style: TextStyles.semiBold11.copyWith(
                            color: hasLocation ? successColor : errorColor,
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          hasLocation
                              ? '${_selectedLocation!.latitude.toStringAsFixed(6)} , '
                                    '${_selectedLocation!.longitude.toStringAsFixed(6)}'
                              : 'اسحب علامة برنشتاوي إلى موقع المكان',
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
