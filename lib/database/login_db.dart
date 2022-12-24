import 'package:get/get.dart';
import 'package:restoresto_repo/views/main_page.dart';

import '../helper/firebase_auth_constants.dart';
import '../helper/global_var.dart';

class LoginDb {
  static getUserdata() async {
    print('getUserdata ');

    await firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      if (!value.exists) {
        addNewUser();
      } else {
        firebaseMessaging.getToken().then((fcmtoken) {
          userBox.write('userid', value.id);
          userBox.write('fcmtoken', value.get('fcmToken'));
          userBox.write('username', value.get('userName'));
          userBox.write('useremail', value.get('userEmail'));
          userBox.write('userimageurl', value.get('userImageurl'));
          userBox.write('uid', value.id);
        }).then((value) => Get.to(() => MainPage()));
      }
    });
  }

  static Future<void> addNewUser() async {
    firebaseMessaging.getToken().then((fcmtoken) {
      userBox.write('fcmtoken', fcmtoken);
      userBox.write('username', firebaseAuth.currentUser?.displayName);
      userBox.write('useremail', firebaseAuth.currentUser?.email);
      userBox.write('userimageurl', firebaseAuth.currentUser?.photoURL);
      userBox.write('uid', firebaseAuth.currentUser?.uid);

      firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
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
        'app': 'restonomous',
        'userAddress': '',
        'userPhone': '',
        'userBalance': '',
      });
    }).whenComplete(() => Get.toNamed('main'));
  }

  static Future<void> addNewWaiter() async {
    firebaseMessaging.getToken().then((fcmtoken) {
      userBox.write('fcmtoken', fcmtoken);
      userBox.write('waitersname', firebaseAuth.currentUser?.displayName);
      userBox.write('waitersemail', firebaseAuth.currentUser?.email);
      userBox.write('waitersimageurl', firebaseAuth.currentUser?.photoURL);
      userBox.write('waitersuid', firebaseAuth.currentUser?.uid);

      firebaseFirestore.collection('waiters').add({
        'waitersName': firebaseAuth.currentUser?.displayName,
        'waitersEmail': firebaseAuth.currentUser?.email,
        'waitersImageurl': firebaseAuth.currentUser?.photoURL,
        'waitersuid': firebaseAuth.currentUser?.uid,
        'fcmToken': fcmtoken,
        'createdAt': DateTime.now(),
        'icreatedAt': DateTime.now().millisecondsSinceEpoch,
        'updatedAt': DateTime.now(),
        'iupdatedAt': DateTime.now().millisecondsSinceEpoch,
        'isDone': false,
        'app': 'resto resto waiter',
        'userCat': 'waiter',
        'waiterAddress': '',
        'waiterPhone': '',
      }).then((value) {
        userBox.write('waitersid', value.id);
      });
    });
  }
}
