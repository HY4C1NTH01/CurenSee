
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotiService{
  final notificationsPlugin = FlutterLocalNotificationsPlugin();

  final bool _isInitialised = false;

  bool get isInitialised => _isInitialised;

  Future<void> initNotification() async{
    if(_isInitialised) return;

    const initSettingsAndroid = AndroidInitializationSettings('assets/images/logo.jpg',);

    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true
    );

    const initSettingsWindows = WindowsInitializationSettings(
      appName: 'CurrenSee',
      appUserModelId: '14d678j',
      guid: 'Dear'
    );

    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
      windows: initSettingsWindows
    );
  }

  NotificationDetails notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails('ID', 'Channel Notifications',
      channelDescription: 'CurenSee Notifications', importance: Importance.max,
      priority: Priority.high, playSound: true),

     iOS: DarwinNotificationDetails(),

    windows: WindowsNotificationDetails(),);
  }

  Future<void> showNotifications({
    int id = 0,
    String? title,
    String? body
  }) async{
    return notificationsPlugin.show(id, title, body, notificationDetails());
  }
}