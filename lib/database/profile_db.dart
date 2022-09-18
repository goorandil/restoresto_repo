import 'package:get/get.dart';
import 'package:restoresto_repo/controllers/myaccount_controller.dart';

import '../controllers/profile_controller.dart';
import '../helper/firebase_auth_constants.dart';
import '../helper/global_var.dart';
import '../views/myaccount_page.dart';

class ProfileDb {
  static updateProfile(String value) async {
    if (value == '')
      await firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'userName': userBox.read('username'),
        'userPhone': userBox.read('userphone'),
        'userAddress': userBox.read('useraddress'),
        //  'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'iupdatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        //   'icreatedAt': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      }).whenComplete(() {
        MyaccountController.to.getUserData();
        Get.to(() => MyaccountPage());
      });
    else
      await firebaseFirestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .update({
        'userName': userBox.read('username'),
        'userPhone': userBox.read('userphone'),
        'userAddress': userBox.read('useraddress'),
        'userImageurl': value,
      }).whenComplete(() {
        ProfileController.to.imageFile = null;
        print('addNewTopup whenComplete userid ${userBox.read('userid')}');
        MyaccountController.to.getUserData();
        Get.to(() => MyaccountPage());
      });
  }
}
