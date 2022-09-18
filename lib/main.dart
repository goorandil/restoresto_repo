import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restoresto_repo/database/main_db.dart';
import 'package:restoresto_repo/views/main_page.dart';

import 'firebase_options.dart';
import 'helper/firebase_auth_constants.dart';
import 'helper/global_var.dart';
import 'helper/languages.dart';
import 'utils/dynamic_link_service.dart';

final Future<FirebaseApp> _initialization = Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

String tag = 'main.dart ';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();

  DynamicLinkService.initDynamicLinks();

  firebaseAuth.authStateChanges().listen((User? user) async {
    if (user == null) {
      //  await firebaseAuth.signInAnonymously();
// for new user or new inatall after unisntall
// signin anonimus
      try {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        user = userCredential.user;
        // cek user
        MainDb.checkUser(user!.uid);

        print("Signed in with temporary account.");
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "operation-not-allowed":
            print("Anonymous auth hasn't been enabled for this project.");
            break;
          default:
            print("Unknown error.");
        }
      }
    } else {
      print('User is signed in!');
      print(user.uid);
      print('User is signed ${user.uid}');
      print('User is signed ${user.email}');
      // kalau user udah ada, lansung cek resto
      MainDb.getResto(user.uid);
    }
  });

  Get.put(GlobalVar());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          //    return MyAwesomeApp();

          return GetMaterialApp(
            title: 'Resto Resto',
            debugShowCheckedModeBanner: false,
            translations: Languages(),
            locale: Get.deviceLocale,
            fallbackLocale: const Locale('en', 'US'),
            theme: ThemeData(
              primaryColor: const Color(0xFFFFFFFF),
              primaryColorDark: const Color(0xFFFFFFFF),
              colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal)
                  .copyWith(secondary: const Color(0xFFFFFFFF)),
            ),
            home: MainPage(),
          );
          //  LoginPage(title: 'Contreng! Kampus'),
          //  );
        } else {
          // Otherwise, show something whilst waiting for initialization to complete
          return const Center(
              child: SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(child: CircularProgressIndicator())));
        }
      },
    );
  }
}