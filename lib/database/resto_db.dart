import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:restoresto_repo/controllers/main_controller.dart';

import '../helper/firebase_auth_constants.dart';
import '../helper/global_var.dart';
import '../views/main_page.dart';
import '../views/resto_page.dart';

final String tag = 'RestoDb ';

class RestoDb {
/*  static Future<String> checkResto() async => firebaseFirestore
          .collection("merchants")
          .doc(userBox.read('merchantid'))
          .get()
          .then((value) {
        if (value.exists) {
          if (value.data()!['restoID'] == null) {
            return 'false';
          } else if (value.data()!['restoID'] == '') {
            return 'false';
          } else {
            return '${value.data()!['restoName']}';
          }
        } else {
          return "Loading...";
        }
      });
*/
  static takeResto() async {
    print('takeResto restoid ${userBox.read('editrestoid')}');
    print('takeResto merchantid ${userBox.read('editmerchantid')}');

    if ('${userBox.read('editrestoid')}' != '${userBox.read('restoid')}') {
      shopcartList.clear();
      //  MainController.to.numshopcart.value = 0;
    }
    userBox.write('restoid', '${userBox.read('editrestoid')}');
    userBox.write('merchantid', '${userBox.read('editmerchantid')}');
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'merchantID': userBox.read("editmerchantid"),
    });
    GlobalVar.to.merchantidx.value = userBox.read("editmerchantid");
    Get.to(() => MainPage());
  }

  static takeMymerchant() async {
    print('$tag takeMymerchant ');

    if ('${userBox.read('editmerchantid')}' !=
        '${GlobalVar.to.merchantidx.value}') {
      shopcartList.clear();
      //  MainController.to.numshopcart.value = 0;
    }
    GlobalVar.to.merchantidx.value = '${userBox.read('editmerchantid')}';
    userBox.write('merchantid', '${userBox.read('editmerchantid')}');
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'merchantID': GlobalVar.to.merchantidx.value,
    });
    print('$tag merchantidx ${GlobalVar.to.merchantidx.value}');
    print('$tag merchantnamex ${GlobalVar.to.merchantnamex.value}');
    print('$tag merchantaddressx ${GlobalVar.to.merchantaddressx.value}');
    print('$tag merchantimageurlx ${GlobalVar.to.merchantimageurlx.value}');

    Get.toNamed('/main');
  }

  static addNewResto(String value) async {
    String? imageurl;
    if (userBox.read('restoimageurl') == null) {
      imageurl = firebaseAuth.currentUser!.photoURL;
    } else {
      imageurl = userBox.read('restoimageurl');
    }
/*    await firebaseFirestore
        .collection('restos')
        .doc(userBox.read('merchantid'))
        .collection('resto')
        .add({
      'merchantID': userBox.read('merchantid'),
      'restoName': userBox.read('restoname'),
      'restoPhone': userBox.read('restophone'),
      'restoAddress': userBox.read('restoaddress'),
      'restoImageurl': value,
    });
 */
  }

  static getMymerchant() {
    print('$tag getMymerchant');
    return firebaseFirestore
        .collection("mymerchants")
        .doc(firebaseAuth.currentUser!.uid)
        .collection('mymerchant')
        .snapshots();
  }

  static deleteMymerchant(String merchantid) async {
    print('deleteMymerchant ${merchantid}');

    if (GlobalVar.to.merchantidx.value == merchantid) {
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .update({'merchantID': FieldValue.delete()});

      GlobalVar.to.categorylistx.clear();
    }
    firebaseFirestore
        .collection('mymerchants')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('mymerchant')
        .doc(merchantid)
        .delete();
    Get.back();
    GlobalVar.to.merchantidx.value = '';
    GlobalVar.to.merchantfcmtokenx.value = '';
    Get.toNamed('/resto');
  }
}
