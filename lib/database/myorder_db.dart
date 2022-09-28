import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:restoresto_repo/controllers/main_controller.dart';

import '../helper/firebase_auth_constants.dart';
import '../helper/global_var.dart';
import '../views/main_page.dart';
import '../views/resto_page.dart';

class MyorderDb {
  static getMyorder() {
    print('getMyorder ${firebaseAuth.currentUser!.uid}');
    print('getMyorder ${userBox.read('restoid')}');
    return firebaseFirestore
        .collection("myorders")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("restoid")
        .doc('${userBox.read('restoid')}')
        .collection('myorder')
        .where('historyStatus', isEqualTo: false)
        .snapshots();
  }

  static getMyorderhis() {
    print('getMyorderhis ${firebaseAuth.currentUser!.uid}');
    print('getMyorderhis ${userBox.read('restoid')}');
    return firebaseFirestore
        .collection("myorders")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("restoid")
        .doc('${userBox.read('restoid')}')
        .collection('myorder')
        .where('historyStatus', isEqualTo: true)
        .snapshots();
  }

  static getMyorderDetail() {
    print('getMyorderDetail edituserid ${userBox.read('edituserid')}');
    print('getMyorderDetail editusername ${userBox.read('editusername')}');
    print('getMyorderDetail editmyorderid ${userBox.read('editmyorderid')}');
    print('getMyorderDetail editordertotal ${userBox.read('editordertotal')}');
    print(
        'getMyorderDetail edittablenumber ${userBox.read('edittablenumber')}');
    print(
        'getMyorderDetail editorderstatus ${userBox.read('editorderstatus')}');

    return firebaseFirestore
        .collection('myorders')
        .doc(firebaseAuth.currentUser!.uid)
        .collection("restoid")
        .doc('${userBox.read('restoid')}')
        .collection('myorder')
        .doc('${userBox.read('editmyorderid')}')
        .collection('myorderdetail')
        .snapshots();
  }
}
