import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:new_version/new_version.dart';
import 'package:restoresto_repo/helper/firebase_auth_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/main_db.dart';
import '../helper/global_var.dart';
import '../main.dart';
import '../utils/dynamic_link_service.dart';
import '../views/resto_page.dart';

class MainController extends GetxController {
  static MainController get to => Get.find<MainController>();
  late String userBalance;

  RxString logOut = 'Logout'.tr.obs;
  RxString deeplink = ''.obs;
  RxString merchantidx = 'null'.obs;
  RxString ordertotal = '0'.obs;
  RxBool _notificationsEnabled = false.obs;

  RxInt qty = 1.obs;
  RxInt numshopcart = 0.obs;
  RxString shareApp =
      'https://play.google.com/store/apps/details?id=com.bingkaiapp.restoresto'
          .obs;

  var uid;

  RxString categoryidx = ''.obs;
  RxString categorynamex = ''.obs;

  RxBool emailstatusx = false.obs;

  var userCredential;
  var tabIndex = 0;
  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  final saldo = NumberFormat.currency(
      locale: 'id_ID', customPattern: '#,###', symbol: 'Rp.', decimalDigits: 0);
  final newVersion = NewVersion(
    iOSId: 'com.bingkaiapp.restoresto',
    androidId: 'com.bingkaiapp.restoresto',
  );

  //// start push notif
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  ///// end push notif

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  late DateFormat dateFormat;
/*
  void setupWorkManager() async {
    debugPrint('setupWorkManager');
    Workmanager().registerOneOffTask("task-identifier", "control",
        initialDelay: Duration(seconds: 10));
  }
*/
  @override
  Future<void> onInit() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint('fcmToken  $fcmToken');
    MainDb.updateFcmToken(fcmToken);

//////start messaging
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      debugPrint(message.notification!.title.toString());
      debugPrint(message.notification!.body.toString());
      debugPrint('FirebaseMessaging onMessage $notification.body');
      debugPrint('FirebaseMessaging onMessage $android');
      debugPrint(
          'FirebaseMessaging ${message.data}'); // If `onMessage` is triggered with a notification, construct our own
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('your channel id', 'your channel name',
              channelDescription: 'your channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      flutterLocalNotificationsPlugin.show(
          id++,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails,
          payload: 'item x');

      //  update();
      // setupWorkManager();
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        debugPrint('FirebaseMessaging flutterLocalNotificationsPlugin');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      //   Navigator.pushNamed(context, '/message',
      //       arguments: MessageArguments(message, true));
    });

    //final pushNotificationService = PushNotificationService(firebaseMessaging);
    //pushNotificationService.initialise();
    //  await _configureLocalTimeZone();
//    await _initializeNotification();
//////end messaging
    super.onInit();

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    Get.put(GlobalVar());
    GlobalVar.to.categorylistx.clear();

    getDeepLink();
    MainDb.getUserData();
    MainDb.getMerchantData();
    // MainDb.migrateCat();
    // MainDb.migrateMenu();
    // MainDb.migrateResto();

    // print('User granted permission: ${settings.authorizationStatus}');

//    _isAndroidPermissionGranted();
    //  _requestPermissions();
    //  _configureDidReceiveLocalNotificationSubject();
    //  _configureSelectNotificationSubject();
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      _notificationsEnabled.value = granted;
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
      _notificationsEnabled.value = granted ?? false;
    }
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      /*   await showDialog(
        context: context,
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
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        SecondPage(receivedNotification.payload),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
 */
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      // await Navigator.of(context).push(MaterialPageRoute<void>(
      //    builder: (BuildContext context) => SecondPage(payload),
      //  ));
    });
  }

  Future<void> showNotification(notificationDetails) =>
      flutterLocalNotificationsPlugin.show(
          id++, 'plaindd title', 'plain body', notificationDetails,
          payload: 'item x');

  @override
  void dispose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    super.dispose();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> _initializeNotification() async {
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> registerMessage({
    required int hour,
    required int minutes,
    required message,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minutes,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Terimakasih',
      message,
      scheduledDate,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          importance: Importance.max,
          priority: Priority.high,
          ongoing: true,
          styleInformation: BigTextStyleInformation(message),
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          badgeNumber: 1,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  getUserMerchant() async => firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .get()
          .then((value) {
        if (value.exists) {
          if (value.data().toString().contains('merchantID') != null) {
            return SizedBox(
              height: 90,
              child: Card(
                color: GlobalVar.to.primaryCard,
                elevation: 5,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Obx(() => GlobalVar
                                  .to.merchantimageurlx.value.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                      GlobalVar.to.merchantimageurlx.value,
                                      width: 45.0,
                                      fit: BoxFit.fitWidth,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }))
                              : SizedBox()),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            flex: 3,
                            child: Obx(() => GlobalVar
                                    .to.merchantimageurlx.value.isNotEmpty
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  GlobalVar
                                                      .to.merchantnamex.value,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  GlobalVar.to.merchantaddressx
                                                      .value,
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ])
                                : SizedBox())),
                        Expanded(
                          flex: 1,
                          child: Align(
                              alignment: Alignment.topRight,
                              child: TextButton(
                                child: Text(
                                  'Change'.tr,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                ),
                                style: TextButton.styleFrom(
                                    fixedSize: Size.fromHeight(150)),
                                onPressed: () {
                                  Get.to(() => RestoPage());
                                },
                              )),
                        ),
                      ]),
                ),
              ),
            );
          } else {
            return Text("Loading...");
          }
        } else {
          return Text("Loading...");
        }
      });

  Widget getMenuList(AsyncSnapshot<QuerySnapshot<Object?>?> snapshot) {
    if (snapshot.hasData) {
      //   print('getMenuList ${snapshot.data!.docs.length}');
      return ListView.builder(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return getDataMenu(snapshot, index);
          });
    } else {
      return const Center(
          child: SizedBox(
              width: 30,
              height: 30,
              child: Center(child: CircularProgressIndicator())));
    }
  }

  getNumShopcart() {
    int? numtot = 0;
    numtot = shopcartList.length;
    // print('getNumShopcart length ${shopcartList.length}');
    numshopcart.value = numtot;
    update();
  }

  Widget getDataMenu(
      AsyncSnapshot<QuerySnapshot<Object?>?> snapshot, int index) {
    return InkWell(
        onTap: () {
          qty.value = 1;
          // inimah buat edit
          userBox.write('editmenuid', snapshot.data!.docs[index].id);
          userBox.write('editmenuname', snapshot.data!.docs[index]['menuName']);
          userBox.write('editmenudescription',
              snapshot.data!.docs[index]['menuDescription']);
          userBox.write(
              'editmenuprice', snapshot.data!.docs[index]['menuPrice']);
          userBox.write(
              'editmenuimageurl', snapshot.data!.docs[index]['menuImageurl']);
          userBox.write(
              'editmenustatus', snapshot.data!.docs[index]['menuStatus']);
          userBox.write('editmenucategoryname',
              snapshot.data!.docs[index]['menuCategoryName']);
          userBox.write('editmenucategoryid',
              snapshot.data!.docs[index]['menuCategoryID']);

          //    selectedState.value = snapshot.data!.docs[index]['categoryID'];

          snapshot.data!.docs[index]['menuStatus']
              ? Get.defaultDialog(
                  titlePadding: const EdgeInsets.all(15),
                  contentPadding: const EdgeInsets.all(15),
                  title: 'Put it in your tray'.tr,

                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${userBox.read('editmenuname')}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: GlobalVar.to.primaryButton),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: Text(
                              '-',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: GlobalVar.to.primaryText),
                            ),
                            onPressed: () async {
                              qtyDecrease();
                            },
                          ),
                          Obx(() => Text(
                                '${qty.value}',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )),
                          TextButton(
                            child: Text(
                              '+',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: GlobalVar.to.primaryText),
                            ),
                            onPressed: () async {
                              qtyIncrease();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  //  backgroundColor: Colors.teal,

                  radius: 30,
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Cancel'.tr,
                        style: TextStyle(color: GlobalVar.to.primaryText),
                      ),
                      onPressed: () async {
                        Get.back();
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Add'.tr,
                        style: TextStyle(color: GlobalVar.to.primaryText),
                      ),
                      onPressed: () async {
                        addToCart();
                      },
                    ),
                  ],
                )
              : Get.defaultDialog(
                  titlePadding: const EdgeInsets.all(15),
                  contentPadding: const EdgeInsets.all(15),
                  title: 'Notification'.tr,
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Out of stock'.tr,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: GlobalVar.to.primaryButton),
                      ),
                    ],
                  ),
                  radius: 30,
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        'Ok'.tr,
                        style: TextStyle(color: GlobalVar.to.primaryText),
                      ),
                      onPressed: () async {
                        Get.back();
                      },
                    ),
                  ],
                );
        },
        child: Card(
          color: GlobalVar.to.primaryCard,
          elevation: 5,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: snapshot.hasData
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                              '${snapshot.data!.docs[index]['menuImageurl']}',
                              width: 45.0,
                              fit: BoxFit.fitWidth, loadingBuilder:
                                  (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }))
                      : Text('Loading ...'.tr),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    flex: 5,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${snapshot.data!.docs[index]['menuName']}',
                                    style: TextStyle(
                                        color: GlobalVar.to.colorText,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${snapshot.data!.docs[index]['menuDescription']}',
                                    style: TextStyle(
                                        color: GlobalVar.to.primaryText,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${snapshot.data!.docs[index]['menuCategoryName']}',
                                    style: TextStyle(
                                        color: GlobalVar.to.colorText,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    //  '${snapshot.data!.docs[index]['menuPrice']}',
                                    'Rp. ${saldo.format(int.parse(snapshot.data!.docs[index]['menuPrice'].toString()))}',
                                    style: TextStyle(
                                        color: GlobalVar.to.colorText,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child:
                                      '${snapshot.data!.docs[index]['menuStatus']}' ==
                                              'true'
                                          ? Text(
                                              '',
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              'Out of stock'.tr,
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                ),
                              )
                            ],
                          ),
                        ])),
              ],
            ),
          ),
        ));
  }

  Future<void> getDeepLink() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    FirebaseDynamicLinks.instance.onLink;
    String? restoid;
    String? merchantidx;

    if (deepLink != null) {
      print('MainPage deepLink $deepLink');
      //   deeplink.value = '$deepLink';
      //  if (deepLink.queryParameters.containsKey('eventcode')) {
      restoid = deepLink.queryParameters['restoid'];
      merchantidx = deepLink.queryParameters['merchantid'];
      print('MainPage restoid $restoid');
      print('MainPage merchantidx $merchantidx');
    } else {
      print('MainPage deepLink null');
    }
  }

  void qtyIncrease() {
    print('qtyIncrease ${qty.value}');
    qty.value++;
  }

  void qtyDecrease() {
    print('qtyDecrease ${qty.value}');
    if (qty.value >= 2) qty.value--;
  }

  Future<void> addToCart() async {
    print('menuid ${userBox.read('editmenuid')}');
    print('menuname ${userBox.read('editmenuname')}');
    print('menudescription ${userBox.read('editmenudescription')}');
    print('menuprice ${userBox.read('editmenuprice')}');
    print('menuimageurl ${userBox.read('editmenuimageurl')}');
    print('menustatus ${userBox.read('editmenustatus')}');
    print('menucategory ${userBox.read('editmenucategory')}');
    print('menucategoryid ${userBox.read('editmenucategoryid')}');

    print('qty ${qty.value}');
    var sumtot = qty.value * int.parse(userBox.read('editmenuprice'));
    print('sumtot ${sumtot}');

    Map<String, dynamic> someMap = {
      'menuid': '${userBox.read('editmenuid')}',
      'menuname': '${userBox.read('editmenuname')}',
      'menudescription': '${userBox.read('editmenudescription')}',
      'menuprice': '${userBox.read('editmenuprice')}',
      'menuimageurl': '${userBox.read('editmenuimageurl')}',
      'menustatus': '${userBox.read('editmenustatus')}',
      'menucategoryname': '${userBox.read('editmenucategoryname')}',
      'menucategoryid': '${userBox.read('editmenucategoryid')}',
      'qty': '${qty.value}',
      'sumtot': '${sumtot}',
      'isumtot': sumtot,
    };

    shopcartList.add(someMap);

    await Future.delayed(
        const Duration(seconds: 1), () => print('User account created'));
    Get.back();
    getNumShopcart();
    print('shopcartList.length $shopcartList.length');
  }

  void setCat(String categoryname, String categoryid) {
    print('setCat categoryname $categoryname');
    print('setCat categoryid $categoryid');
    categoryidx.value = categoryid;
    categorynamex.value = categoryname;
  }

  Future<void> logoutGoogle() async {
    print('logoutGoogle');
    print('logoutGoogle ${FirebaseAuth.instance.signOut()}');

    //  await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    SystemNavigator.pop();

    // navigate to your wanted page after logout.
  }

  void checkAuth() {
    print('checkAuth');
    firebaseAuth.authStateChanges().listen((User? user) async {
      // cek ulang apakah authnya udah ada
      // mestinya mah udah ada ya

      if (user == null) {
        print('checkAuth ==null');
      } else {
        // pengecekan apakah udah ada email belum
        // untiuk uid yg aktif
        MainDb.checkEmailUser(user.uid);
        print('checkAuth ${user.uid}');
      }
    });
  }

  void checkAuth2() {
    print('checkAuth2');
    print('checkAuth2 restoid ${userBox.read('restoid')}');
    firebaseAuth.authStateChanges().listen((User? user) async {
      if (user == null) {
        print('checkAuth2 ==null');
        //    Get.snackbar("Error", "checkAuth ==null", backgroundColor: Colors.red);
      } else {
        //  Get.snackbar("Error", "checkAuth ", backgroundColor: Colors.red);
        MainDb.checkEmailUser2(user.uid);
        print('checkAuth2 ${user.uid}');
      }
    });
  }

  Future<String?> signinWithGoogle() async {
    print('signinWithGoogle');
    print('signinWithGoogle restoid ${userBox.read('restoid')}');

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      // kalau ngak eror akan kesini
      // kondisi uid ada di collection dan belum ada email
      // dan email yg dimasukin juga belum pernah login

      print('signinWithGoogle try');

      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);

      MainDb.updateUserEmail(userCredential!);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          // kalau login email ternyata udah ada konek ke uid nya
          // set status nya true
          MainDb.updateUserEmail(userCredential);

          MainController.to.emailstatusx.value = true;
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          // ini kondisi uid yg belum punya email, dan user
          // login menggunakan email yg udah pernah login
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");

          // login dengan pilihan email
          // maka auth akan pindah ke uid yg ada emailnya
          final userCredentialx =
              await firebaseAuth.signInWithCredential(credential);

          MainDb.updateUserEmail(userCredentialx);
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      }
      /*  try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final authResult = await firebaseAuth.signInWithCredential(credential);

      final User? user = authResult.user;
      final User? currentUser = firebaseAuth.currentUser;
      print('user $user');
      assert(!user!.isAnonymous);
      assert(await user?.getIdToken() != null);
      assert(user!.uid == currentUser!.uid);
      assert(user?.email != null);
      assert(user?.displayName != null);
      assert(user?.photoURL != null);

      //   MainDb.getUserdata(firebaseAuth.currentUser!.email);

      //   Get.to(() => MainPage());
    } catch (e) {
      // ignore: avoid_print
      print('catch loginWithGoogle $e');
    }
    return null;
  }*/
    }
    return null;
  }
}
