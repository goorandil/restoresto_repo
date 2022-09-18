import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/date_symbol_data_custom.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:new_version/new_version.dart';
import 'package:restoresto_repo/helper/firebase_auth_constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../database/main_db.dart';
import '../helper/global_var.dart';
import '../utils/dynamic_link_service.dart';

class MainController extends GetxController {
  static MainController get to => Get.find<MainController>();
  late String userBalance;

  RxString logOut = 'Logout'.tr.obs;
  RxString deeplink = ''.obs;
  RxString restoidx = 'null'.obs;
  RxString ordertotal = '0'.obs;

  RxInt qty = 1.obs;
  RxInt numshopcart = 0.obs;
  RxString shareApp =
      'https://play.google.com/store/apps/details?id=com.bingkaiapp.restoresto'
          .obs;

  var uid;

  RxString categoryidx = ''.obs;
  RxString categorynamex = ''.obs;

  RxBool emailstatusx = false.obs;
  RxList list = [].obs;
  var userCredential;
  var tabIndex = 0;
  void changeTabIndex(int index) {
    tabIndex = index;
    update();
  }

  final saldo = NumberFormat.currency(
      locale: 'id_ID', customPattern: '#,###', symbol: 'Rp.', decimalDigits: 0);
  final newVersion = NewVersion(
    iOSId: 'com.bingkaiapp.restoresto',
    androidId: 'com.bingkaiapp.restoresto',
  );

  @override
  Future<void> onInit() async {
    super.onInit();
    list.clear();
    // cek apakah user uid nya udah punya email belum
    // karena anonimus
    checkAuth();
    Get.put(GlobalVar());
    getDeepLink();

    // MainDb.migrateCat();
    // MainDb.migrateMenu();
    // MainDb.migrateResto();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget getMenuList(AsyncSnapshot<QuerySnapshot<Object?>?> snapshot) {
    if (snapshot.hasData) {
      //   print('getMenuList ${snapshot.data!.docs.length}');
      return ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            return getDataMenu(snapshot, index);
          });
    } else {
      return const Center(
          child: SizedBox(
              width: 30,
              height: 30,
              child: Center(child: CircularProgressIndicator())));
    }
  }

  getNumShopcart() {
    int? numtot = 0;
    numtot = shopcartList.length;
    print('getNumShopcart length ${shopcartList.length}');
    numshopcart.value = numtot;
    update();
  }

  Widget getDataMenu(
      AsyncSnapshot<QuerySnapshot<Object?>?> snapshot, int index) {
    return InkWell(
        onTap: () {
          qty.value = 1;
          // inimah buat edit
          userBox.write('editmenuid', snapshot.data!.docs[index].id);
          userBox.write('editmenuname', snapshot.data!.docs[index]['menuName']);
          userBox.write('editmenudescription',
              snapshot.data!.docs[index]['menuDescription']);
          userBox.write(
              'editmenuprice', snapshot.data!.docs[index]['menuPrice']);
          userBox.write(
              'editmenuimageurl', snapshot.data!.docs[index]['menuImageurl']);
          userBox.write(
              'editmenustatus', snapshot.data!.docs[index]['menuStatus']);
          userBox.write(
              'editmenucategory', snapshot.data!.docs[index]['menuCategory']);
          userBox.write(
              'editmenucategoryid', snapshot.data!.docs[index]['categoryID']);

          //    selectedState.value = snapshot.data!.docs[index]['categoryID'];

          Get.defaultDialog(
            titlePadding: const EdgeInsets.all(15),
            contentPadding: const EdgeInsets.all(15),
            title: 'Put it in your tray'.tr,

            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${userBox.read('editmenuname')}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: GlobalVar.to.primaryText),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        '-',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: GlobalVar.to.primaryText),
                      ),
                      onPressed: () async {
                        qtyDecrease();
                      },
                    ),
                    Obx(() => Text(
                          '${qty.value}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    TextButton(
                      child: Text(
                        '+',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: GlobalVar.to.primaryText),
                      ),
                      onPressed: () async {
                        qtyIncrease();
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
                  style: TextStyle(color: GlobalVar.to.primaryText),
                ),
                onPressed: () async {
                  Get.back();
                },
              ),
              TextButton(
                child: Text(
                  'Add'.tr,
                  style: TextStyle(color: GlobalVar.to.primaryText),
                ),
                onPressed: () async {
                  addToCart();
                },
              ),
            ],
          );
        },
        child: Card(
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
                  child: snapshot.hasData
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                              '${snapshot.data!.docs[index]['menuImageurl']}',
                              width: 45.0,
                              fit: BoxFit.fitWidth, loadingBuilder:
                                  (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${snapshot.data!.docs[index]['menuName']}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
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
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${snapshot.data!.docs[index]['menuDescription']}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
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
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    // '${snapshot.data!.docs[index]['menuPrice']}',
                                    'Rp. ${saldo.format(int.parse(snapshot.data!.docs[index]['menuPrice'].toString()))}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
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
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '${snapshot.data!.docs[index]['menuCategory']}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
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
                                  alignment: Alignment.centerLeft,
                                  child:
                                      '${snapshot.data!.docs[index]['menuStatus']}' ==
                                              'true'
                                          ? Text(
                                              '',
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Text(
                                              'Out of stock'.tr,
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                ),
                              )
                            ],
                          ),
                        ])),
              ],
            ),
          ),
        ));
  }

  Future<void> getDeepLink() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;
    FirebaseDynamicLinks.instance.onLink;
    String? restoid;
    String? merchantidx;

    if (deepLink != null) {
      print('MainPage deepLink $deepLink');
      //   deeplink.value = '$deepLink';
      //  if (deepLink.queryParameters.containsKey('eventcode')) {
      restoid = deepLink.queryParameters['restoid'];
      merchantidx = deepLink.queryParameters['merchantid'];
      print('MainPage restoid $restoid');
      print('MainPage merchantidx $merchantidx');

      // restoidx.value = '$restoid';
      //   firebaseFirestore.collection('users').doc(userid).update({
      //  'eventCode': eventcode,
      //   });
      //   checkClassCode(eventcode);
      //}
    } else {
      print('MainPage deepLink null');
    }
  }

  void qtyIncrease() {
    print('qtyIncrease ${qty.value}');
    qty.value++;
  }

  void qtyDecrease() {
    print('qtyDecrease ${qty.value}');
    if (qty.value >= 2) qty.value--;
  }

  Future<void> addToCart() async {
    print('menuid ${userBox.read('editmenuid')}');
    print('menuname ${userBox.read('editmenuname')}');
    print('menudescription ${userBox.read('editmenudescription')}');
    print('menuprice ${userBox.read('editmenuprice')}');
    print('menuimageurl ${userBox.read('editmenuimageurl')}');
    print('menustatus ${userBox.read('editmenustatus')}');
    print('menucategory ${userBox.read('editmenucategory')}');
    print('menucategoryid ${userBox.read('editmenucategoryid')}');

    print('qty ${qty.value}');
    var sumtot = qty.value * int.parse(userBox.read('editmenuprice'));
    print('sumtot ${sumtot}');

    Map<String, dynamic> someMap = {
      'menuid': '${userBox.read('editmenuid')}',
      'menuname': '${userBox.read('editmenuname')}',
      'menudescription': '${userBox.read('editmenudescription')}',
      'menuprice': '${userBox.read('editmenuprice')}',
      'menuimageurl': '${userBox.read('editmenuimageurl')}',
      'menustatus': '${userBox.read('editmenustatus')}',
      'menucategory': '${userBox.read('editmenucategory')}',
      'menucategoryid': '${userBox.read('editmenucategoryid')}',
      'qty': '${qty.value}',
      'sumtot': '${sumtot}',
      'isumtot': sumtot,
    };

    shopcartList.add(someMap);

    await Future.delayed(
        const Duration(seconds: 1), () => print('User account created'));
    Get.back();
    getNumShopcart();
    print('shopcartList.length $shopcartList.length');
  }

  void setCat(String categoryname, String categoryid) {
    print('setCat categoryname $categoryname');
    print('setCat categoryid $categoryid');
    categoryidx.value = categoryid;
    categorynamex.value = categoryname;
  }

  void checkAuth() {
    print('checkAuth');
    firebaseAuth.authStateChanges().listen((User? user) async {
      // cek ulang apakah authnya udah ada
      // mestinya mah udah ada ya

      if (user == null) {
        print('checkAuth ==null');
      } else {
        // pengecekan apakah udah ada email belum
        // untiuk uid yg aktif
        MainDb.checkEmailUser(user.uid);
        print('checkAuth ${user.uid}');
        //   MainDb.getResto(user.uid);
      }
    });
  }

  void checkAuth2() {
    print('checkAuth2');
    print('checkAuth2 restoid ${userBox.read('restoid')}');
    firebaseAuth.authStateChanges().listen((User? user) async {
      if (user == null) {
        print('checkAuth2 ==null');
        //    Get.snackbar("Error", "checkAuth ==null", backgroundColor: Colors.red);
      } else {
        //  Get.snackbar("Error", "checkAuth ", backgroundColor: Colors.red);
        MainDb.checkEmailUser2(user.uid);
        print('checkAuth2 ${user.uid}');
        //   MainDb.getResto(user.uid);
      }
    });
  }

  Future<String?> signinWithGoogle() async {
    print('signinWithGoogle');
    print('signinWithGoogle restoid ${userBox.read('restoid')}');

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    try {
      // kalau ngak eror akan kesini
      // kondisi uid ada di collection dan belum ada email
      // dan email yg dimasukin juga belum pernah login

      print('signinWithGoogle try');

      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);

      MainDb.updateUserEmail(userCredential!);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          print("The provider has already been linked to the user.");
          // kalau login email ternyata udah ada konek ke uid nya
          // set status nya true
          MainDb.updateUserEmail(userCredential);

          MainController.to.emailstatusx.value = true;
          break;
        case "invalid-credential":
          print("The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          // ini kondisi uid yg belum punya email, dan user
          // login menggunakan email yg udah pernah login
          print("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");

          // login dengan pilihan email
          // maka auth akan pindah ke uid yg ada emailnya
          final userCredentialx =
              await firebaseAuth.signInWithCredential(credential);

          MainDb.updateUserEmail(userCredentialx);
          break;
        // See the API reference for the full list of error codes.
        default:
          print("Unknown error.");
      }
      /*  try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final authResult = await firebaseAuth.signInWithCredential(credential);

      final User? user = authResult.user;
      final User? currentUser = firebaseAuth.currentUser;
      print('user $user');
      assert(!user!.isAnonymous);
      assert(await user?.getIdToken() != null);
      assert(user!.uid == currentUser!.uid);
      assert(user?.email != null);
      assert(user?.displayName != null);
      assert(user?.photoURL != null);

      //   MainDb.getUserdata(firebaseAuth.currentUser!.email);

      //   Get.to(() => MainPage());
    } catch (e) {
      // ignore: avoid_print
      print('catch loginWithGoogle $e');
    }
    return null;
  }*/
    }
    return null;
  }

  Future<void> logoutGoogle() async {
    print('logoutGoogle');
    print('logoutGoogle ${FirebaseAuth.instance.signOut()}');

    //  await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    SystemNavigator.pop();

    // navigate to your wanted page after logout.
  }
}
