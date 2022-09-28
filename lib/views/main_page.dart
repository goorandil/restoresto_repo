import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
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
import '../helper/global_var.dart';
import 'myorder_page.dart';

class MainPage extends StatelessWidget {
  MainPage({Key? key}) : super(key: key);

  final MainController controller = Get.put(MainController(), permanent: false);
  final String tag = 'MainPage ';

  final int activePage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: GlobalVar.to.primaryBg,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: GlobalVar.to.primary,
          automaticallyImplyLeading: false,
          title: Text(
            'main_page_title'.tr,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Obx(() => controller.emailstatusx.value
                ? Container()
                : TextButton(
                    child: Text(
                      'login'.tr,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    style:
                        TextButton.styleFrom(fixedSize: Size.fromHeight(150)),
                    onPressed: () {
                      controller.emailstatusx.value
                          ? Get.to(MyaccountPage())
                          : Get.defaultDialog(
                              titlePadding: const EdgeInsets.all(15),
                              contentPadding: const EdgeInsets.all(15),
                              title: 'You are not logged in yet'.tr,
                              content: Text('Login now?'.tr),
                              //  backgroundColor: Colors.teal,

                              radius: 30,
                              actions: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Cancel'.tr,
                                    style: TextStyle(
                                        color: GlobalVar.to.primaryText),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                                TextButton(
                                  child: Text(
                                    'Yes'.tr,
                                    style: TextStyle(
                                        color: GlobalVar.to.primaryText),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                    // klik login cek uid punya email ngak
                                    controller.checkAuth2();
                                  },
                                ),
                              ],
                            );
                    },
                  )),
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: Colors.white,
                            elevation: 5,
                            child: SizedBox(
                              height: 70,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Obx(() => controller.restoidx.value.isNotEmpty
                                      ? Expanded(
                                          flex: 3,
                                          child: FutureBuilder<Widget>(
                                            future:
                                                MainDb.checkUid(), // async work
                                            builder: (BuildContext context,
                                                AsyncSnapshot<Widget>
                                                    snapshot) {
                                              switch (
                                                  snapshot.connectionState) {
                                                case ConnectionState.waiting:
                                                  return Text('Loading....'.tr);
                                                default:
                                                  if (snapshot.hasError) {
                                                    return Text(
                                                        'Error: ${snapshot.error}');
                                                  } else {
                                                    if (snapshot.data == null) {
                                                      return const Expanded(
                                                          child: Text(
                                                        '0',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ));
                                                    } else {
                                                      return snapshot.data!;
                                                    }
                                                  }
                                              }
                                            },
                                          ),
                                        )
                                      : Container()),
                                  Expanded(
                                      child: Container(
                                    alignment: Alignment.centerRight,
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
                                    ),
                                  )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    child: Row(children: [
                      Obx(() => '${controller.categorynamex.value}' != ''
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
                Obx(() => controller.restoidx.value.isNotEmpty
                    ? Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                        stream: MainDb.getMenu(controller.categoryidx.value),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot?> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          if (snapshot.data == null) {
                            return const Center(
                                child: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Center(
                                        child: CircularProgressIndicator())));
                          }

                          if (snapshot.data!.size == 0) {
                            return Container(
                              padding: const EdgeInsets.all(30),
                              child: Text('no menu'.tr),
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
                                          controller.numshopcart.value != 0
                                              ? Badge(
                                                  badgeContent: Text(
                                                    '${controller.numshopcart.value}',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white),
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
                                          Text(
                                            'Tray'.tr,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12),
                                            textAlign: TextAlign.left,
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        print("Tapped on container");
                                        print(
                                            "${controller.numshopcart.value}");
                                        controller.restoidx.value == 'null'
                                            ? Get.snackbar(
                                                "Your tray is empty".tr,
                                                "You haven't chosen a restaurant yet"
                                                    .tr,
                                                icon: Icon(Icons.warning,
                                                    size: 35,
                                                    color: Colors.white),
                                                snackPosition:
                                                    SnackPosition.BOTTOM,
                                                backgroundColor: Colors.red,
                                                colorText: Colors.white)
                                            : controller.numshopcart.value != 0
                                                ? Get.to(
                                                    () => ShoppingCartPage())
                                                : Get.snackbar(
                                                    "Your tray is empty".tr,
                                                    "Let's choose the menu".tr,
                                                    icon: Icon(Icons.warning,
                                                        size: 35,
                                                        color: Colors.white),
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.category,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        'Category'.tr,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    print("Tapped on container");

                                    controller.restoidx.value == 'null'
                                        ? Get.snackbar(
                                            "No categories yet".tr,
                                            "You haven't chosen a restaurant yet"
                                                .tr,
                                            icon: Icon(Icons.warning,
                                                size: 35, color: Colors.white),
                                            snackPosition: SnackPosition.BOTTOM,
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
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )),
                                                    const SizedBox(
                                                      width: 50,
                                                    ),
                                                    Expanded(
                                                        flex: 1,
                                                        child: OutlinedButton(
                                                          onPressed: () {
                                                            Get.back();
                                                          },
                                                          child:
                                                              Text('Close'.tr),
                                                        )),
                                                  ],
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                ),
                                                Expanded(
                                                    child: ListView.builder(
                                                  itemCount:
                                                      controller.list.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        UnconstrainedBox(
                                                          child: Container(
                                                            padding: EdgeInsets
                                                                .fromLTRB(30,
                                                                    10, 30, 10),
                                                            child: InkWell(
                                                              onTap: () {
                                                                controller.setCat(
                                                                    '${controller.list[index]['categoryName']}',
                                                                    '${controller.list[index]['categoryID']}');
                                                                print(
                                                                    'You Tapped on ${controller.list[index]['categoryName']}');
                                                                Get.back();
                                                              },
                                                              child: Text(
                                                                  controller.list[
                                                                          index]
                                                                      [
                                                                      'categoryName'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ),
                                                          ),
                                                        ),
                                                        Divider(
                                                          thickness: 1,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                )),
                                              ],
                                            ),
                                            backgroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.food_bank,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        'My Order'.tr,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                        textAlign: TextAlign.left,
                                      ),
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.account_circle,
                                        size: 25,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        'My Account'.tr,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 12),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    print(
                                        "Tapped on restoid ${userBox.read('restoid')}");
                                    print(
                                        "Tapped on container3 ${controller.emailstatusx.value}");
                                    controller.emailstatusx.value
                                        ? Get.to(() => MyaccountPage())
                                        : Get.defaultDialog(
                                            titlePadding:
                                                const EdgeInsets.all(15),
                                            contentPadding:
                                                const EdgeInsets.all(15),
                                            title:
                                                'You are not logged in yet'.tr,
                                            content: Text('Login now?'.tr),
                                            //  backgroundColor: Colors.teal,

                                            radius: 30,
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text(
                                                  'Cancel'.tr,
                                                  style: TextStyle(
                                                      color: GlobalVar
                                                          .to.primaryText),
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                              ),
                                              TextButton(
                                                child: Text(
                                                  'Yes'.tr,
                                                  style: TextStyle(
                                                      color: GlobalVar
                                                          .to.primaryText),
                                                ),
                                                onPressed: () {
                                                  Get.back();
                                                  // klik login cek uid punya email ngak
                                                  controller.checkAuth2();
                                                },
                                              ),
                                            ],
                                          );
                                  },
                                )),
                          ),
                        ],
                      )),
                ),
              ]),
        ));
  }
}
