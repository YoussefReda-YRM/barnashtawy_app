import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<PermissionStatus> getPermissionStatus() async {
    return Permission.notification.status;
  }

  Future<PermissionStatus> requestPermission() async {
    return Permission.notification.request();
  }

  Future<bool> isPermanentlyDenied() async {
    return Permission.notification.isPermanentlyDenied;
  }

  Future<bool> openSettings() {
    return openAppSettings();
  }

  Future<void> initialize() async {
    await _messaging.setAutoInitEnabled(true);

    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<String?> getToken() async {
    return _messaging.getToken();
  }
}