import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:restoresto_repo/views/myaccount_page.dart';
import 'package:restoresto_repo/views/resto_page.dart';
import 'package:restoresto_repo/views/shopping_cart_page.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/main_controller.dart';
import '../controllers/shopping_cart_controller.dart';
import '../database/main_db.dart';
import '../helper/base_app_bar.dart';
import '../helper/global_var.dart';
import '../main.dart';
import 'myorder_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  final String tag = 'MainPage ';

  Future<bool> _onWillPop() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      debugPrint('FirebaseMessaging $notification');
      debugPrint('FirebaseMessaging $android');
      debugPrint('FirebaseMessaging ${message.data}');
    });
    return (await showDialog(
          context: Get.context!,
          builder: (context) => new AlertDialog(
            title: Text('Are you sure?'.tr),
            content: new Text('Do you want to exit an App'.tr),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'.tr),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'.tr),
              ),
            ],
          ),
        )) ??
        false;
  }

/*
  @override
  Widget build(BuildContext context) {
    MainDb.getMerchantData();
    return WillPopScope(
        onWillPop: _onWillPop,
        child: GetBuilder<MainController>(
            builder: (controller) => Scaffold(
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
                                  print('onPressed showNotification');
                                  const AndroidNotificationDetails
                                      androidNotificationDetails =
                                      AndroidNotificationDetails(
                                          'your channel id',
                                          'your channel name',
                                          channelDescription:
                                              'your channel description',
                                          importance: Importance.max,
                                          priority: Priority.high,
                                          ticker: 'ticker');
                                  const NotificationDetails
                                      notificationDetails = NotificationDetails(
                                          android: androidNotificationDetails);

                                  controller.flutterLocalNotificationsPlugin
                                      .show(id++, 'plaindd title', 'plain body',
                                          notificationDetails,
                                          payload: 'item x');
                                },
                                child: Text(
                                    'Show plain notification with payload'))
                          ],
                        ),
                      ),
                    ),
                  ),
                )));
  }

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

*/
  @override
  Widget build(BuildContext context) {
    MainDb.getMerchantData();
    return WillPopScope(
        onWillPop: _onWillPop,
        child: GetBuilder<MainController>(
            builder: (controller) => Scaffold(
                backgroundColor: GlobalVar.to.primaryBg,
                appBar: BaseAppBar(
                  title: Text(
                    'Restonomous'.tr,
                  ),
                  appBar: AppBar(),
                  widgets: <Widget>[],
                ),
                body: Container(
                  alignment: Alignment.topCenter,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        /*            TextButton(
                            onPressed: () async {
                              print('onPressed showNotification');
                              const AndroidNotificationDetails
                                  androidNotificationDetails =
                                  AndroidNotificationDetails(
                                      'your channel id', 'your channel name',
                                      channelDescription:
                                          'your channel description',
                                      importance: Importance.max,
                                      priority: Priority.high,
                                      ticker: 'ticker');
                              const NotificationDetails notificationDetails =
                                  NotificationDetails(
                                      android: androidNotificationDetails);

                              controller.flutterLocalNotificationsPlugin.show(
                                  id++,
                                  'plaindd title',
                                  'plain body',
                                  notificationDetails,
                                  payload: 'item x');
                            },
                            child:
                                Text('Show plain notification with payload')),
*/
                        /*  Expanded(
                              child: FutureBuilder<String>(
                                future: MainDb.getUserMerchant(), // async work
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return const Text('Loading....');
                                    default:
                                      if (snapshot.hasError) {
                                        return Text('Error: ${snapshot.error}');
                                      } else {
                                        if (snapshot.data == null) {
                                          return const Text(
                                            '0',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left,
                                          );
                                        } else {
                                          return Text(
                                            '${snapshot.data}',
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left,
                                          );
                                        }
                                      }
                                  }
                                },
                              ),
                            ),
                          */
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: SizedBox(
                            height: 95,
                            child: Card(
                              color: GlobalVar.to.primaryCard,
                              elevation: 5,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Obx(
                                        () => GlobalVar.to.merchantimageurlx
                                                .value.isNotEmpty
                                            ? Expanded(
                                                flex: 1,
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(
                                                        8.0),
                                                    child: Image.network(
                                                        GlobalVar
                                                            .to
                                                            .merchantimageurlx
                                                            .value,
                                                        width: 55.0,
                                                        fit: BoxFit.fitWidth,
                                                        loadingBuilder:
                                                            (BuildContext context,
                                                                Widget child,
                                                                ImageChunkEvent? loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) {
                                                        return child;
                                                      }
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    })))
                                            : Expanded(
                                                flex: 4,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Text(
                                                    'no resto'.tr,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Obx(() => GlobalVar.to.merchantimageurlx
                                              .value.isNotEmpty
                                          ? Expanded(
                                              flex: 3,
                                              child: Column(
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
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              GlobalVar
                                                                  .to
                                                                  .merchantnamex
                                                                  .value,
                                                              maxLines: 1,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
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
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              GlobalVar
                                                                  .to
                                                                  .merchantaddressx
                                                                  .value,
                                                              maxLines: 2,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ]))
                                          : SizedBox(
                                              width: 0,
                                            )),
                                      Expanded(
                                        flex: 1,
                                        child: Align(
                                            alignment: Alignment.topRight,
                                            child: TextButton(
                                              child: Text(
                                                'Change'.tr,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                              style: TextButton.styleFrom(
                                                  fixedSize:
                                                      Size.fromHeight(150)),
                                              onPressed: () {
                                                Get.toNamed('/resto');
                                              },
                                            )),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            alignment: Alignment.topCenter,
                            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                            margin: const EdgeInsets.symmetric(horizontal: 0),
                            child: Row(children: [
                              Obx(() =>
                                  '${controller.categorynamex.value}' != ''
                                      ? Text(
                                          '${controller.categorynamex.value}',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          'View All Menu'.tr,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ))
                            ])),
                        Obx(() => controller.merchantidx.value.isNotEmpty
                            ? Expanded(
                                child: StreamBuilder<QuerySnapshot>(
                                stream: MainDb.getMenu(
                                    controller.categoryidx.value),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot?> snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }

                                  if (snapshot.data == null) {
                                    return Container(
                                      padding: const EdgeInsets.all(30),
                                      child: Text(
                                        'no menu'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );

                                    /*      return const Center(
                                        child: SizedBox(
                                            width: 30,
                                            height: 30,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator())));
                                */
                                  }

                                  if (snapshot.data!.size == 0) {
                                    return Container(
                                      padding: const EdgeInsets.all(30),
                                      child: Text(
                                        'no menu'.tr,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    );
                                  }
                                  return controller.getMenuList(snapshot);
                                  //   return Container();
                                  //   return Friend(snapshot);
                                },
                              ))
                            : Container()),
                        Align(
                          alignment: FractionalOffset.bottomCenter,
                          child: Container(
                              color: Colors.grey[100],
                              margin: const EdgeInsets.all(0),
                              child: Row(
                                children: [
                                  Obx(() => Expanded(
                                        child: SizedBox(
                                            height: 60,
                                            child: InkWell(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  controller.numshopcart
                                                              .value !=
                                                          0
                                                      ? Badge(
                                                          badgeContent: Text(
                                                            '${controller.numshopcart.value}',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          child: Icon(
                                                            Icons.dining,
                                                            size: 25,
                                                            color: Colors.black,
                                                          ),
                                                        )
                                                      : Icon(
                                                          Icons.dining,
                                                          size: 25,
                                                          color: Colors.black,
                                                        ),
                                                  Expanded(
                                                      child: Text(
                                                    'Tray'.tr,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                    textAlign: TextAlign.left,
                                                  )),
                                                ],
                                              ),
                                              onTap: () {
                                                print("Tapped on container");
                                                print(
                                                    "${controller.numshopcart.value}");
                                                controller.merchantidx.value ==
                                                        ''
                                                    ? Get.snackbar(
                                                        "Your tray is empty".tr,
                                                        "You haven't chosen a restaurant yet"
                                                            .tr,
                                                        icon: Icon(Icons.warning,
                                                            size: 35,
                                                            color:
                                                                Colors.white),
                                                        snackPosition: SnackPosition
                                                            .BOTTOM,
                                                        backgroundColor:
                                                            Colors.red,
                                                        colorText: Colors.white)
                                                    : controller.numshopcart.value !=
                                                            0
                                                        ? Get.toNamed(
                                                            '/shoppingcart')
                                                        : Get.snackbar(
                                                            "Your tray is empty".tr, "Let's choose the menu".tr,
                                                            icon: Icon(
                                                                Icons.warning,
                                                                size: 35,
                                                                color: Colors.white),
                                                            snackPosition: SnackPosition.BOTTOM,
                                                            backgroundColor: Colors.red,
                                                            colorText: Colors.white);
                                              },
                                            )),
                                      )),
                                  Expanded(
                                    child: SizedBox(
                                        height: 60,
                                        child: InkWell(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.category,
                                                size: 25,
                                                color: Colors.black,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                'Category'.tr,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                                textAlign: TextAlign.left,
                                              )),
                                            ],
                                          ),
                                          onTap: () {
                                            print("Tapped on container");
                                            GlobalVar.to.merchantidx.value == ''
                                                ? Get.snackbar(
                                                    "No categories yet".tr,
                                                    "You haven't chosen a restaurant yet"
                                                        .tr,
                                                    icon: Icon(Icons.warning,
                                                        size: 35,
                                                        color: Colors.white),
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white)
                                                : Get.bottomSheet(
                                                    Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 30,
                                                            ),
                                                            Expanded(
                                                                flex: 2,
                                                                child: Text(
                                                                  'Category'.tr,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                )),
                                                            const SizedBox(
                                                              width: 50,
                                                            ),
                                                            Expanded(
                                                                flex: 1,
                                                                child:
                                                                    OutlinedButton(
                                                                  onPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                  child: Text(
                                                                    'Close'.tr,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .red,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                        ),
                                                        const SizedBox(
                                                          height: 0,
                                                        ),
                                                        Row(
                                                          children: [
                                                            const SizedBox(
                                                              width: 30,
                                                            ),
                                                            Expanded(
                                                                flex: 2,
                                                                child: TextButton(
                                                                    child: Align(
                                                                        alignment: Alignment.centerLeft,
                                                                        child: Text(
                                                                          'See all categories'
                                                                              .tr,
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: Colors.black,
                                                                              fontSize: 18,
                                                                              fontWeight: FontWeight.bold),
                                                                        )),
                                                                    onPressed: () {
                                                                      controller
                                                                          .setCat(
                                                                              '',
                                                                              '');
                                                                      Get.back();
                                                                    })),
                                                            const SizedBox(
                                                              width: 50,
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 0,
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                        ),
                                                        Obx(() => Expanded(
                                                                child: ListView
                                                                    .builder(
                                                              itemCount: GlobalVar
                                                                  .to
                                                                  .categorylistx
                                                                  .length,
                                                              itemBuilder:
                                                                  (BuildContext
                                                                          context,
                                                                      int index) {
                                                                return Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    UnconstrainedBox(
                                                                      child:
                                                                          Container(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            30,
                                                                            10,
                                                                            30,
                                                                            10),
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            controller.setCat('${GlobalVar.to.categorylistx[index]['categoryName']}',
                                                                                '${GlobalVar.to.categorylistx[index]['categoryID']}');
                                                                            print('You Tapped on ${GlobalVar.to.categorylistx[index]['categoryName']}');
                                                                            Get.back();
                                                                          },
                                                                          child: Text(
                                                                              GlobalVar.to.categorylistx[index]['categoryName'],
                                                                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Divider(
                                                                      thickness:
                                                                          1,
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ))),
                                                      ],
                                                    ),
                                                    backgroundColor:
                                                        Colors.white,
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                  );
                                            ;
                                          },
                                        )),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                        height: 60,
                                        child: InkWell(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.food_bank,
                                                size: 25,
                                                color: Colors.black,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                'My Order'.tr,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                                textAlign: TextAlign.left,
                                              )),
                                            ],
                                          ),
                                          onTap: () {
                                            print("Tapped on container 2");
                                            Get.to(() => MyorderPage());
                                          },
                                        )),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                        height: 60,
                                        child: InkWell(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.account_circle,
                                                size: 25,
                                                color: Colors.black,
                                              ),
                                              Expanded(
                                                  child: Text(
                                                'My Account'.tr,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                                textAlign: TextAlign.left,
                                              )),
                                            ],
                                          ),
                                          onTap: () {
                                            Get.toNamed('/myaccount');
                                          },
                                        )),
                                  ),
                                ],
                              )),
                        ),
                      ]),
                ))));
  }
}
