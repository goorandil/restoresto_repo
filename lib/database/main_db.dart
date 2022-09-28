import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:restoresto_repo/controllers/main_controller.dart';

import '../helper/firebase_auth_constants.dart';
import '../helper/global_var.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

class MainDb {
  static getMenu(String categoryid) {
    print('getMenu categoryid $categoryid');
    print('getMenu ${userBox.read('merchantid')}');
    print('getMenu ${MainController.to.restoidx.value}');

    if (categoryid == '') {
      return firebaseFirestore
          .collection("restos")
          .doc(MainController.to.restoidx.value)
          .collection('menu')
          .snapshots();
    } else {
      return firebaseFirestore
          .collection("restos")
          .doc(MainController.to.restoidx.value)
          .collection('menu')
          .where('categoryID', isEqualTo: categoryid)
          .snapshots();
    }
  }

  static Future<Widget> checkUid() async => firebaseFirestore
          .collection("restos")
          .doc('${MainController.to.restoidx.value}')
          .get()
          .then((value) {
        if (value.exists) {
          print('checkUid value.exists');
          userBox.write('restoid', '${MainController.to.restoidx.value}');
          userBox.write('merchantid', value.data()!['merchantID']);
          print('restoid ada ${userBox.read('restoid')}');
          print('uid ada ${firebaseAuth.currentUser!.uid}');

          userBox.write('restoname', value.data()!['restoName']);
          userBox.write('restoaddress', value.data()!['restoAddress']);
          return Row(children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network('${value.data()!['restoImageurl']}',
                    width: 50.0,
                    fit: BoxFit.fitWidth, loadingBuilder: (BuildContext context,
                        Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                })),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  '${value.data()!['restoName']}',
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ),
                Expanded(
                    flex: 1,
                    child: Text(
                      '${value.data()!['restoAddress']}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ))
              ],
            ))
          ]);
        } else {
          print('restoid addNewUser');
          //     addNewUser();
          return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Restaurant not selected'.tr,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )
              ]);
        }
      });

  static updateUidResto(String? restoid, String? merchantidx) async {
    print('updateUidResto $restoid');
    print('updateUidResto $merchantidx');
    print('updateUidResto ${firebaseAuth.currentUser!.uid}');
    return firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .update({
      'restoID': restoid,
      'merchantID': merchantidx,
      'updatedAt': DateTime.now(),
      'iupdatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      //   'icreatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    });
  }

  static updateMyResto(String? restoid, String? merchantidx) {
    print('updateMyResto $restoid');
    print('updateMyResto $merchantidx');
    print('updateMyResto ${firebaseAuth.currentUser!.uid}');
    return firebaseFirestore
        .collection("myrestos")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("myresto")
        .doc(restoid)
        .set({
      'restoID': restoid,
      'merchantID': merchantidx,
      'updatedAt': DateTime.now(),
      'iupdatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      //   'icreatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    });
  }

  static void checkUser(String uid) {
    print('checkUser $uid');
    var data = {
      'updatedAt': DateTime.now(),
      'iupdatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'createdAt': DateTime.now(),
      'icreatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };
// apakah uid sudah dibuatkan di collection users
// kalau belum dibuat dulu
// abis itu cek apakah udah punya resto
    firebaseFirestore
        .collection("users")
        .doc('${firebaseAuth.currentUser!.uid}')
        .get()
        .then((value) {
      if (!value.exists) {
        firebaseFirestore
            .collection("users")
            .doc('${firebaseAuth.currentUser!.uid}')
            .set(data)
            .then((value) =>
                {MainDb.getResto('${firebaseAuth.currentUser!.uid}')});
      }
    });
  }

  static void migrateMenu() {
    firebaseFirestore
        .collection(
            "/menus/CoXBb4XppBqyVkXlMsO3/resto/JV5IT3If9HBTfQ3mWepI/menu")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        firebaseFirestore
            .collection('restos')
            .doc('JV5IT3If9HBTfQ3mWepI')
            .collection('menu')
            .doc(element.id)
            .set({
          'menuName': element.data()['menuName'],
          'menuDescription': element.data()['menuDescription'],
          'menuPrice': element.data()['menuPrice'],
          'menuImageurl': element.data()['menuImageurl'],
          'menuStatus': true,
          'menuCategory': element.data()['menuCategory'],
          'categoryID': element.data()['categoryID'],
          'merchantID': userBox.read('merchantid'),
          'restoID': userBox.read('restoid'),
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          'iupdatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
          'icreatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        });
      });
    });
  }

  static void migrateCat() {
    firebaseFirestore
        .collection(
            "/categories/CoXBb4XppBqyVkXlMsO3/resto/JV5IT3If9HBTfQ3mWepI/category")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        firebaseFirestore
            .collection('categories')
            .doc('JV5IT3If9HBTfQ3mWepI')
            .collection('category')
            .doc(element.id)
            .set({
          'categoryName': element.data()['categoryName'],
          'restoID': element.data()['restoID'],
          'merchantID': element.data()['merchantID'],
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
          'iupdatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
          'icreatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        });
      });
    });
  }

  static void migrateResto() {
    firebaseFirestore.collection('restos').doc('JV5IT3If9HBTfQ3mWepI').set({
      'merchantID': 'CoXBb4XppBqyVkXlMsO3',
      'restoName': 'makan enakk',
      'restoPhone': '08564545666',
      'restoAddress': 'Jl cemara bandung',
      'restoImageurl':
          'https://firebasestorage.googleapis.com/v0/b/restaurant-menu-244ab.appspot.com/o/restoImageurl%2Fimage_cropper_1660392500339.png?alt=media&token=bc888b38-8cb9-4834-80f2-96eeea67f52e',
    });
  }

  static void getResto(String uid) {
    firebaseFirestore.collection('users').doc(uid).get().then((value) {
      if (value.exists) {
        if (value.data().toString().contains('restoID')) {
          MainController.to.restoidx.value = value.data()!['restoID'];
          print('1 getResto restoidx ${value.data()!['restoID']}');
          MainDb.getCat(value.data()!['restoID']);
        } else {
          MainController.to.restoidx.value =
              value.data()!['restoID'].toString();
          print('2 getResto restoidx ${value.data()!['restoID']}');
        }
      } else {
        MainController.to.restoidx.value = 'null';
        print('3 getResto restoidx empty');
      }
    });
  }

  static void getCat(String restoid) {
    Map<String, dynamic> someMap;
    print('getCat restoid $restoid');
    MainController.to.list.clear();
    firebaseFirestore
        .collection("categories")
        .doc(restoid)
        .collection('category')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        someMap = {
          'categoryName': '${element.get('categoryName')}',
          'categoryID': '${element.id}',
        };
        MainController.to.list.add(someMap);
        print('getCat  someMap $someMap');
      });
    });
    print('getCat ${MainController.to.list}');
  }

  static void checkEmailUser(String uid) {
    print('checkEmailUser $uid');
    var data = {
      'updatedAt': DateTime.now(),
      'iupdatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'createdAt': DateTime.now(),
      'icreatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };

    firebaseFirestore.collection("users").doc('$uid').get().then((value) {
      // cek apakah uid di collection user ada kah

      if (value.exists) {
        print('checkEmailUser uid ada $uid');
        print(
            'checkEmailUser value.exists ${value.data().toString().contains('userEmail')}');

        // apakah uid di usrs udah punya email
        if (value.data().toString().contains('userEmail')) {
          // kalau udah set status true
          MainController.to.emailstatusx.value = true;
          print(
              'checkEmailUser ada email ${MainController.to.emailstatusx.value}');
        } else {
          // kalau belum set false
          MainController.to.emailstatusx.value = false;
          print('checkEmailUser else ${MainController.to.emailstatusx.value}');
        }
      } else {
        // ini mah uid belum ada di collection user

        print('checkEmailUser uid gak ada $uid');
        checkUser('$uid');
        MainController.to.emailstatusx.value = false;
      }
    });
  }

  static void checkEmailUser2(String uid) {
    print('checkEmailUser2 restoid ${userBox.read('restoid')}');
    var data = {
      'updatedAt': DateTime.now(),
      'iupdatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'createdAt': DateTime.now(),
      'icreatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    };

    firebaseFirestore.collection("users").doc('$uid').get().then((value) {
      if (value.exists) {
        print('checkEmailUser2 uid ada $uid');
        if (value.data().toString().contains('userEmail')) {
          // set jadi true karena ada email di uid
          print('checkEmailUser2 ada email $uid');
          MainController.to.emailstatusx.value = true;
        } else {
          // belum ada email set jadi false
          // status ini digunakan untuk tombol login
          print('checkEmailUser2 ngak ada email $uid');
          MainController.to.emailstatusx.value = false;
          // ke halaman login google
          MainController.to.signinWithGoogle();
        }
      } else {
        print('checkEmailUser2 uid ngak ada $uid');
        MainController.to.emailstatusx.value = false;
        MainController.to.signinWithGoogle();
        //   Get.snackbar(
        //     "checkEmailUser", "ngak eksis ${firebaseAuth.currentUser!.uid}",
        //   backgroundColor: Colors.red, colorText: Colors.white);
      }
    });
  }

  static void updateUserEmail(UserCredential user) {
    print('updateUserEmail uid ${user.user!.uid}');
    print('updateUserEmail email ${user.user!.email}');
    print('updateUserEmail displayName ${user.user!.displayName}');
    print('updateUserEmail photoURL ${user.user!.photoURL}');
    print('updateUserEmail restoid ${userBox.read('restoid')}');

    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token) {
      print("token is $token");
      var data;
      if (userBox.read('restoid') != '') {
        data = {
          'userEmail': user.user!.email,
          'userImageurl': '',
          'userName': '',
          'userPhone': '',
          'userAddress': '',
          'restoID': userBox.read('restoid'),
          'merchantID': userBox.read('merchantid'),
          'fcmToken': token
        };
      } else {
        data = {
          'userEmail': user.user!.email,
          'userImageurl': '',
          'userName': '',
          'userPhone': '',
          'userAddress': '',
          'fcmToken': token
        };
      }
      firebaseFirestore.collection('users').doc(user.user!.uid).update(data);
      MainController.to.emailstatusx.value = true;
    });
  }

/*
  static Future<void> addNewUser() async {
    firebaseMessaging.getToken().then((fcmtoken) {
      userBox.write('fcmtoken', fcmtoken);
      userBox.write('uid', firebaseAuth.currentUser?.uid);

      firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser?.uid)
          .set({
        'userName': firebaseAuth.currentUser?.displayName,
        'userEmail': firebaseAuth.currentUser?.email,
        'userImageurl': firebaseAuth.currentUser?.photoURL,
        'uid': firebaseAuth.currentUser?.uid,
        'fcmToken': fcmtoken,
        'createdAt': DateTime.now(),
        'icreatedAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now(),
        'iupdatedAt': DateTime.now().millisecondsSinceEpoch,
        'isDone': false,
        'app': 'resto resto',
        'userCat': 'user',
        'userAddress': '',
        'merchantID': '',
        'restoID': '',
      });
    });
  }
*/
}
