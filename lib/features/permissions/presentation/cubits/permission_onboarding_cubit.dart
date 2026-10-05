import 'package:barnasht_app/core/services/location_service.dart';
import 'package:barnasht_app/core/services/notification_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

enum PermissionOnboardingStep {
  loading,
  location,
  locationServiceDisabled,
  locationPermanentlyDenied,
  notification,
  completed,
}

class PermissionOnboardingCubit extends Cubit<PermissionOnboardingStep> {
  PermissionOnboardingCubit({
    required this.locationService,
    required this.notificationService,
  }) : super(PermissionOnboardingStep.loading);

  final LocationService locationService;
  final NotificationService notificationService;

  bool _isChecking = false;

  Future<void> initialize() async {
    await _checkLocation();
  }

  Future<void> _emitStep(PermissionOnboardingStep step) async {
    if (isClosed) return;

    emit(step);
  }

  Future<void> _checkLocation() async {
    if (isClosed || _isChecking) return;

    _isChecking = true;

    try {
      await _checkLocationInternal();
    } finally {
      _isChecking = false;
    }
  }

  Future<void> _checkLocationInternal() async {
    if (isClosed) return;

    await _emitStep(PermissionOnboardingStep.loading);

    final serviceEnabled = await locationService.isLocationServiceEnabled();

    if (isClosed) return;

    if (!serviceEnabled) {
      await _emitStep(PermissionOnboardingStep.locationServiceDisabled);
      return;
    }

    final permission = await locationService.getPermissionStatus();

    if (isClosed) return;

    switch (permission) {
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        await _checkNotification();
        break;

      case LocationPermission.denied:
        await _emitStep(PermissionOnboardingStep.location);
        break;

      case LocationPermission.deniedForever:
        await _emitStep(PermissionOnboardingStep.locationPermanentlyDenied);
        break;

      case LocationPermission.unableToDetermine:
        await _emitStep(PermissionOnboardingStep.location);
        break;
    }
  }

  Future<void> requestLocation() async {
    if (isClosed || _isChecking) return;

    _isChecking = true;

    try {
      await _requestLocationInternal();
    } finally {
      _isChecking = false;
    }
  }

  Future<void> _requestLocationInternal() async {
    if (isClosed) return;

    await _emitStep(PermissionOnboardingStep.loading);

    final serviceEnabled = await locationService.isLocationServiceEnabled();

    if (isClosed) return;

    if (!serviceEnabled) {
      await _emitStep(PermissionOnboardingStep.locationServiceDisabled);
      return;
    }

    final permission = await locationService.requestPermission();

    if (isClosed) return;

    switch (permission) {
      case LocationPermission.whileInUse:
      case LocationPermission.always:
        await _checkNotification();
        break;

      case LocationPermission.denied:
        await _emitStep(PermissionOnboardingStep.location);
        break;

      case LocationPermission.deniedForever:
        await _emitStep(PermissionOnboardingStep.locationPermanentlyDenied);
        break;

      case LocationPermission.unableToDetermine:
        await _emitStep(PermissionOnboardingStep.location);
        break;
    }
  }

  Future<void> openLocationSettings() async {
    if (isClosed) return;

    await locationService.openLocationSettings();
  }

  Future<void> openLocationAppSettings() async {
    if (isClosed) return;

    await locationService.openAppSettings();
  }

  Future<void> _checkNotification() async {
    if (isClosed) return;

    final status = await notificationService.getPermissionStatus();

    if (isClosed) return;

    if (status == PermissionStatus.granted) {
      await _finish();
      return;
    }

    if (await notificationService.isPermanentlyDenied()) {
      await _finish();
      return;
    }

    await _emitStep(PermissionOnboardingStep.notification);
  }

  Future<void> requestNotification() async {
    if (isClosed) return;

    await _emitStep(PermissionOnboardingStep.loading);

    final status = await notificationService.requestPermission();

    if (isClosed) return;

    if (status == PermissionStatus.granted) {
      await _finish();
      return;
    }

    if (await notificationService.isPermanentlyDenied()) {
      await _finish();
      return;
    }

    // تم رفض الإشعارات، لكن التطبيق لا يتوقف.
    await _finish();
  }

  Future<void> skipNotification() async {
    if (isClosed) return;

    await _finish();
  }

  Future<void> _finish() async {
    if (isClosed) return;

    await notificationService.initialize();

    if (isClosed) return;

    await _emitStep(PermissionOnboardingStep.completed);
  }

  Future<void> refresh() async {
    if (isClosed || _isChecking) return;

    await _checkLocation();
  }
}
