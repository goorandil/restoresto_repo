import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../database/login_db.dart';
import '../helper/firebase_auth_constants.dart';
import '../helper/global_var.dart';
import '../views/login_page.dart';

class LoginController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  var myList = [].obs;
  var myNumber = 0.obs;
  var loginDenganGoogle = 'Login dengan Google'.obs;

  final String tag = 'LoginController ';
  @override
  Future<void> onInit() async {
    super.onInit();
    Get.put(GlobalVar());
  }

  Future<String?> loginWithGoogle() async {
    print('$tag login');
    try {
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
      print('$tag user $user');
      assert(!user!.isAnonymous);
      assert(await user?.getIdToken() != null);
      assert(user!.uid == currentUser!.uid);
      assert(user?.email != null);
      assert(user?.displayName != null);
      assert(user?.photoURL != null);

      LoginDb.getUserdata();
      // Get.to(() => MainPage());
    } catch (e) {
      // ignore: avoid_print
      print('$tag catch loginWithGoogle $e');
    }
    return null;
  }

  Future<void> logoutGoogle() async {
    print('logoutGoogle');
    print('logoutGoogle ${FirebaseAuth.instance.signOut()}');

    //await googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    SystemNavigator.pop();
    // navigate to your wanted page after logout.
  }
}
