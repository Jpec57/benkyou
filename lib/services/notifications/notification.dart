import 'dart:typed_data';

import 'package:benkyou/services/database/DBProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
typedef Future NotificationCallback(String payload);

Future scheduleNotification(BuildContext context, flutterLocalNotificationsPlugin, NotificationCallback callback) async {
  var initializationSettingsAndroid =
  new AndroidInitializationSettings('app_icon');
  var initializationSettingsIOS = new IOSInitializationSettings();
  var initializationSettings = new InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: callback);

  var scheduledNotificationDateTime = new DateTime.now().add(
//      new Duration(seconds: 4)
        new Duration(hours: 4)
  );
  var vibrationPattern = new Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;

  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      sound: 'test_sound',
      icon: 'app_icon',
      importance: Importance.Max,
      priority: Priority.High);

  var iOSPlatformChannelSpecifics =
  new IOSNotificationDetails(sound: null);
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

  var db = await DBProvider.db.database;
  var cards = await db.cardDao.findAvailableCards(DateTime.now().millisecondsSinceEpoch + 4 * 60 * 60 * 1000);
  int cardLength = cards.length;
  print(cardLength);
  if (cardLength > 1){
    await flutterLocalNotificationsPlugin.schedule(
      0,
      "Don't forget to work !",
      "You've got $cardLength cards to deal with",
      scheduledNotificationDateTime,
      platformChannelSpecifics,
      payload: 'Bonjour',
    );
  }

}


void setOneSignalListeners(){
  OneSignal.shared.init("dbab99b9-6140-4d2d-b89a-dcbc3674461f", iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.inAppLaunchUrl: true
  });
  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);

  OneSignal.shared
      .setNotificationReceivedHandler((OSNotification notification) {
    // will be called whenever a notification is received
    print('will be called whenever a notification is received');
  });

  OneSignal.shared
      .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    // will be called whenever a notification is opened/button pressed.
    print('will be called whenever a notification is opened/button pressed.');
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    // will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
    print('will be called whenever the permission changes');
  });

  OneSignal.shared
      .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
    // will be called whenever the subscription changes
    //(ie. user gets registered with OneSignal and gets a user ID)
    print('will be called whenever the subscription changes ');
  });

  OneSignal.shared.setEmailSubscriptionObserver(
          (OSEmailSubscriptionStateChanges emailChanges) {
        // will be called whenever then user's email subscription changes
        // (ie. OneSignal.setEmail(email) is called and the user gets registered
        print('will be called whenever then user\'s email subscription changes');
      });
}
