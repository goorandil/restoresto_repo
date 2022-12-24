import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../database/login_db.dart';
import 'firebase_auth_constants.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
String? name;
String? email;
String? imageUrl;
String? uid;

Future<String?> signInWithGoogle() async {
  debugPrint('signInWithGoogle');
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
    debugPrint('signInWithGoogle user $user');
    assert(!user!.isAnonymous);
    assert(await user?.getIdToken() != null);
    assert(user!.uid == currentUser!.uid);
    assert(user?.email != null);
    assert(user?.displayName != null);
    assert(user?.photoURL != null);
    LoginDb.getUserdata();

    //  Get.to(() => MainPage());
  } catch (e) {
    // ignore: avoid_print
    debugPrint('signInWithGoogle catch loginWithGoogle $e');
  }
  return null;
}

Future<void> signOutGoogle() async {
  await googleSignIn.disconnect();
  await googleSignIn.signOut();
  await fauth().signOut();
  SystemNavigator.pop();
  debugPrint("signIn signOutGoogle ");
  debugPrint("signIn User Signed Out");
}

fauth() {
  debugPrint("signIn fauth $firebaseAuth");

  return firebaseAuth;
}
