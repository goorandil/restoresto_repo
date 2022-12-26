import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:workmanager/workmanager.dart';

import 'binding/main_binding.dart';
import 'firebase_options.dart';
import 'helper/firebase_auth_constants.dart';
import 'helper/global_var.dart';
import 'helper/languages.dart';
import 'routes/app_pages.dart';
import 'utils/dynamic_link_service.dart';
import 'views/login_page.dart';
import 'views/main_page.dart';

final Future<FirebaseApp> _initialization = Firebase.initializeApp(
  name: "restonomous",
  options: DefaultFirebaseOptions.currentPlatform,
);
late Widget firstWidget;
String tag = 'main.dart ';

/// Initialize the [FlutterLocalNotificationsPlugin] package.
//late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;

  debugPrint('firebaseMessagingBackgroundHandler ${notification!.title}');
  debugPrint('firebaseMessagingBackgroundHandler ${notification.body}');

  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('soundid2', 'soundname2',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound('mysound'),
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  /// ini yg lokal notif
  flutterLocalNotificationsPlugin.show(
      id++,
      message.notification!.title.toString(),
      message.notification!.body.toString(),
      notificationDetails,
      payload: 'item x');

  if (notification != null && android != null) {
    debugPrint('FirebaseMessaging flutterLocalNotificationsPlugin');
  }
}

////////////////////// start local notif
/////////////////////
int id = 0;

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

String? selectedNotificationPayload;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

RxBool notificationsEnabled = false.obs;
////////////////////// end local notif
/////////////////////
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'restonomous',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();
  Get.put(GlobalVar());

  DynamicLinkService.initDynamicLinks();

  if (firebaseAuth.currentUser != null) {
    firstWidget = MainPage();
  } else {
    firstWidget = LoginPage();
  }

  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

////////////////////// start local notif
/////////////////////
  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;
  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_stat_transparan');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
  _isAndroidPermissionGranted();
  _requestPermissions();
  _configureDidReceiveLocalNotificationSubject();
  _configureSelectNotificationSubject();

  ////////////////////// end local notif
/////////////////////
  runApp(const MyApp());
}

////////////////////// start local notif
/////////////////////
Future<void> _isAndroidPermissionGranted() async {
  if (Platform.isAndroid) {
    final bool granted = await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;

    notificationsEnabled.value = granted;
  }
}

Future<void> _requestPermissions() async {
  if (Platform.isIOS || Platform.isMacOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          critical: true,
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
          critical: true,
        );
  } else if (Platform.isAndroid) {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    final bool? granted = await androidImplementation?.requestPermission();

    notificationsEnabled.value = granted ?? false;
  }
}

void _configureDidReceiveLocalNotificationSubject() {
  didReceiveLocalNotificationStream.stream
      .listen((ReceivedNotification receivedNotification) async {
    await showDialog(
      context: Get.context!,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: receivedNotification.title != null
            ? Text(receivedNotification.title!)
            : null,
        content: receivedNotification.body != null
            ? Text(receivedNotification.body!)
            : null,
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () async {},
            child: const Text('Ok'),
          )
        ],
      ),
    );
  });
}

void _configureSelectNotificationSubject() {
  selectNotificationStream.stream.listen((String? payload) async {});
}

////////////////////// end local notif
/////////////////////
///
///
//
////////////////////// start work manager
/////////////////////
const simpleTaskKey = "be.tramckrijte.workmanagerExample.simpleTask";
const rescheduledTaskKey = "be.tramckrijte.workmanagerExample.rescheduledTask";
const failedTaskKey = "be.tramckrijte.workmanagerExample.failedTask";
const simpleDelayedTask = "be.tramckrijte.workmanagerExample.simpleDelayedTask";
const simplePeriodicTask =
    "be.tramckrijte.workmanagerExample.simplePeriodicTask";
const simplePeriodic1HourTask =
    "be.tramckrijte.workmanagerExample.simplePeriodic1HourTask";

@pragma('vm:entry-point')
// Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  debugPrint('callbackDispatcher');
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case simpleTaskKey:
        print("$simpleTaskKey was executed.  ");
        break;
      case rescheduledTaskKey:
        final key = inputData!['key']!;
        break;
      case failedTaskKey:
        print('failed task');
        return Future.error('failed');
      case simpleDelayedTask:
        print("$simpleDelayedTask was executed");
        break;
      case simplePeriodicTask:
        print("$simplePeriodicTask was executed");
        break;
      case simplePeriodic1HourTask:
        print("$simplePeriodic1HourTask was executed");
        break;
      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        break;
    }

    return Future.value(true);
  });
}

////////////////////// end work manager
/////////////////////
///
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          //    return MyAwesomeApp();

          return GetMaterialApp(
            title: 'Restonomous',
            debugShowCheckedModeBanner: false,
            translations: Languages(),
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('en', 'US'),
            theme: ThemeData(
              primaryColor: const Color(0xFFFFFFFF),
              primaryColorDark: const Color(0xFFFFFFFF),
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
                  .copyWith(secondary: const Color(0xFFFFFFFF)),
            ),
            initialBinding: MainBinding(),
            getPages: AppPages.pages,
            home: firstWidget,
            builder: EasyLoading.init(),
          );
          //  LoginPage(title: 'Contreng! Kampus'),
          //  );
        } else {
          // Otherwise, show something whilst waiting for initialization to complete
          return const Center(
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(child: CircularProgressIndicator())));
        }
      },
    );
  }
}
