import 'package:get/get.dart';
import 'package:restoresto_repo/controllers/main_controller.dart';
import 'package:restoresto_repo/controllers/myaccount_controller.dart';

import '../controllers/profile_controller.dart';
import '../helper/firebase_auth_constants.dart';
import '../helper/global_var.dart';
import '../views/main_page.dart';
import '../views/myaccount_page.dart';

class CheckoutDb {
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
        //   MyaccountController.to.getUserData();
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
        //  ProfileController.to.imageFile = null;
        print('addNewTopup whenComplete userid ${userBox.read('userid')}');
        //MyaccountController.to.getUserData();
        Get.to(() => MyaccountPage());
      });
  }

  static void updateOrder() {
    print('updateOrder ordertotal ${userBox.read('ordertotal')}');
    print('updateOrder sumtotstr ${userBox.read('sumtotstr')}');
    print('updateOrder ordername ${userBox.read('username')}');
    print('updateOrder tablenumber ${userBox.read('tablenumber')}');
    print('updateOrder restoid ${userBox.read('restoid')}');
    print('updateOrder merchantid ${userBox.read('merchantid')}');

    print('updateOrder userid ${userBox.read('userid')}');
    print('updateOrder username ${userBox.read('username')}');

    var datex = DateTime.now();
    var idatex = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    var orderData = {
      'historyStatus': false,
      'userID': userBox.read('userid'),
      'userName': userBox.read('username'),
      'orderTotal': userBox.read('ordertotal'),
      'sumtotStr': userBox.read('sumtotstr'),
      'tableNumber': userBox.read('tablenumber'),
      'restoID': userBox.read('restoid'),
      'merchantID': GlobalVar.to.merchantidx.value,
      'orderStatus': 'Proses',
      'createdAt': datex,
      'updatedAt': datex,
      'iupdatedAt': idatex,
      'icreatedAt': idatex,
    };

// order admin
    firebaseFirestore
        .collection('orders')
        .doc('${GlobalVar.to.merchantidx.value}')
        .collection('order')
        .add(orderData)
        .then((value) {
      // myorder
      firebaseFirestore
          .collection('myorders')
          .doc("${firebaseAuth.currentUser!.uid}")
          .collection('merchantid')
          .doc('${GlobalVar.to.merchantidx.value}')
          .collection('myorder')
          .doc(value.id)
          .set(orderData);
      int packageIdx = 0;
      shopcartList.forEach((element) {
        print('placeOrder $element');
        packageIdx = packageIdx + 1;

        var orderdetailData = {
          'itemID': packageIdx,
          'orderID': value.id,
          'userID': userBox.read('userid'),
          'userName': userBox.read('username'),
          'userEmail': userBox.read('useremail'),
          'menuID': element['menuid'],
          'menuName': element['menuname'],
          'menuDescription': element['menudescription'],
          'menuPrice': element['menuprice'],
          'menuImageurl': element['menuimageurl'],
          'menuStatus': element['menustatus'],
          'menuCategoryName': element['menucategoryname'],
          'menuCategoryid': element['menucategoryid'],
          'qty': element['qty'],
          'sumtot': element['sumtot'],
          'isumtot': element['isumtot'],
          'createdAt': datex,
          'updatedAt': datex,
          'iupdatedAt': idatex,
          'icreatedAt': idatex,
        };
        firebaseFirestore
            .collection('orderdetails')
            .doc('${GlobalVar.to.merchantidx.value}')
            .collection('orderid')
            .doc(value.id)
            .collection('orderdetail')
            .add(orderdetailData)
            .then((valuex) {
          firebaseFirestore
              .collection('myorders')
              .doc("${firebaseAuth.currentUser!.uid}")
              .collection('merchantid')
              .doc('${GlobalVar.to.merchantidx.value}')
              .collection('myorder')
              .doc(value.id)
              .collection('myorderdetail')
              .doc(valuex.id)
              .set(orderdetailData)
              .whenComplete(() {
            print('shopcartList $shopcartList');
            print('restoid ada ${userBox.read('restoid')}');
            shopcartList.clear();
            //    MainController.to.numshopcart.value = 0;
            print('shopcartList $shopcartList');
            print('restoid ada ${userBox.read('restoid')}');
          });
        });
      });
    });
  }
}
