import 'package:camera/camera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:restoresto_repo/database/main_db.dart';
import 'package:restoresto_repo/views/login_page.dart';
import 'package:restoresto_repo/views/main_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'binding/main_binding.dart';
import 'firebase_options.dart';
import 'helper/firebase_auth_constants.dart';
import 'helper/global_var.dart';
import 'helper/languages.dart';
import 'routes/app_pages.dart';
import 'utils/dynamic_link_service.dart';

final Future<FirebaseApp> _initialization = Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
late Widget firstWidget;
String tag = 'main.dart ';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'restoresto_repo',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();

  DynamicLinkService.initDynamicLinks();

/*
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
  
    }
  });
*/
  if (firebaseAuth.currentUser != null) {
    firstWidget = MainPage();
  } else {
    firstWidget = LoginPage();
  }
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
            initialBinding: MainBinding(),
            getPages: AppPages.pages,
            home: firstWidget,
            builder: EasyLoading.init(),
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
