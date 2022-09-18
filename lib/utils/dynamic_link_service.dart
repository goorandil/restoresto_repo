import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restoresto_repo/controllers/main_controller.dart';

import '../database/main_db.dart';
import '../helper/firebase_auth_constants.dart';
import '../helper/global_var.dart';
import '../views/main_page.dart';

String? restoid;
String? merchantid;

class DynamicLinkService {
  static Future<void> initDynamicLinks() async {
    print('DynamicLinkPage initDynamicLinks ');
    await Future.delayed(Duration(seconds: 3));
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    dynamicLinks.onLink.listen((dynamicLinkData) {
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty) {
        print("Incoming Link :" + uri.toString());
        restoid = queryParams['restoid'];
        merchantid = queryParams['merchantid'];
        var fallback = queryParams['ofl'];
        print('DynamicLinkPage x initDynamicLinks restoid $restoid');
        print('DynamicLinkPage  initDynamicLinks merchantid $merchantid');
        print('DynamicLinkPage  initDynamicLinks fallback $fallback');

        GlobalVar eventdatax = Get.put(GlobalVar());
        MainDb.updateUidResto(restoid, merchantid);
        MainDb.updateMyResto(restoid, merchantid);
        MainController.to.restoidx.value = restoid!;
        MainController().update();

        eventdatax.eventcodex('$restoid');
        eventdatax.eventidx('$merchantid');

        if (_auth.currentUser != null) {
          print("DynamicLinkPage  onlink Current user");
          Get.to(() => MainPage());
        } else {
          print("DynamicLinkPage no onlink Current user");
        }
        //  your code here
      } else {
        print("DynamicLinkPage No Current Links");
        // your code here
      }
    });

    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      print('deepLink != null initDynamicLinks deeplink $deepLink');
      print('deepLink != null initDynamicLinks deeplinkpath ${deepLink.path}');
      final queryParams = deepLink.queryParameters;
      print('deepLink != null  initDynamicLinks data $data');
      print('deepLink != null  initDynamicLinks deepLink $deepLink');
      print('deepLink != null  initDynamicLinks queryParams $queryParams');
      if (queryParams.isNotEmpty) {
        var restoid = queryParams['restoid'];
        var merchantid = queryParams['merchantid'];
        var fallback = queryParams['ofl'];
        print('deepLink != null  initDynamicLinks restoid $restoid');
        print('deepLink != null  initDynamicLinks merchantid $merchantid');
        print('deepLink != null  initDynamicLinks fallback $fallback');

        GlobalVar eventdatax = Get.put(GlobalVar());

        eventdatax.eventcodex('$restoid');
        eventdatax.eventidx('$merchantid');

        MainDb.updateUidResto(restoid, merchantid);
        MainDb.updateMyResto(restoid, merchantid);
        MainDb.getCat(restoid!);
        MainController().update();
        if (_auth.currentUser != null) {
          print("DynamicLinkPage    Current user");
        } else {
          print("DynamicLinkPage  no   Current user");
        }
      }

      //   Get.to(() => MainteacherPage());
    } else {
      print('DynamicLinkPage initDynamicLinks deeplink null');
    }
  }

  Widget getRoute(deepLink) {
    print('MainTeacherPage initDynamicLinks  getRoute');
    if (deepLink.toString().isEmpty) {
      return MainPage();
    }
    if (deepLink.path == "/resto") {
      final restoid = deepLink.queryParameters["restoid"];
      print('MainTeacherPage initDynamicLinks  eventid $restoid');
      if (restoid != null) {
        return MainPage();
      }
    }
    return MainPage();
  }

  static Future<void> retrieveDynamicLink(
      BuildContext context, String? userid) async {
    print('MainTeacherPage retrieveDynamicLink ');
    try {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri? deepLink = data?.link;
      FirebaseDynamicLinks.instance.onLink;
      String? eventcode;
      if (deepLink != null) {
        print('MainTeacherPage deepLink $deepLink');
        //  if (deepLink.queryParameters.containsKey('eventcode')) {
        restoid = deepLink.queryParameters['restoid'];
        merchantid = deepLink.queryParameters['merchantid'];
        userid = deepLink.queryParameters['userid'];
        print('MainTeacherPage eventcode $restoid');
        //   firebaseFirestore.collection('users').doc(userid).update({
        //  'eventCode': eventcode,
        //   });
        //   checkClassCode(eventcode);
        //}
      } else {
        print('MainTeacherPage deepLink null');
      }
      GlobalVar eventdatax = Get.put(GlobalVar());

      eventdatax.getdeeplinkx('$deepLink');
      eventdatax.getungueslinkx('$eventcode');
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<String?> createDynamicLink(
      String restoid, String merchantid) async {
    print('MainteacherPage createDynamicLink restoid $restoid');
    print('MainteacherPage createDynamicLink merchantid $merchantid');

    final dynamicLinkParams = DynamicLinkParameters(
      // link: Uri.parse("https://contreng.web.app/#/"),
      link: Uri.parse(
          'https://restoresto.page.link/resto/?restoid=$restoid&merchantid=$merchantid&ofl=https://restoresto.web.app'),
      uriPrefix: "https://restoresto.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.bingkaiapp.restoresto",
        minimumVersion: 30,
      ),
      iosParameters:
          const IOSParameters(bundleId: "com.bingkaiapp.restoresto.ios"),
      googleAnalyticsParameters: const GoogleAnalyticsParameters(
        source: "twitter",
        medium: "social",
        campaign: "example-promo",
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "Resto Resto",
        imageUrl: Uri.parse(
            "https://www.google.com/imgres?imgurl=https%3A%2F%2Fplay-lh.googleusercontent.com%2F6-AwzHJ5Uy3GkIYHR5ro0YDmLLiRzFsjpLxIVdqcjc4nE78g4QCt9p03eXsWQkezBw%3Dw240-h480-rw&imgrefurl=https%3A%2F%2Fplay.google.com%2Fstore%2Fapps%2Fdetails%3Fid%3Dcom.bingkaiapp.present%26hl%3Dis%26gl%3DUS&tbnid=YsJlAi1rNFAf-M&vet=12ahUKEwjT1-Gm9qz4AhW3j9gFHZl7CaUQMygAegUIARCUAQ..i&docid=MkQ3RXenzq69CM&w=240&h=240&itg=1&q=contreng%20abensi%20online&ved=2ahUKEwjT1-Gm9qz4AhW3j9gFHZl7CaUQMygAegUIARCUAQ"),
      ),
    );
    //  return null;
    final dynamicLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    Uri urlshort;
    Uri urlong;
    Uri urlungues;

    final ShortDynamicLink shortLink =
        await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
    urlshort = shortLink.shortUrl;

    urlong = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);

    final ShortDynamicLink unguessableDynamicLink =
        await FirebaseDynamicLinks.instance.buildShortLink(
      dynamicLinkParams,
      shortLinkType: ShortDynamicLinkType.unguessable,
    );
    urlungues = unguessableDynamicLink.shortUrl;

    // print('MainteacherPage createDynamicLink  dynamicLink $dynamicLink');
    print('MainteacherPage createDynamicLink urlshort $urlshort');
    // print('MainteacherPage createDynamicLink urlong $urlong');
    print('MainteacherPage createDynamicLink urlungues $urlungues');

    // FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
    // final DynamicLinkParameters parameters = DynamicLinkParameters(
    /// longDynamicLink: Uri.parse(
    //    'https://contreng.page.link/?eventcode=$eventcode&eventid=$eventid&teacherid=$teacherid&ofl=https://contreng.web.app',
    //  ),
    //  uriPrefix: 'https://contreng.page.link',
    //   link: Uri.parse(
    //       'https://contreng.page.link/kelas/?eventcode=$eventcode&eventid=$eventid&teacherid=$teacherid&ofl=https://contreng.web.app'),
//    androidParameters: AndroidParameters(
//      packageName: 'com.bingkaiapp.present',
//    ),
//  );
    // var dynamicUrl = await dynamicLinks.buildShortLink(parameters);
    // final Uri shortUrl = dynamicUrl.shortUrl;

    GlobalVar eventdatax = Get.put(GlobalVar());

    eventdatax.deeplinkx('$urlshort');
    eventdatax.ungueslinkx('$urlungues');

    return urlshort.toString();
  }
}
