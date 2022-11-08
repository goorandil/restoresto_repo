import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restoresto_repo/controllers/main_controller.dart';
import 'package:restoresto_repo/controllers/myaccount_controller.dart';
import 'package:restoresto_repo/views/main_page.dart';
import 'package:restoresto_repo/views/shopping_cart_page.dart';
import '../database/resto_db.dart';
import '../helper/firebase_auth_constants.dart';
import '../helper/global_var.dart';
import 'package:camera/camera.dart';

import '../utils/dynamic_link_service.dart';

class ShoppingCartController extends GetxController {
  RxString usernamex = ''.obs;
  RxInt sumtotalx = 0.obs;
  final saldo = NumberFormat.currency(
      locale: 'id_ID', customPattern: '#,###', symbol: 'Rp.', decimalDigits: 0);

  @override
  Future<void> onInit() async {
    super.onInit();
    sumtotalx.value = 0;
  }

  getSumTotal() {
    int? sumtot = 0;
    shopcartList.forEach((element) {
      sumtot = sumtot! + int.parse(element['sumtot']);
      userBox.write('sumtotstr', sumtot.toString());
    });
    userBox.write('sumtot', sumtot);
    return '$sumtot';
  }

  void getUserData() {
    print('getUserData ${firebaseAuth.currentUser!.uid}');
    firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      userBox.write('fcmtoken', value.get('fcmToken'));
      userBox.write('username', value.get('userName'));
      userBox.write('useremail', value.get('userEmail'));
      userBox.write('userimageurl', value.get('userImageurl'));
      userBox.write('useraddress', value.get('userAddress'));
      userBox.write('userPhone', value.get('userPhone'));
      userBox.write('userid', value.id);
      usernamex.value = value.get('userName');
      print('getUserData userEmail ${value.get('userEmail')}');
      print('getUserData userName ${value.get('userName')}');
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Widget getShoppingCartList(AsyncSnapshot<QuerySnapshot<Object?>?> snapshot2) {
    if (snapshot2.hasData) {
      return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
          itemCount: snapshot2.data!.docs.length,
          itemBuilder: (context, i) {
            return StreamBuilder<DocumentSnapshot>(
                stream: _applicationStream(snapshot2.data!.docs[i].id),
                builder: (context, snapshot) {
                  print(' snapshot.hasData ' + snapshot.hasData.toString());

                  return InkWell(
                      onTap: () {
                        // inimah buat edit
                        userBox.write('editrestoid', snapshot.data!.id);
                        // inimah buat paket

                        Get.defaultDialog(
                          titlePadding: const EdgeInsets.all(15),
                          contentPadding: const EdgeInsets.all(15),
                          title: 'what will you do?'.tr,
                          content: Text('Select'.tr),
                          //  backgroundColor: Colors.teal,

                          radius: 30,
                          actions: <Widget>[
                            TextButton(
                              child: Text(
                                'Select'.tr,
                                style:
                                    TextStyle(color: GlobalVar.to.primaryText),
                              ),
                              onPressed: () {
                                RestoDb.takeResto();
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Delete'.tr,
                                style:
                                    TextStyle(color: GlobalVar.to.primaryText),
                              ),
                              onPressed: () {
                                RestoDb.deleteMymerchant(
                                    GlobalVar.to.merchantidx.value);
                              },
                            ),
                          ],
                        );
                      },
                      child: snapshot.hasData
                          ? Card(
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
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                              '${snapshot.data!.get('restoImageurl')}',
                                              width: 45.0,
                                              fit: BoxFit.fitWidth,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          })),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        flex: 5,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        snapshot.data!.get(
                                                                'restoName') ??
                                                            "",
                                                        style: const TextStyle(
                                                            color: Colors.black,
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
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        snapshot.data!.get(
                                                                'restoPhone') ??
                                                            "",
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
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
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                        '${snapshot.data!.get('restoAddress')}',
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ])),
                                  ],
                                ),
                              ),
                            )
                          : Text('Loading ...'.tr));
                });

            //  return getDataResto(snapshot, index);
          });
    } else {
      return const Center(
          child: SizedBox(
              width: 30,
              height: 30,
              child: Center(child: CircularProgressIndicator())));
    }
  }

  _applicationStream(String id) {
    print('_applicationStream $id');
    return firebaseFirestore.collection('restos').doc(id).snapshots();
  }

  void updateQty(int index) {
    print('updateQty index ${index}');
    print('updateQty qty ${shopcartList[index]['qty']}');
    shopcartList[index]['qty'] = '${MainController.to.qty.value}';
    int sumtot = int.parse(shopcartList[index]['qty']) *
        int.parse('${shopcartList[index]['menuprice']}');
    shopcartList[index]['sumtot'] = '$sumtot';
    shopcartList[index]['isumtot'] = sumtot;
    print('updateQty qty ${shopcartList[index]['qty']}');
    update();
    Get.back();
    update();
    // Get.to(() => MainPage());
  }

  void deleteItem(int index) {
    print('deleteItem index ${index}');
    print('deleteItem length ${shopcartList.length}');
    shopcartList.removeAt(index);
    print('deleteItem length ${shopcartList.length}');
    MainController.to.getNumShopcart();
    //  Get.to(() => MainPage());
    update();
    if (shopcartList.length == 0) {
      Get.toNamed('/main');
    }
  }
}
