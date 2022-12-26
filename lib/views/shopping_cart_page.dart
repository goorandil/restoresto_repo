import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/main_controller.dart';
import '../controllers/shopping_cart_controller.dart';
import '../helper/global_var.dart';
import '../helper/page_app_bar.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({Key? key}) : super(key: key);

  final String tag = 'ShoppingCartPage ';

  Future<bool> _onWillPop() async {
    Get.toNamed('/main');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: GetBuilder<ShoppingCartController>(
            builder: (controller) => Scaffold(
                backgroundColor: GlobalVar.to.primaryBg,
                appBar: PageAppBar(
                  title: Text('Tray'.tr),
                  backbutton: '/main',
                  appBar: AppBar(),
                  widgets: <Widget>[
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                body: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.all(0),
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                          margin: const EdgeInsets.symmetric(horizontal: 0),
                          child: Row(children: [
                            Text(
                              'Total : Rp. ${controller.saldo.format(int.parse(controller.getSumTotal().toString()))}',
                              //  'Total : ${controller.getSumTotal()}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          ])),
                      GlobalVar.to.shopcartList.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  key: Key(GlobalVar.to.shopcartList.length
                                      .toString()),
                                  shrinkWrap: true,
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 10, 10),
                                  itemCount: GlobalVar.to.shopcartList.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                        onTap: () {},
                                        child: Card(
                                            color: Colors.white,
                                            elevation: 5,
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Column(children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: GlobalVar
                                                              .to
                                                              .shopcartList
                                                              .isNotEmpty
                                                          ? ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      8.0),
                                                              child: Image.network(
                                                                  '${GlobalVar.to.shopcartList[index]['menuimageurl']}',
                                                                  width: 45.0,
                                                                  fit: BoxFit
                                                                      .fitWidth,
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
                                                              }))
                                                          : Text('Loading ...'.tr),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      flex: 5,
                                                      child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      '${GlobalVar.to.shopcartList[index]['menuname']}',
                                                                      style: TextStyle(
                                                                          color: GlobalVar
                                                                              .to
                                                                              .colorText,
                                                                          fontSize:
                                                                              18,
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
                                                                  flex: 3,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      '${GlobalVar.to.shopcartList[index]['menudescription']}',
                                                                      style: TextStyle(
                                                                          color: GlobalVar
                                                                              .to
                                                                              .primaryText,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      // '${shopcartList[index]['menuprice']}',
                                                                      'Rp. ${controller.saldo.format(int.parse(GlobalVar.to.shopcartList[index]['menuprice'].toString()))}',
                                                                      style: TextStyle(
                                                                          color: GlobalVar
                                                                              .to
                                                                              .colorText,
                                                                          fontWeight:
                                                                              FontWeight.normal),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerLeft,
                                                                    child: Text(
                                                                      '${'Qty'.tr} : ${GlobalVar.to.shopcartList[index]['qty']}',
                                                                      style: const TextStyle(
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex: 3,
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topRight,
                                                                    child: Text(
                                                                      // '${shopcartList[index]['sumtot'].toString()}',
                                                                      'Rp. ${controller.saldo.format(int.parse(GlobalVar.to.shopcartList[index]['sumtot'].toString()))}',
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          color: Colors
                                                                              .red,
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ]),
                                                    ),
                                                  ],
                                                ),
                                                Divider(
                                                  thickness: 1,
                                                ),
                                                SizedBox(
                                                  height: 25,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: <Widget>[
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.edit),
                                                        iconSize: 25.0,
                                                        color: Colors.red,
                                                        onPressed: () {
                                                          MainController.to.qty
                                                                  .value =
                                                              int.parse(GlobalVar
                                                                      .to
                                                                      .shopcartList[
                                                                  index]['qty']);
                                                          Get.defaultDialog(
                                                            titlePadding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(15),
                                                            title:
                                                                'Change the qty'
                                                                    .tr,

                                                            content: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  '${userBox.read('editmenuname')}',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: GlobalVar
                                                                          .to
                                                                          .colorText),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    TextButton(
                                                                      child:
                                                                          Text(
                                                                        '-',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                22,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: GlobalVar.to.primaryText),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        MainController
                                                                            .to
                                                                            .qtyDecrease();
                                                                      },
                                                                    ),
                                                                    Obx(() =>
                                                                        Text(
                                                                          '${MainController.to.qty.value}',
                                                                          style: TextStyle(
                                                                              fontSize: 20,
                                                                              fontWeight: FontWeight.bold),
                                                                        )),
                                                                    TextButton(
                                                                      child:
                                                                          Text(
                                                                        '+',
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                            color: GlobalVar.to.primaryText),
                                                                      ),
                                                                      onPressed:
                                                                          () async {
                                                                        MainController
                                                                            .to
                                                                            .qtyIncrease();
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
                                                                  style: TextStyle(
                                                                      color: GlobalVar
                                                                          .to
                                                                          .primaryText),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  Get.back();
                                                                },
                                                              ),
                                                              TextButton(
                                                                child: Text(
                                                                  'Change'.tr,
                                                                  style: TextStyle(
                                                                      color: GlobalVar
                                                                          .to
                                                                          .primaryText),
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  controller
                                                                      .updateQty(
                                                                          index);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                            Icons.delete),
                                                        iconSize: 25.0,
                                                        color: Colors.red,
                                                        onPressed: () {
                                                          controller.deleteItem(
                                                              index);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ]),
                                            )));
                                  }))
                          : Container(
                              padding: const EdgeInsets.all(30),
                              child: Text('No data yet'.tr),
                            ),
                      Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Container(
                            color: Colors.grey[100],
                            margin: const EdgeInsets.all(0),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(10),
                                      child: SizedBox(
                                          height: 50,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              userBox.write('ordertotal',
                                                  '${controller.getSumTotal()}');
                                              print(
                                                  "Tapped shopcart ${MainController.to.emailstatusx.value}");
                                              Get.toNamed('/checkout');

                                              /*   MainController
                                                      .to.emailstatusx.value
                                                  ? controller.getUserData()
                                                  : null;
                                              userBox.read('username') != ''
                                                  ? MainController
                                                          .to.emailstatusx.value
                                                      ? Get.to(
                                                          () => CheckoutPage())
                                                      : Get.defaultDialog(
                                                          titlePadding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(15),
                                                          title:
                                                              'You are not logged in yet'
                                                                  .tr,
                                                          content: Text(
                                                              'Login now?'.tr),
                                                          //  backgroundColor: Colors.teal,

                                                          radius: 30,
                                                          actions: <Widget>[
                                                            TextButton(
                                                              child: Text(
                                                                'Cancel'.tr,
                                                                style: TextStyle(
                                                                    color: GlobalVar
                                                                        .to
                                                                        .primaryText),
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
                                                                        .to
                                                                        .primaryText),
                                                              ),
                                                              onPressed: () {
                                                                Get.back();
                                                                // klik login cek uid punya email ngak
                                                                MainController
                                                                    .to
                                                                    .checkAuth2();
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                  : Get.defaultDialog(
                                                      titlePadding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      contentPadding:
                                                          const EdgeInsets.all(
                                                              15),
                                                      title:
                                                          'Your profile is not complete'
                                                              .tr,
                                                      content: Text(
                                                          'Complete now?'.tr),
                                                      //  backgroundColor: Colors.teal,

                                                      radius: 30,
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: Text(
                                                            'Cancel'.tr,
                                                            style: TextStyle(
                                                                color: GlobalVar
                                                                    .to
                                                                    .primaryText),
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
                                                                    .to
                                                                    .primaryText),
                                                          ),
                                                          onPressed: () {
                                                            Get.back();
                                                            // klik login cek uid punya email ngak
                                                            Get.to(() =>
                                                                ProfilePage());
                                                          },
                                                        ),
                                                      ],
                                                    );*/
                                            },
                                            style: ElevatedButton.styleFrom(
                                                elevation: 5,
                                                primary:
                                                    GlobalVar.to.primaryButton,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15,
                                                        vertical: 0),
                                                textStyle: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),

                                            child: Text('next'.tr),
                                            // obs
                                          )),
                                    )),
                              ],
                            )),
                      ),
                    ],
                  ),
                ))));
  }
}
