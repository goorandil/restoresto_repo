import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

final userBox = GetStorage();
final packageBox = GetStorage();
final orderBox = GetStorage();
final topupBox = GetStorage();

List<dynamic> shopcartList = [].obs;

class GlobalVar extends GetxController {
  static GlobalVar get to => Get.find<GlobalVar>();

  RxString useridx = "".obs;
  RxString usernamex = "".obs;
  RxString useremailx = "".obs;
  RxString userimageurlx = "".obs;
  RxString userfcmtokenx = "".obs;

  RxString merchantidx = "".obs;
  RxString merchantnamex = "".obs;
  RxString merchantimageurlx = "".obs;
  RxString merchantaddressx = "".obs;
  RxString merchantfcmtokenx = "".obs;

  RxList categorylistx = [].obs;

  RxString eventidx = "".obs;
  RxString eventnamex = "".obs;
  RxString eventdescriptionx = "".obs;
  RxString eventcodex = "".obs;
  RxString deeplinkx = "".obs;
  RxString ungueslinkx = "".obs;
  RxString getdeeplinkx = "".obs;
  RxString getungueslinkx = "".obs;
  RxString teacheridx = "".obs;

  RxString configidx = "ckhRNRMdrjGppnNY54aI".obs;
  RxString kecilx = "10000".obs;
  RxString sedangx = "15000".obs;
  RxString besarx = "20000".obs;
  RxInt totalx = 0.obs;

  RxString tarifkotabandungkecilx = "".obs;
  RxString tarifkotabandungsedangx = "".obs;
  RxString tarifkotabandungbesarx = "".obs;
  RxString tarifkotacimahikecilx = "".obs;
  RxString tarifkotacimahisedangx = "".obs;
  RxString tarifkotacimahibesarx = "".obs;
  RxString tarifkabbandungkecilx = "".obs;
  RxString tarifkabbandungsedangx = "".obs;
  RxString tarifkabbandungbesarx = "".obs;
  RxString tarifkabbandungbaratkecilx = "".obs;
  RxString tarifkabbandungbaratsedangx = "".obs;
  RxString tarifkabbandungbaratbesarx = "".obs;

  RxString banknamex = "BRI".obs;
  RxString accountnamex = "Kurirku".obs;
  RxString accountnumberx = "123123123123".obs;

  var primary = Colors.red;
  var primaryButton = Colors.red;
  var primaryText = Colors.red;
  var primaryBg = Colors.white;
  var primaryCard = Colors.white;
}
