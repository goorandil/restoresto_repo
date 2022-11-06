import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:restoresto_repo/controllers/main_controller.dart';
import 'package:restoresto_repo/controllers/myaccount_controller.dart';
import 'package:restoresto_repo/views/main_page.dart';
import 'package:restoresto_repo/views/shopping_cart_page.dart';

import '../database/checkout_db.dart';
import '../database/profile_db.dart';
import '../helper/global_var.dart';
import '../views/myaccount_page.dart';

class CheckoutController extends GetxController {
  RxString pageTitle = 'Checkout'.tr.obs;

  RxString userid = ''.obs;

  RxString ordertotal = RxString('');
  RxString ordername = RxString('');
  RxString tablenumber = RxString('');

  TextEditingController ordertotalController = TextEditingController();
  TextEditingController ordernameController = TextEditingController();
  TextEditingController tablenumberController = TextEditingController();

  RxnString errorTextordertotal = RxnString(null);
  RxnString errorTextordername = RxnString(null);
  RxnString errorTexttablenumber = RxnString(null);

  Rxn<Function()> submitFunc = Rxn<Function()>(null);
  final saldo = NumberFormat.currency(
      locale: 'id_ID', customPattern: '#,###', symbol: 'Rp.', decimalDigits: 0);

  @override
  void onInit() {
    super.onInit();

    submitFunc.value = submitFunction();
    debounce<String>(tablenumber, validations,
        time: const Duration(milliseconds: 500));

    print('onInit email ${userBox.read('useremail')}');
    print('onInit username ${userBox.read('username')}');

    //  ordertotalController.text = '${userBox.read('ordertotal')}';
    ordertotalController.text =
        'Rp. ${saldo.format(int.parse(userBox.read('ordertotal').toString()))}';
    ordernameController.text = '${userBox.read('username')}';
    tablenumberController.text = '';
  }

  void validations(String val) async {
    errorTexttablenumber.value = null; // reset validation errors to nothing
    if (val.isNotEmpty) {
      if (lengthOK(val) && await available(val)) {
        print('All validations passed, enable submit btn...');
        submitFunc.value = submitFunction();
        errorTexttablenumber.value = null;
      } else {
        submitFunc.value = null;
      }
    }
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: GlobalVar.to.primary,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.off(() => ShoppingCartPage());
            },
          );
        },
      ),
      centerTitle: true,
      title: Text(pageTitle.value),
    );
  }

  bool lengthOK(String val, {int minLen = 1}) {
    if (val.length < minLen) {
      errorTexttablenumber.value = 'min. 1 chars';
      return false;
    }
    return true;
  }

  Future<bool> available(String val) async {
    print('Query availability of: $val');
    await Future.delayed(
        const Duration(seconds: 1), () => print('Available query returned'));

    if (val == "Sylvester") {
      errorTexttablenumber.value = 'Name Taken';
      return false;
    }
    return true;
  }

  void ordernameChanged(String val) {
    userBox.write('ordername', val);
    ordername.value = val;
  }

  void ordertotalChanged(String val) {
    userBox.write('ordertotal', val);
    ordertotal.value = val;
  }

  void tablenumberChanged(String val) {
    userBox.write('tablenumber', val);
    tablenumber.value = val;
  }

  Future<bool> Function() submitFunction() {
    return () async {
      //   DisplayAlertDialog.okButton('Notifikasi', 'Profil sudah diubah');
      await Future.delayed(const Duration(seconds: 1), () => showIndi());

      if (shopcartList.isNotEmpty) {
        CheckoutDb.updateOrder();
        Get.defaultDialog(
          titlePadding: const EdgeInsets.all(15),
          contentPadding: const EdgeInsets.all(15),
          title: 'Notification'.tr,
          content: Text(
              'Congratulations, we have received your order. We will process it immediately. Thank you'
                  .tr),
          //  backgroundColor: Colors.teal,
          radius: 30,
          barrierDismissible: false,
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Get.back();
                MainController.to.numshopcart.value = 0;
                Get.toNamed('/main');
              },
            ),
          ],
        );

        return true;
      } else {
        return false;
      }
    };
  }

  showIndi() {
    return SizedBox(
        width: 30,
        height: 30,
        child: Center(child: CircularProgressIndicator()));
  }
}
