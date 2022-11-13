import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as image;
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
  options: DefaultFirebaseOptions.currentPlatform,
);
late Widget firstWidget;
String tag = 'main.dart ';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

////////////////////// start local notif
/////////////////////
int id = 0;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

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

const String navigationActionId = 'id_3';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notificationTapBackground');
  print('notificationTapBackground');
  print('notificationTapBackground');
  print('notificationTapBackground');
  print('notificationTapBackground');
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

RxBool notificationsEnabled = false.obs;
////////////////////// end local notif
/////////////////////
Future<void> main() async {
  // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'restoresto_repo',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();
  DynamicLinkService.initDynamicLinks();

  if (firebaseAuth.currentUser != null) {
    firstWidget = MainPage();
  } else {
    firstWidget = LoginPage();
  }
  Get.put(GlobalVar());
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

////////////////////// start local notif
/////////////////////
  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  String initialRoute = HomePage.routeName;
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

class HomePage extends StatefulWidget {
  const HomePage(
    this.notificationAppLaunchDetails, {
    Key? key,
  }) : super(key: key);

  static const String routeName = '/';

  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _linuxIconPathController =
      TextEditingController();

  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                children: <Widget>[
                  TextButton(
                      onPressed: () async {
                        await _showNotification();
                      },
                      child: Text('Show plain notification with payload'))
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        id++, 'plaindd title', 'plain body', notificationDetails,
        payload: 'item x');
  }
}
