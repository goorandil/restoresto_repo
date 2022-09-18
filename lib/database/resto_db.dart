import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:restoresto_repo/controllers/main_controller.dart';

import '../helper/firebase_auth_constants.dart';
import '../helper/global_var.dart';
import '../views/main_page.dart';
import '../views/resto_page.dart';

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
      MainController.to.numshopcart.value = 0;
    }
    userBox.write('restoid', '${userBox.read('editrestoid')}');
    userBox.write('merchantid', '${userBox.read('editmerchantid')}');
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'restoID': userBox.read("editrestoid"),
      'merchantID': userBox.read("editmerchantid"),
    });
    Get.to(() => MainPage());
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

  static getResto() {
    print('getResto ${firebaseAuth.currentUser!.uid}');
    print('getResto ${GlobalVar.to.restoidx.value}');
    return firebaseFirestore
        .collection("myrestos")
        .doc(firebaseAuth.currentUser!.uid)
        .collection('myresto')
        .snapshots();
  }

  static deleteResto(String restoid) async {
    print('deleteResto ${firebaseAuth.currentUser!.uid}');
    print('deleteResto ${GlobalVar.to.restoidx.value}');
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'restoID': FieldValue.delete(),
      'merchantID': FieldValue.delete()
    });

    firebaseFirestore
        .collection('myrestos')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('myresto')
        .doc(restoid)
        .delete();
    Get.back();
    Get.to(() => RestoPage());
  }
}
