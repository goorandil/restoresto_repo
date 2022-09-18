import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:restoresto_repo/controllers/main_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/profile_db.dart';
import '../helper/firebase_auth_constants.dart';
import '../helper/global_var.dart';

class MyaccountController extends GetxController {
  static MyaccountController get to => Get.find<MyaccountController>();

  RxString pageTitle = 'Akun Saya'.obs;
  RxString appVersion = ''.obs;
  RxString shareApp =
      'https://play.google.com/store/apps/details?id=com.bingkaiapp.restoresto'
          .obs;
  @override
  void onInit() {
    getUserData();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;
      appVersion.value = version;
    });

    super.onInit();
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $url';
    }
  }

  launchURLtoc() async {
    Uri url = Uri(
        scheme: 'https',
        host: 'bingkai-media-2018.web.app',
        path: 'resto_toc.html');
    _launchInBrowser(url);
    if (await canLaunchUrl(url)) {
      await canLaunchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchURLpriv() async {
    Uri url = Uri(
        scheme: 'https',
        host: 'bingkai-media-2018.web.app',
        path: 'resto_privacy_policy.html');
    _launchInBrowser(url);
    if (await canLaunchUrl(url)) {
      await canLaunchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  exitApp(BuildContext context) async {
    Get.defaultDialog(
      titlePadding: const EdgeInsets.all(15),
      contentPadding: const EdgeInsets.all(15),
      title: 'Do you want to exit this application?',
      content: const Text('We sad to see you leave...'),
      //  backgroundColor: Colors.teal,
      radius: 30,
      actions: <Widget>[
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: GlobalVar.to.primaryText),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: Text(
            'Exit',
            style: TextStyle(color: GlobalVar.to.primaryText),
          ),
          onPressed: () async {
            Get.back();
            MainController.to.logoutGoogle();
          },
        ),
      ],
    );
  }

  void getUserData() {
    firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .get()
        .then((value) {
      userBox.write('fcmtoken', value.get('fcmToken'));
      userBox.write('username', value.get('userName'));
      userBox.write('useremail', value.get('userEmail'));
      userBox.write('userimageurl', value.get('userImageurl'));
      userBox.write('useraddress', value.get('userAddress'));
      userBox.write('userphone', value.get('userPhone'));
      userBox.write('userid', value.id);

      print('email ${value.get('userEmail')}');
    });
  }

  Future<void> getVersionApp() async {
    final info = await PackageInfo.fromPlatform();
    String version = info.version;
    print(version);
  }
}