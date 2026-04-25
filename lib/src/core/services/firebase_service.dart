import 'dart:io';
import 'dart:async';
import 'package:soilreport/src/core/data/notification_device_model.dart';
import 'package:soilreport/src/features/authentication/data/auth_repository.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_service.g.dart';

@Riverpod(keepAlive: true)
FirebaseService firebaseService(Ref ref) {
  return FirebaseService();
}

@Riverpod()
Future<void> firebaseServiceInitializer(Ref ref) async {
  final auth = ref.read(authRepositoryProvider);
  final service = ref.read(firebaseServiceProvider);
  final pin = ref.read(authStateChangesProvider).value?.pin;
  try {
    await service.init(
          pin,
          onFcmTokenRegistered: auth.registerFcmToken,
        );
    ref.listen(authStateChangesProvider, (previous, next) {
      final prevPin = previous?.valueOrNull?.pin;
      final nextPin = next.valueOrNull?.pin;
      if (nextPin == prevPin) {
        return;
      }
      unawaited(service.onUserChanged(nextPin));
    });
  } catch (e) {
    debugPrint(e.toString());
  }
}


class FirebaseService{

  FirebaseService();
  StreamSubscription<String>? _tokenRefreshSubscription;
  bool _topicsSubscribed = false;
  String? _currentPin;
  Future<void> Function(String token)? _onFcmTokenRegistered;

  Future<void> init(
    String? pin, {
    Future<void> Function(String token)? onFcmTokenRegistered,
  }) async {
    _currentPin = pin;
    _onFcmTokenRegistered = onFcmTokenRegistered;
    try{
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      await _requestNotificationPermissions();
      await _setForegroundPresentationOptions();
      await _registerTokenRefreshListener();
      await _postCurrentDeviceInfo();
    } catch (ex) {
      debugPrint(ex.toString());
    }
  }

  /// Called when authenticated user changes (e.g. right after login).
  /// Reuses already-initialized messaging and pushes the current token for that user.
  Future<void> onUserChanged(String? pin) async {
    _currentPin = pin;
    if (pin == null || pin.isEmpty) {
      return;
    }
    await _postCurrentDeviceInfo();
  }

  Future<void> _registerTokenRefreshListener() async {
    if (_tokenRefreshSubscription != null) return;
    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh.listen(
      (fcmToken) async {
        final notificationModel = await getDeviceInfoForNotification(
          userId: _currentPin,
          token: fcmToken,
        );
        if (notificationModel != null) {
          debugPrint('FirebaseService: device token refreshed');
          await _subscribeToTopicsOnce();
          await _onFcmTokenRegistered?.call(fcmToken);
        }
      },
    );

    _tokenRefreshSubscription?.onError((err) {
      debugPrint(err.toString());
    });
  }

  Future<NotificationSettings?> _requestNotificationPermissions() async {
    try{
      final permission =  await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
      );
      return permission;
    } catch (e) {
      return null;
    }
  }

  Future<void> _setForegroundPresentationOptions() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _subscribeToTopicsOnce() async {
    if (_topicsSubscribed) return;
    _topicsSubscribed = true;
    await subscribeToTopics();
  }

  Future<void> _postCurrentDeviceInfo() async {
    try{
      final fcmToken = await FirebaseMessaging.instance.getToken();
      final initialModel = await getDeviceInfoForNotification(
        userId: _currentPin,
        token: fcmToken,
      );
      if (initialModel != null) {
        debugPrint('FirebaseService: FCM token obtained');
        final t = initialModel.token;
        if (t != null && t.isNotEmpty) {
          await _onFcmTokenRegistered?.call(t);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // This uses Settings.Secure.AndroidId
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor ?? ''; // This uses UIDevice.CurrentDevice.IdentifierForVendor
    } else {
      throw UnsupportedError('Platform not supported');
    }
  }

  Future<void> subscribeToTopics() async {
    await FirebaseMessaging.instance.subscribeToTopic("ALL");
    if (Platform.isAndroid) {
      await FirebaseMessaging.instance.subscribeToTopic("ANDROID");
      await FirebaseMessaging.instance.subscribeToTopic("INTERNAL-TEST");
    }else if(Platform.isIOS){
      await FirebaseMessaging.instance.subscribeToTopic("IOS");
    }
  }


  Future<NotificationDeviceModel?> getDeviceInfoForNotification({String? userId, String? token}) async {
    if (userId == null || userId.isEmpty) {
      return null;
    }

    token ??= await FirebaseMessaging.instance.getToken();
    final deviceId = await getDeviceId();
    
    final platform = Platform.isAndroid 
        ? PlatformType.android 
        : Platform.isIOS 
            ? PlatformType.ios 
            : throw UnsupportedError('Platform not supported');

    return NotificationDeviceModel(
      userId: userId,
      platform: platform,
      token: token,
      deviceId: deviceId,
    );
  }
  

}