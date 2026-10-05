import 'package:barnasht_app/core/services/get_it_service.dart';
import 'package:barnasht_app/core/services/location_service.dart';
import 'package:barnasht_app/core/services/notification_service.dart';
import 'package:barnasht_app/features/home/presentation/views/main_view.dart';
import 'package:barnasht_app/features/permissions/presentation/cubits/permission_onboarding_cubit.dart';
import 'package:barnasht_app/features/permissions/presentation/views/widgets/permission_onboarding_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PermissionOnboardingView extends StatefulWidget {
  const PermissionOnboardingView({super.key});

  static const String routeName = 'permission_onboarding_view';

  @override
  State<PermissionOnboardingView> createState() =>
      _PermissionOnboardingViewState();
}

class _PermissionOnboardingViewState extends State<PermissionOnboardingView>
    with WidgetsBindingObserver {
  late final PermissionOnboardingCubit _cubit;

  bool _waitingForSettings = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _cubit = PermissionOnboardingCubit(
      locationService: getIt<LocationService>(),
      notificationService: getIt<NotificationService>(),
    );

    _initialize();
  }

  Future<void> _initialize() async {
    await _cubit.initialize();

    if (!mounted) return;

    setState(() {
      _isInitialized = true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cubit.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      return;
    }

    if (!_waitingForSettings) {
      return;
    }

    if (!_isInitialized) {
      return;
    }

    _waitingForSettings = false;

    _cubit.refresh();
  }

  void _goToMain() {
    if (!mounted) return;

    Navigator.pushReplacementNamed(context, MainView.routeName);
  }

  Future<void> _openLocationSettings() async {
    _waitingForSettings = true;

    await _cubit.openLocationSettings();
  }

  Future<void> _openLocationAppSettings() async {
    _waitingForSettings = true;

    await _cubit.openLocationAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocListener<PermissionOnboardingCubit, PermissionOnboardingStep>(
        listener: (context, step) {
          if (step == PermissionOnboardingStep.completed) {
            _goToMain();
          }
        },
        child: PermissionOnboardingContent(
          onOpenLocationSettings: _openLocationSettings,
          onOpenLocationAppSettings: _openLocationAppSettings,
        ),
      ),
    );
  }
}
