import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static LocalNotificationService _viewModel;

  static LocalNotificationService getInstance() {
    if (_viewModel == null) {
      _viewModel = LocalNotificationService();
    }
    return _viewModel;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future initialize() async {
    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('');
    IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings(onDidReceiveLocalNotification: (id, title, body, _) {
      print(id);
      print(title);
      print(body);
      return Future.value();
    });
    InitializationSettings initializationSettings = InitializationSettings(androidInitializationSettings, iosInitializationSettings);
    return flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future scheduling({DateTime firedTime, String title, String body}) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('', '', '');
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    return flutterLocalNotificationsPlugin.schedule(0, title, body, firedTime, notificationDetails, androidAllowWhileIdle: true);
  }

  Future cancelAll() {
    return flutterLocalNotificationsPlugin.cancelAll();
  }
}
